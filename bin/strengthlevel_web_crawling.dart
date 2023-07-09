import 'dart:convert';

import 'package:strengthlevel_web_crawling/data.dart';
import 'package:strengthlevel_web_crawling/strengthlevel_web_crawling.dart'
    as strengthlevel_web_crawling;

Future<void> main(List<String> arguments) async {
  var result = {};
  for (var element in keywords) {
    try {
      String workout = element;
      Map<String, dynamic>? levelData =
          await strengthlevel_web_crawling.readSinglePage(workout);
      var data = {workout: levelData};
      result.addAll(data);
      print('===============================================');
      print(DateTime.now().toString());
      print(jsonEncode(result));
    } catch (e) {
      print('===============================================');
      print(DateTime.now().toString());
      print(e);
      print('$element : 에러 발생');
    }
  }
}
