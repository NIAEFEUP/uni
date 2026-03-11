import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/model/entities/current_account.dart';

class CurrentAccountParser {
  List<Unpaid> parseUnpaid(Response response) {
    final List<Unpaid> data = [];
    final document = parse(response.body);

    final tab = document.querySelector('#tab0');
    final rows = tab?.querySelectorAll('tr').skip(1) ?? [];

    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      final status = parseStatus(cells[0]);
      final acronym = cells[1].querySelector('abbr')?.text.trim() ?? '';
      final description = cells[2].text.trim();
      final date = DateTime.parse(cells[3].text.trim());
      final deadline = DateTime.parse(cells[4].text.trim());
      final value = parseAmount(cells[5].text.trim()) ?? 0;
      final amountPaid = parseAmount(cells[6].text.trim());
      final amountDue = parseAmount(cells[7].text.trim()) ?? 0;
      final interestOnLatePayment = parseAmount(cells[9].text.trim());

      data.add(
        Unpaid(
          status: status,
          acronym: acronym,
          description: description,
          date: date,
          deadline: deadline,
          value: value,
          amountPaid: amountPaid,
          amountDue: amountDue,
          interestOnLatePayment: interestOnLatePayment,
        ),
      );
    }

    return data;
  }

  List<Transaction> _parseTransactionTable(Document document, String tableId) {
    final List<Transaction> data = [];

    final tab = document.querySelector(tableId);
    final rows = tab?.querySelectorAll('tr').skip(1) ?? [];

    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      final isCredit = cells[0].attributes['colspan'] == '3';

      if (isCredit) {
        final description = cells[0].text.trim();
        final date = DateTime.parse(cells[1].text.trim());
        final deadline = cells[2].text.trim().isEmpty
            ? null
            : DateTime.parse(cells[2].text.trim());
        final debit = parseAmount(cells[3].text.trim());
        final credit = parseAmount(cells[4].text.trim());
        final missingDebit = parseAmount(cells[5].text.trim());
        final interestOnLatePayment = parseAmount(cells[6].text.trim());
        final status = cells[7].text.trim();
        final document = cells[8].text.trim();

        data.add(
          Transaction(
            description: description,
            date: date,
            deadline: deadline,
            debit: debit,
            credit: credit,
            missingDebit: missingDebit,
            interestOnLatePayment: interestOnLatePayment,
            status: status,
            document: document,
          ),
        );
      } else {
        final process = parseStatus(cells[0]);
        final acronym = cells[1].querySelector('abbr')?.text.trim() ?? '';
        final description = cells[2].text.trim();
        final date = DateTime.parse(cells[3].text.trim());
        final deadline = cells[4].text.trim().isEmpty
            ? null
            : DateTime.parse(cells[4].text.trim());
        final debit = parseAmount(cells[5].text.trim());
        final credit = parseAmount(cells[6].text.trim());
        final missingDebit = parseAmount(cells[7].text.trim());
        final interestOnLatePayment = parseAmount(cells[8].text.trim());
        final status = cells[9].text.trim();
        final document = cells[10].text.trim();

        data.add(
          Transaction(
            process: process,
            acronym: acronym,
            description: description,
            date: date,
            deadline: deadline,
            debit: debit,
            credit: credit,
            missingDebit: missingDebit,
            interestOnLatePayment: interestOnLatePayment,
            status: status,
            document: document,
          ),
        );
      }
    }
    return data;
  }

  List<Transaction> parseCertificate(Response response) {
    final document = parse(response.body);
    return _parseTransactionTable(document, '#tab1');
  }

  List<Transaction> parseLatePaymentInterest(Response response) {
    final document = parse(response.body);
    return _parseTransactionTable(document, '#tab2');
  }

  List<Transaction> parseTuitionFees(Response response) {
    final document = parse(response.body);
    return _parseTransactionTable(document, '#tab3');
  }

  List<Transaction> parseSchoolInsurance(Response response) {
    final document = parse(response.body);
    return _parseTransactionTable(document, '#tab4');
  }

  List<AccountStatement> parseAccountStatement(Response response) {
    final document = parse(response.body);
    final List<AccountStatement> data = [];

    final tab = document.querySelector('#tab5');
    final rows = tab?.querySelectorAll('tr').skip(1) ?? [];

    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      final description = cells[0].text.trim();
      final date = DateTime.parse(cells[1].text.trim());
      final debit = parseAmount(cells[2].text.trim());
      final credit = parseAmount(cells[3].text.trim());

      data.add(
        AccountStatement(
          description: description,
          date: date,
          debit: debit,
          credit: credit,
        ),
      );
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

  int? parseAmount(String text) {
    final cleaned = text
        .replaceAll('€', '')
        .replaceAll('\u00a0', '')
        .replaceAll(' ', '')
        .replaceAll(',', '');

    return int.tryParse(cleaned);
  }
}
