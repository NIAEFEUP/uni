import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/model/entities/current_account.dart';

class CurrentAccountParser {
  static const tabNames = {
    'unpaid': ['Despesas não saldadas', 'Unpaid expenses'],
    //'certificate': ['Certidão', 'Certidão'],
    //'latePayment': ['Juros de mora Propinas', 'Juros de mora Propinas'],
    //'tuitionFees': ['Propinas', 'Tuition fees'],
    //'schoolInsurance': ['Seguro Escolar', 'Seguro Escolar'],
    'accountStatement': ['Extrato Geral', 'Account Statement'],
  };

  String? findTableId(Document document, List<String> names) {
    final tabs = document.querySelectorAll(
      '#GPAG_CCORRENTE_GERAL_CONTA_CORRENTE_VIEW ul li a',
    );
    for (final tab in tabs) {
      if (names.contains(tab.text.trim())) {
        return tab.attributes['href'];
      }
    }
    return null;
  }

  List<Unpaid> parseUnpaid(Response response) {
    final List<Unpaid> data = [];
    final document = parse(response.body);

    final tableId = findTableId(document, tabNames['unpaid']!);

    if (tableId != null) {
      final tab = document.querySelector(tableId);
      final rows = tab?.querySelectorAll('tr').skip(1) ?? [];

      for (final row in rows) {
        final cells = row.querySelectorAll('td');
        final description = cells[2].text.trim();

        final date = DateTime.parse(cells[3].text.trim());

        final deadline = cells[4].text.trim().isEmpty
            ? null
            : DateTime.parse(cells[4].text.trim());
        final value = parseAmount(cells[5].text.trim()) ?? 0;
        final amountDue = parseAmount(cells[7].text.trim()) ?? 0;

        final anchor = cells[8].querySelector('a');
        final relativeLink = anchor?.attributes['href'];

        String? paymentLink;
        if (relativeLink != null) {
          paymentLink = 'https://sigarra.up.pt/feup/pt/$relativeLink';
        }

        final interest = cells[9].text.trim();
        double? interestOnLatePayment;

        if (interest.isNotEmpty) {
          final parts = interest.split('+');
          interestOnLatePayment = parts
              .map((p) => parseAmount(p) ?? 0.0)
              .reduce((a, b) => a + b);
        }

        data.add(
          Unpaid(
            description: description,
            date: date,
            deadline: deadline,
            value: value,
            amountDue: amountDue,
            interestOnLatePayment: interestOnLatePayment,
            paymentLink: paymentLink,
          ),
        );
      }
    }
    return data;
  }

  List<AccountStatement> parseAccountStatement(Response response) {
    final document = parse(response.body);
    final List<AccountStatement> data = [];

    final tableId = findTableId(document, tabNames['accountStatement']!);

    if (tableId != null) {
      final tab = document.querySelector(tableId);
      final rows = tab?.querySelectorAll('tbody tr') ?? [];

      for (final row in rows) {
        final cells = row.querySelectorAll('td');
        final description = cells[0].text.trim();

        final date = DateTime.parse(cells[1].text.trim());
        final credit = parseAmount(cells[3].text.trim());

        if (credit != null) {
          data.add(
            AccountStatement(
              description: description,
              date: date,
              credit: credit,
            ),
          );
        }
      }
    }

    return data;
  }

  String parseStatus(Element cell) {
    final img = cell.querySelector('img');
    final alt = img?.attributes['alt'] ?? '';

    return switch (alt) {
      'Pago' => 'Paid',
      'Não pago mas prazo ainda não foi excedido' => 'unpaid',
      'Não pago mas prazo foi excedido' => 'overdue',
      _ => 'unknown',
    };
  }

  double? parseAmount(String text) {
    final cleaned = text
        .replaceAll('€', '')
        .replaceAll('\u00a0', '')
        .replaceAll(' ', '')
        .replaceAll(',', '');

    return double.tryParse(cleaned);
  }
}
