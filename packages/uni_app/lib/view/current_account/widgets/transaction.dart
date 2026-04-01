import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/icons.dart';
import 'package:url_launcher/url_launcher.dart';

enum PaymentStatus { paid, pending, overdue }

class Transaction extends StatelessWidget {
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

  Future<void> _launchPaymentUrl() async {
    if (paymentLink == null) return;

    final Uri url = Uri.parse(paymentLink!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
    PaymentStatus.paid => Colors.green,
    PaymentStatus.pending => Colors.amber,
    PaymentStatus.overdue => Colors.red,
  };

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      ? "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"
                      : "${S.of(context).due_in} ${deadline!.year}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.day.toString().padLeft(2, '0')}",
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (paymentLink != null)
                Transform.translate(
                  offset: const Offset(14, 0),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      UniIcons.arrowSquareOut,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                    onPressed: _launchPaymentUrl,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
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
        ],
      ),
    );
  }
}
