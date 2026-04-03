import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/profile/widgets/tuition_notification_switch.dart';
import 'package:uni_ui/modal/modal.dart';
import 'package:uni_ui/modal/widgets/info_row.dart';

class NotificationsDialog extends StatelessWidget {
  const NotificationsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ModalDialog(
      children: [
        Text(
          S.of(context).notifications,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        ModalInfoRow(
          title: S.of(context).fee_notification,
          trailing: const TuitionNotificationSwitch(),
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
    );
  }
}
