import 'package:flutter/material.dart';

extension TimeString on DateTime {
  String toTimeHourMinString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
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