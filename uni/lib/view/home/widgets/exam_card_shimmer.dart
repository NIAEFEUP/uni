import 'package:flutter/material.dart';

class ExamCardShimmer extends StatelessWidget {
  const ExamCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
            margin: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.max,
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
                              )
                            ]),
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
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  //Exam room section
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                )
              ],
            )));
  }
}
