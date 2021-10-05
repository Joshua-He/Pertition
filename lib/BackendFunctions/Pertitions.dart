import 'dart:async';
import 'dart:convert';
import 'dart:io' as prefix;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';

createPertition(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/create';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

getPertitionCategory(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/getmain';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);

  return parsed;
}

getSinglePertition(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/getsingle';
  Map<String, String> headers = {"Content-type": "application/json"};
  print(info);
  Response response = await post(Uri.parse(url), headers: headers, body: info);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}

updatePertition(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/updatepertition';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

getPertitionPosts(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/getposts';
  Map<String, String> headers = {"Content-type": "application/json"};

  Response response = await post(Uri.parse(url), headers: headers, body: info);

  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}

incrementPertitionMembers(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/incrementmembers';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

incrementPertitionPoints(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/incrementpoints';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

getPertitionSingleCategory(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/getcategory';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}

getMessageOfPertition(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/comments/getmessagesofpertition';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };

  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);

  return parsed;
}

createPertitionMessage(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/comments/createpertitionmessage';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };

  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);

  return statusCode;
}
