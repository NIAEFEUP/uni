import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/current_account/widgets/payment_webview.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

enum PaymentStatus { paid, pending, overdue }

class Transaction extends ConsumerWidget {
  const Transaction({
    super.key,
    required this.description,
    required this.date,
    this.deadline,
    required this.value,
    this.interestOnLatePayment,
    this.isUnpaid = false,
    this.paymentLink,
  });

  final String description;
  final DateTime date;
  final DateTime? deadline;
  final double value;
  final double? interestOnLatePayment;
  final bool isUnpaid;
  final String? paymentLink;

  PaymentStatus get status {
    if (deadline == null) {
      return isUnpaid ? PaymentStatus.pending : PaymentStatus.paid;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (deadline!.isBefore(today)) {
      return PaymentStatus.overdue;
    }
    return PaymentStatus.pending;
  }

  Color _dotColor(BuildContext context) => switch (status) {
    PaymentStatus.paid => BadgeColors.pl,
    PaymentStatus.pending => BadgeColors.ee,
    PaymentStatus.overdue => BadgeColors.er,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.03))],
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: paymentLink != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _dotColor(context),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  status == PaymentStatus.paid || deadline == null
                      ? "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}"
                      : "${S.of(context).due_in} ${deadline!.day.toString().padLeft(2, '0')}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.year}",
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (paymentLink != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        UniIcons.coins,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      onPressed: () {
                        sessionAsync.whenData((session) {
                          if (session != null) {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: MediaQuery.sizeOf(context).height * 0.9,
                                child: PaymentWebView(
                                  url: paymentLink!,
                                  session: session,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).failed_login),
                              ),
                            );
                          }
                        });
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(value / 100).toStringAsFixed(2)}€',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (status == PaymentStatus.overdue &&
                          interestOnLatePayment != null) ...[
                        Text(
                          '+ ${(interestOnLatePayment! / 100).toStringAsFixed(2)}€',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          S.of(context).interest_on_late_payments,
                          style: TextStyle(
                            fontSize: 8,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
