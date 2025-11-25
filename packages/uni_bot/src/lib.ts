
import yaml from "js-yaml";

interface FlutterRelease {
	hash: string;
	channel: string;
	version: string;
	dart_sdk_version: string;
	dart_sdk_arch: string;
	release_date: string;
	archive: string;
	sha256: string;
}

interface FlutterReleasesJSON {
	base_url: string;
	current_release: {
		beta: string;
		dev: string;
		stable: string;
	};
	releases: FlutterRelease[];
}
export async function getLatestFlutterStableVersion(): Promise<string> {
	const res = await fetch(
		"https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json",
	);

	if (!res.ok) {
		throw new Error(`Failed to fetch releases: {res.status}, {res.statusText}`);
	}

	const data: FlutterReleasesJSON = await res.json();

	const stableHash = data.current_release.stable;
	const latestRelease = data.releases.find((r) => r.hash === stableHash);
	if (!latestRelease) throw new Error("Stable release not found");

	const latestVersion = latestRelease.version;

	return latestVersion;
}

export async function getCurrentFlutterVersionFromPubspec(): Promise<string> {
	const pubspecUrl =
		"https://raw.githubusercontent.com/NIAEFEUP/uni/refs/heads/develop/packages/uni_app/pubspec.yaml";
	const pubspecRes = await fetch(pubspecUrl);
	if (!pubspecRes.ok) throw new Error("Failed to fetch pubspec.yaml");

	const pubspecText = await pubspecRes.text();

	const pubspecData = yaml.load(pubspecText) as any;

	const currentVersion = pubspecData.environment?.flutter;

	if (!currentVersion) {
		throw new Error("Could not find Flutter version in pubspec.yaml");
	}

	return currentVersion;
}

