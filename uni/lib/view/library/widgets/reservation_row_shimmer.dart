import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReservationRowShimmer extends StatelessWidget {
  const ReservationRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(6, 8, 0, 0),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).highlightColor,
        highlightColor: Theme.of(context).colorScheme.onPrimary,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 115),
                      Container(
                        width: 50,
                        height: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 75),
                      Container(
                        width: 130,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
