import {
	getLatestFlutterStableVersion,
	getCurrentFlutterVersionFromPubspec,
} from "./lib";
import { saveToKV, readFromKV } from "./database";
import { sendFlutterVersionUpdateMessage, sendMessageToSlack } from "./slack";

export default {
	async fetch(req) {
		const url = new URL(req.url);
		url.pathname = "/__scheduled";
		url.searchParams.append("cron", "0 */6 * * *");
		return new Response(
			`To test the scheduled handler, ensure you have used the "--test-scheduled" then try running "curl ${url.href}".`,
		);
	},

	async scheduled(event, env, ctx): Promise<void> {
		console.log("Running scheduled handler at", new Date().toISOString());

		const latestFlutterVersion = await getLatestFlutterStableVersion();

		console.log("Latest Flutter stable version:", latestFlutterVersion);

		const currentVersion = await getCurrentFlutterVersionFromPubspec();

		console.log("Current Flutter version in pubspec.yaml:", currentVersion);

		const lastNotifiedVersion = await readFromKV("last_notified_version", env);

		console.log("Last notified version:", lastNotifiedVersion);

		if (lastNotifiedVersion === latestFlutterVersion) {
			console.log("Already notified for version", latestFlutterVersion);
			return;
		}

		if (currentVersion === latestFlutterVersion) {
			console.log("Project is up to date. No notification sent.");
			return;
		}

		await sendFlutterVersionUpdateMessage(
			currentVersion,
			latestFlutterVersion,
			env,
		);

		await saveToKV("last_notified_version", latestFlutterVersion, env);
	},
} satisfies ExportedHandler<Env>;
