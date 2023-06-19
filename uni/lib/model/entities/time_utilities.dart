import 'dart:io';
import 'package:flutter/material.dart

extension TimeString on DateTime {
  String toTimeHourMinString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static List<String> getWeekdaysStrings({bool startMonday = true, bool includeWeekend = true}) {

    final List<String> weekdaysPT = [
      'Segunda-Feira',
      'Terça-Feira',
      'Quarta-Feira',
      'Quinta-Feira',
      'Sexta-Feira',
      'Sábado',
      'Domingo'
    ];

    final List<String> weekdaysEN = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final String locale = Platform.localeName;

    if (!startMonday) {
      weekdaysPT.removeAt(6);
      weekdaysEN.removeAt(6);
      weekdaysPT.insert(0, 'Domingo');
      weekdaysEN.insert(0, 'Sunday');
    }

    if(locale == 'pt_PT') return includeWeekend ? weekdaysPT : weekdaysPT.sublist(0, 5);
    return includeWeekend ? weekdaysEN : weekdaysEN.sublist(0, 5);


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