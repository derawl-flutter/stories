import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:stories/constants.dart';

class Serve{
  var url = kStoriesUrl;
  Future Data(params) async{

    var url_modified = Uri.parse('$url/fetch');
    http.Response response = await http.get(url_modified);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      // print(jsonResponse);
      return jsonResponse;
    }else {
      print('Request failed with status: ${response.statusCode}.');
      return 'failed';
    }
  }

  Future Suggestion(excluded_id) async{
    var url_modified = Uri.parse('$url/suggestion/$excluded_id');
    http.Response response = await http.get(url_modified);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      // print(jsonResponse);
      return jsonResponse;
    }else {
      print('Request failed with status: ${response.statusCode}.');
      return 'failed';
    }
  }

  Future FilteredData(params, search, genre) async{

    var url_modified = Uri.parse('$url/$params?search=$search&genre=$genre');
    http.Response response = await http.get(url_modified);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 'failed';
    }
  }
  
  
  Future returnStoryPages(id) async{
    var url_modified = Uri.parse('$url/fetch_detail/$id');
    http.Response response = await http.get(url_modified);

    if(response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return 'failed';
    }
  }


}

