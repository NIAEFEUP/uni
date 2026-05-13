import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/current_account/widgets/payment_webview.dart';
import 'package:uni_ui/cards/generic_card.dart';
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
    return GenericCard(
      tooltip: description,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              Row(
                spacing: 8,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _dotColor(context),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Text(
                    status == PaymentStatus.paid || deadline == null
                        ? "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}"
                        : "${S.of(context).due_in} ${deadline!.day.toString().padLeft(2, '0')}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.year}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          Text(description, style: Theme.of(context).textTheme.titleLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              Row(
                spacing: 8,
                children: [
                  Icon(
                    UniIcons.coins,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 18,
                  ),
                  Text(
                    '${(value / 100).toStringAsFixed(2)} €',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (status == PaymentStatus.pending &&
                      interestOnLatePayment != null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+ ${(interestOnLatePayment! / 100).toStringAsFixed(2)} €',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                        ),
                        Text(
                          S.of(context).interest_on_late_payments,
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              if (paymentLink != null)
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: MediaQuery.sizeOf(context).height * 0.9,
                        child: PaymentWebView(url: paymentLink!),
                      ),
                    );
                  },
                  child: Text(
                    S.of(context).pay,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
