import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:collection';

Future<Map<String, String>> parseCourses(http.Response response) async{

  var document = await parse(response.body);

  Map<String, String> coursesStates = new HashMap();
  
  var courses = document.querySelectorAll('.estudantes-caixa-lista-cursos > div');

  for(int i = 0; i < courses.length; i++){
    var div = courses[i];
    var course = div.querySelector('.estudante-lista-curso-nome > a').text;
    var state = div.querySelectorAll('.formulario td')[3].text;

    coursesStates.putIfAbsent(course, () => state);
  }

  return coursesStates;
}