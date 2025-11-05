import 'package:flutter/widgets.dart';
import 'package:uni_ui/theme.dart';

class ModalEnrollementInfo extends StatelessWidget {
  const ModalEnrollementInfo({required this.enrollements});

  final Map<String, String> enrollements;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).divider, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Enrollments", style: Theme.of(context).bodyMedium),
          Wrap(
            spacing: 1,
            direction: Axis.horizontal,
            children:
                enrollements.entries.map((entry) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.key, style: Theme.of(context).bodyLarge),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        margin: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).primaryVibrant,
                        ),
                        child: Text(
                          entry.value,
                          style: Theme.of(context).titleSmall,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
