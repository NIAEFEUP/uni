import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;


/* A future represents some information that we
dont have yet and is being obtained asynchronously.
For example, in the code below, we get via http
the contents of a "to do" card (through a dummy API).
As the http request is done asynchronously, we cannot
do anything with that information right away. As such,
we return a future which will then let us use that
data through the methods 'then' and 'catchError' (as 
seen on the 'main' function.
*/

Future<String> getTodo() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/todos/1');
  if (response.statusCode == 200) {
    return json.decode(response.body).toString();
  }else{
    throw new Exception("Failed to get response");
  }
}

void main() {
 	getTodo()
   .then((result) => print(result))
   .catchError((error) => print('Gave the following error:\n$error'));
}