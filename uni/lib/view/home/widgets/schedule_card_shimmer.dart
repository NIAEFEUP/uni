import 'package:flutter/material.dart';


class ScheduleCardShimmer extends StatelessWidget{
  const ScheduleCardShimmer({Key? key}) : super(key: key);
  
  Widget _getSingleScheduleWidget(BuildContext context){
    return Center(
      child: Container(
          padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
          margin: const EdgeInsets.only(top: 8.0),
          child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[ //timestamp section
                              Container(
                                height: 15, 
                                width: 40, 
                                color: Colors.black,
                              ),
                              const SizedBox(height: 2.5,),
                              Container(
                                height: 15, 
                                width: 40, 
                                color: Colors.black,
                              ),

                            ],
                          )
                    ]),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(height: 25, width: 100, color: Colors.black,), //UC section
                        const SizedBox(height: 10,),
                        Container(height: 15, width: 150, color: Colors.black,), //UC section

                      ],
                    ),
                    Container(height: 15, width: 40, color: Colors.black,), //Room section
                  ],
                  )),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize:  MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(height: 15, width: 80, color: Colors.black,), //Day of the week
        SizedBox(height: 10,),
        _getSingleScheduleWidget(context),
        _getSingleScheduleWidget(context),
      ],
    );
  }
}