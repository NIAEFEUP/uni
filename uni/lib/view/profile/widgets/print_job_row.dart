import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/print_job.dart';
import 'package:uni/model/providers/print_provider.dart';
import 'package:uni/model/providers/session_provider.dart';

class PrintJobRow extends StatelessWidget {
  final PrintJob job;

  const PrintJobRow({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session =
        Provider.of<SessionProvider>(context, listen: false).session;
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
              child: Text(job.filename,
                  overflow: TextOverflow.fade, maxLines: 1, softWrap: false)),
          const SizedBox(width: 10),
          Text(job.colors ? "Cores" : "Preto e Branco"),
          const SizedBox(width: 10),
          Text(job.size),
          const SizedBox(width: 10),
          Text("${job.cost.toString()} €"),
          const SizedBox(width: 10),
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () =>
                  Provider.of<PrintProvider>(context, listen: false)
                      .cancelJob(job, session),
              icon: const Icon(Icons.cancel))
        ],
      ),
    );
  }
}
