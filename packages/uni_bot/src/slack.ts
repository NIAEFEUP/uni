export async function sendMessageToSlack(
	message: string,
	env: Env,
): Promise<void> {
	if (!env.SLACK_WEBHOOK) return console.warn("Slack webhook not configured");
	console.log(env);
	await fetch(env.SLACK_WEBHOOK, {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify({ text: message }),
	});
}

export async function sendFlutterVersionUpdateMessage(
	currentVersion: string,
	latestFlutterVersion: string,
	env: Env,
): Promise<void> {
	const needsUpdate = currentVersion !== latestFlutterVersion;

	if (!needsUpdate) {
		await sendMessageToSlack(
			`✅ *Flutter Version Check*\n\n` +
				`• Latest stable: *${latestFlutterVersion}*\n` +
				`• Project version: *${currentVersion}*\n\n` +
				`🎉 Flutter is up to date!`,
			env,
		);
		return;
	}

	await sendMessageToSlack(
		`🚀 *Flutter Version Check*\n\n` +
			`• Latest stable: *${latestFlutterVersion}*\n` +
			`• Project version: *${currentVersion}*\n\n` +
			`⚠️ *Update available!* UNI is behind.`,
		env,
	);
}
