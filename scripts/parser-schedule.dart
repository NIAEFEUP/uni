import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart'; 

void main(){
  
  Future<http.Response> response = http.get('https://gist.github.com/StrykerKKD/44c897dbe1877b767cbf');

  // final response = await http.get('https://gist.github.com/StrykerKKD/44c897dbe1877b767cbf');

  var page = new File("schedule.html");
  
  
}

