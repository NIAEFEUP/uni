
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';


part '../../generated/model/entities/calendar_event.g.dart';

/// An event in the school calendar
@JsonSerializable()
class CalendarEvent {

  /// Creates an instance of the class [CalendarEvent]
  ///

  CalendarEvent(this.name, this.date){
    if(date!='TBD'){
      date=formatString(date);
    }
    RegExpMatch? match;
    String? day1;
    String? day2;
    String? year1;
    String? month1;
    String? month2;
    String? year2;
    final regex1 = RegExp(r'(\d{1,2}) de (\w+) de (\d{4})');
    final regex2 = RegExp(r'(\d{1,2}) a (\d{1,2}) de (\w+) de (\d{4})');
    final regex3 = RegExp(r'(\d{1,2}) de (\w+) a (\d{1,2}) de (\w+) de (\d{4})');
    final regex4=RegExp(r'(\d{1,2}) de (\w+) de (\d{4}) a (\d{1,2}) de (\w+) de (\d{4})');
    final forgot=RegExp(r'a (\d{1,2})');
    match=regex4.firstMatch(date);
    if(match!=null && match.groupCount==6){
      day1=match.group(1);
      month1=match.group(2);
      year1=match.group(3);
      day2=match.group(4);
      month2=match.group(5);
      year2=match.group(6);
      start=DateFormat('dd MMMM yyyy','pt_PT').parse('$day1 $month1 $year1');
      finish=DateFormat('dd MMMM yyyy','pt_PT').parse('$day2 $month2 $year2');
      return;
    }

    match=regex3.firstMatch(date);
    if(match!=null && match.groupCount==5){
      day1=match.group(1);
      month1=match.group(2);
      day2=match.group(3);
      month2=match.group(4);
      year1=match.group(5);
      start=DateFormat('dd MMMM yyyy','pt_PT').parse('$day1 $month1 $year1');
      finish=DateFormat('dd MMMM yyyy','pt_PT').parse('$day2 $month2 $year1');
      return;
    }
    match=regex2.firstMatch(date);
    if(match!=null && match.groupCount==4){
      day1=match.group(1);
      day2=match.group(2);
      month1=match.group(3);
      year1=match.group(4);
      start=DateFormat('dd MMMM yyyy', 'pt_PT').parse('$day1 $month1 $year1');
      finish=DateFormat('dd MMMM yyyy','pt_PT').parse('$day2 $month1 $year1');
      return;
    }
    match=regex1.firstMatch(date);
    if(match!=null && match.groupCount==3){
      day1=match.group(1);
      month1=match.group(2);
      year1=match.group(3);
      start=DateFormat('dd MMMM yyyy', 'pt_PT').parse('$day1 $month1 $year1');
    }

  }
  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  String name;
  String date;
  DateTime? start;
  DateTime? finish;

  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);

  String formatString(String date) {
    return date
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'até'),'a')
        .trim();

  }



}
