const MONTHS = {
  '01':'JAN',
  '02':'FEB',
  '03':'MAR',
  '04':'APR',
  '05':'MAY',
  '06':'JUN',
  '07':'JUL',
  '08':'AUG',
  '09':'SEP',
  '10':'OCT',
  '11':'NOV',
  '12':'DEC'
};

class Exam{
  String subject;
  String begin;
  String end;
  String rooms;
  String day;
  String examType;
  String weekDay;
  String month;
  String year;
  DateTime date;

  Exam(String schedule, String subject, String rooms, String date, String examType, String weekDay)
  {
    this.subject = subject;
    this.date = DateTime.parse(date);
    var scheduling = schedule.split('-');
    var dateSepared = date.split('-');
    this.begin = scheduling[0].replaceAll(':', 'h');
    this.end = scheduling[1].replaceAll(':', 'h');
    this.rooms = rooms;
    this.year = dateSepared[0];
    this.day = dateSepared[2];
    if(examType.contains("Port.Est.Especiais")){
      this.examType = "EE";
    }else if(examType.contains("Mini-testes")){
      this.examType = "MT";
    }else{
      this.examType = "?";
    }
    this.weekDay = weekDay;
    this.month = MONTHS[dateSepared[1]];
  }

  Exam.secConstructor(String subject, String begin, String end, String rooms, String day, String examType, String weekDay, String month, String year){
    this.subject = subject;
    this.begin = begin;
    this.end = end;
    this.rooms = rooms;
    this.day = day;
    this.examType = examType;
    this.weekDay = weekDay;
    this.month = month;
    this.year = year;

    String monthKey = MONTHS.keys.firstWhere(
            (k) => MONTHS[k] == this.month, orElse: () => null);
    print(monthKey);
    this.date = DateTime.parse(year + '-' + monthKey + '-' + day);
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'begin': begin,
      'end': end,
      'rooms': rooms,
      'day': day,
      'examType': examType,
      'weekDay': weekDay,
      'month': month,
      'year': year
    };
  }

  void printExam()
  {
    print('$subject - $year - $month - $day -  $begin-$end - $examType - $rooms - $weekDay');
  }
}