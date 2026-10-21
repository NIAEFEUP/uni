import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni/generated/l10n.dart';

class AppVersionInfo extends StatefulWidget {
  const AppVersionInfo({super.key});

  @override
  State<AppVersionInfo> createState() => _AppVersionInfoState();
}

class _AppVersionInfoState extends State<AppVersionInfo> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _packageInfo,
      builder: (context, snapshot) {
        final packageInfo = snapshot.data;
        if (packageInfo == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              S
                  .of(context)
                  .version_info(packageInfo.version, packageInfo.buildNumber),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        );
      },
    );
  }
}
