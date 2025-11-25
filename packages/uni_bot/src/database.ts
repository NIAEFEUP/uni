export async function saveToKV(key: string, value: string, env: any) {
	await env.APPSTATE.put(key, value);
}

export async function readFromKV(key: string, env: any): Promise<string> {
	const value = await env.APPSTATE.get(key);

	return value;
}
