import { handleSlackCheck, performFlutterCheck } from "./lib";

export default {
	async fetch(req, env) {
		const url = new URL(req.url);

		if (req.method === "POST" && url.pathname === "/slack/check") {
			await handleSlackCheck(req, env);
			return new Response("Slack check received", { status: 200 });
		}

		url.pathname = "/__scheduled";
		url.searchParams.append("cron", "0 */6 * * *");
		return new Response(
			`To test the scheduled handler, ensure you have used the "--test-scheduled" then try running "curl ${url.href}".`,
		);
	},

	async scheduled(event, env, ctx): Promise<void> {
		console.log("Running scheduled handler at", new Date().toISOString());
		performFlutterCheck(env, false);
	},
} satisfies ExportedHandler<Env>;
