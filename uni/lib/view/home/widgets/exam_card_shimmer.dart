import 'package:flutter/material.dart';

class ExamCardShimmer extends StatelessWidget {
  const ExamCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          //timestamp section
                          Container(
                            height: 15,
                            width: 40,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 2.5,
                          ),
                          Container(
                            height: 15,
                            width: 40,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    color: Colors.black,
                  ), //UC section
                  Container(
                    height: 40,
                    width: 40,
                    color: Colors.black,
                  ), //Calender add section
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 15,
                  width: 40,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 15,
                  width: 40,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 15,
                  width: 40,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 15,
                  width: 40,
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
