import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/app_locale.dart';
class DatesTile extends StatelessWidget {
  DatesTile({required this.date,required this.start,required this.end,required this.locale,super.key});
  final String date;
  final AppLocale locale;
  DateTime? start;
  DateTime? end;



  @override
  Widget build(BuildContext context) {
    if(date=='TBD'){
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          date,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    else{
      final List<String> eventperiod=EventPeriod();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            eventperiod[0],
            style: TextStyle(
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            eventperiod[1],
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 11,
            ),
          ),
        ],
      );
    }
  }

//(Belém) just plain bad.Still not working perfectly.I do not know why help i am so done:.(
  List<String> EventPeriod(){
    List<String> Period=[];
    String Timeperiod;
    String month;
    String? month1;
    String day;
    String? day1;
    String year;
    String? year1;
    if(start==null){
      Period.add("this sucks");
      Period.add(date);
      return Period;
    }
    year=start!.year.toString();
    month=Shortmonth(start!);
    day=start!.day.toString();
    if(end==null){
      Timeperiod='$day $month';
      Period.add(Timeperiod);
      Period.add(year);
      return Period;
    }
    day1=end!.day.toString();
    year1=end!.year.toString();
    month1=Shortmonth(end!);
    if(year==year1 && month1==month) {
      Timeperiod = '$day-$day1 $month';
      Period.add(Timeperiod);
      Period.add(year);
      return Period;
    }
    if(year==year1 && month1!=month){
      Timeperiod='$day $month-$day1 $month1';
      Period.add(Timeperiod);
      Period.add(year);
      return Period;
    }
    if(year1!=year){
      Timeperiod='$day $month-$day1 $month1';
      Period.add(Timeperiod);
      Period.add(year1);
      return Period;
    }
    Period.add("this sucks");
    Period.add(date);
    return Period;
  }

  String Shortmonth(DateTime date){
    return DateFormat.MMM(locale.localeCode.languageCode).format(date).replaceFirst('.', '');
  }
//100% the reason why the dates that work render with dot at the end


}
