import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/navigation_service.dart';

class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).logout),
      content: Text(S.of(context).confirm_logout),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).no),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            NavigationService.logoutAndPopHistory();
          },
          child: Text(S.of(context).yes),
        ),
      ],
    );
  }
}
