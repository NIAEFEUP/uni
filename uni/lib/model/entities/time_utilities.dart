import 'package:flutter/material.dart';

extension TimeString on DateTime {
  String toTimeHourMinString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static List<String> getWeekdaysStrings(
      {bool startMonday = true, bool includeWeekend = true}) {
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
  DateTime getClosestMonday(){
    final DateTime day = DateUtils.dateOnly(this);
    if(day.weekday >=1 && day.weekday <= 5){
      return day.subtract(Duration(days: day.weekday-1));
    } 
    return day.add(Duration(days: DateTime.daysPerWeek - day.weekday+1));
  }
}