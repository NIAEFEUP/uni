export async function sendMessageToSlack(message: string, env: any): Promise<void> {
	if (!env.SLACK_WEBHOOK) return console.warn("Slack webhook not configured");
	console.log(env)
	await fetch(env.SLACK_WEBHOOK, {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify({ text: message }),
	});
}

export async function sendFlutterVersionUpdateMessage(currentVersion: string, latestFlutterVersion: string, env: any): Promise<void> {
	await sendMessageToSlack(
		`🚀 *Flutter Version Check*\n\n` +
		`• Latest stable: *${latestFlutterVersion}*\n` +
		`• Project version: *${currentVersion}*\n\n` +
		`⚠️ *Update available!* Your project is behind.`,
		env
	);
}
