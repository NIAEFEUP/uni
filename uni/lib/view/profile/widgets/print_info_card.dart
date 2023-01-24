import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/print_provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/profile/widgets/create_print_mb_dialog.dart';
import 'package:uni/view/profile/widgets/login_print_service_dialog.dart';
import 'package:uni/view/profile/widgets/print_job_row.dart';

class PrintInfoCard extends GenericCard {
  PrintInfoCard({Key? key}) : super(key: key);

  const PrintInfoCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Consumer2<SessionProvider, PrintProvider>(
      builder: (context, sessionProvider, printProvider, _) {
        printProvider.getUserJobs(Completer<void>(), sessionProvider.session);

        if (!sessionProvider.isLoggedInPrintService) {
          return notLoggedInContent(context);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Table(
                columnWidths: const {
                  1: FractionColumnWidth(0.4),
                  2: FractionColumnWidth(.1)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 20.0),
                      child: Text('Valor disponível: ',
                          style: Theme.of(context).textTheme.subtitle2),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        child: Text("${printProvider.printBalance} €",
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline6)),
                    Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        height: 30,
                        child: addMoneyButton(context))
                  ])
                ]),
            const SizedBox(height: 10),
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text('Trabalhos em espera',
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.right))),
            Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 10.0, left: 20.0, right: 10),
                child: printProvider.jobs.isNotEmpty
                    ? Column(
                        children: printProvider.jobs
                            .map((job) => PrintJobRow(job: job))
                            .toList(),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text('Nenhum trabalho em espera'))),
            //showLastRefreshedTime(
            //    printProvider.printRefreshTime, context),
          ],
        );
      },
    );
  }

  Widget addMoneyButton(BuildContext context) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: () => addMoneyDialog(context),
      child: const Center(child: Icon(Icons.add)),
    );
  }

  Widget notLoggedInContent(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/images/papercut.png'),
                    height: 50),
                Text('PaperCut', style: Theme.of(context).textTheme.headline5),
                const SizedBox(height: 20),
                Text('Serviço de impressão e cópias ainda sem sessão iniciada',
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => loginDialog(context),
                  child: const Text('Iniciar sessão'),
                )
              ],
            )));
  }

  void loginDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LoginPrintService();
        });
  }

  @override
  String getTitle() => 'Impressões';

  @override
  onClick(BuildContext context) {}
}
