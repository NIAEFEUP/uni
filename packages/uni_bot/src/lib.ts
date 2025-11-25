import { readFromKV, saveToKV } from "./database";
import { sendFlutterVersionUpdateMessage } from "./slack";
import {
	getCurrentFlutterVersionFromPubspec,
	getLatestFlutterStableVersion,
} from "./version-fetcher";

export async function handleSlackCheck(req: Request, env: Env) {
	console.log("Manual check requested.");

	await performFlutterCheck(env, true);
}

export async function performFlutterCheck(
	env: Env,
	manualCheck: boolean,
): Promise<void> {
	const latestFlutterVersion = await getLatestFlutterStableVersion();

	console.log("Latest Flutter stable version:", latestFlutterVersion);

	const currentVersion = await getCurrentFlutterVersionFromPubspec();

	console.log("Current Flutter version in pubspec.yaml:", currentVersion);

	const lastNotifiedVersion = await readFromKV(
		"flutter_last_notified_version",
		env,
	);

	console.log("Last notified version:", lastNotifiedVersion);

	if (!manualCheck && lastNotifiedVersion === latestFlutterVersion) {
		console.log("Already notified for version", latestFlutterVersion);
		return;
	}

	if (!manualCheck && currentVersion === latestFlutterVersion) {
		console.log("Project is up to date. No notification sent.");
		return;
	}

	await sendFlutterVersionUpdateMessage(
		currentVersion,
		latestFlutterVersion,
		env,
	);

	await saveToKV("flutter_last_notified_version", latestFlutterVersion, env);
}
