import 'package:flutter/material.dart';

extension TimeString on DateTime {
  String toTimeHourMinString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static List<String> getWeekdaysStrings({bool startMonday = true, bool includeWeekend = true}) {
    final List<String> weekdays = [
      'Segunda-Feira',
      'Terça-Feira',
      'Quarta-Feira',
      'Quinta-Feira',
      'Sexta-Feira',
      'Sábado',
      'Domingo'
    ];

    if (!startMonday) {
      weekdays.removeAt(6);
      weekdays.insert(0, 'Domingo');
    }

    return includeWeekend ? weekdays : weekdays.sublist(0, 5);
  }
}

extension ClosestMonday on DateTime{
  static DateTime getClosestMonday(DateTime dateTime){
    DateTime monday = dateTime;
    monday = DateUtils.dateOnly(monday);
    //get closest monday
    if(monday.weekday >=1 && monday.weekday <= 5){
      monday = monday.subtract(Duration(days:monday.weekday-1));
    } else {
      monday = monday.add(Duration(days: DateTime.daysPerWeek - monday.weekday + 1));
    }
    return monday;
  }
}