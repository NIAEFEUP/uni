import 'package:flutter/material.dart';

class ScheduleCardShimmer extends StatelessWidget {
  const ScheduleCardShimmer({super.key});

  Widget _getSingleScheduleWidget(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
        margin: const EdgeInsets.only(top: 8),
        child: Container(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 100,
                    color: Colors.black,
                  ), //UC section
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 15,
                    width: 150,
                    color: Colors.black,
                  ), //UC section
                ],
              ),
              Container(
                height: 15,
                width: 40,
                color: Colors.black,
              ), //Room section
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 15,
          width: 80,
          color: Colors.black,
        ), //Day of the week
        const SizedBox(
          height: 10,
        ),
        _getSingleScheduleWidget(context),
        _getSingleScheduleWidget(context),
      ],
    );
  }
}
