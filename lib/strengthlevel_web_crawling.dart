import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<Map<String, dynamic>?> readSinglePage(String workout) async {
  var url = Uri.parse('https://strengthlevel.com/strength-standards/$workout');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var html = response.body;
    var document = parse(html);
    return _documentConvertor(document);
  } else {
    print('HTTP GET 요청이 실패하였습니다. 상태 코드: ${response.statusCode}');
  }
  return null;
}

Map<String, dynamic>? _documentConvertor(Document document) {
  Map<String, dynamic>? workoutLevelData;

  var columIsHalfDivs = document.getElementsByClassName('column is-half');
  for (var columIsHalfDiv in columIsHalfDivs) {
    var tabDivs = columIsHalfDiv.getElementsByClassName('tab');
    for (var tabDiv in tabDivs) {
      if (tabDivs.last == tabDiv) {
        var tableContainerDivs =
            tabDiv.getElementsByClassName('table-container');
        for (var tableContainerDiv in tableContainerDivs) {
          var tableDivs = tableContainerDiv
              .getElementsByClassName('table is-striped is-fullwidth');
          for (var tableDiv in tableDivs) {
            var tbody = tableDiv.querySelector('tbody');
            if (tbody != null) {
              var trElements = tbody.querySelectorAll('tr');
              Map<String, dynamic> map = {};

              for (var tr in trElements) {
                List<String> list = _trConvertor(tr);
                map.addAll(_getKeyValue(list));
              }
              if (workoutLevelData == null) {
                workoutLevelData = {'male': map};
              } else {
                workoutLevelData.addAll({'female': map});
              }
            }
          }
        }
      }
    }
  }
  return workoutLevelData;
}

List<String> _trConvertor(Element tr) {
  List<String> data = [];
  List<String> trs = tr.text.split('\n');
  for (var element in trs) {
    element = element.trimLeft();
    element = element.trimRight();
    if (element != '') {
      data.add(element);
    }
  }
  return data;
}

Map<String, dynamic> _getKeyValue(List<String> data) {
  String key = data[0];
  double value = double.parse(data[1].replaceAll('x', ''));
  return {key: value};
}
