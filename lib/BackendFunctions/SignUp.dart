import 'dart:async';
import 'dart:convert';
import 'dart:io' as prefix;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

signup(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/signup';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;
  print(info);
  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  print(jsonString);
  print(statusCode);
  var parsed = jsonDecode(jsonString);
  return statusCode;
}

login(String info) async {
  print(info);
  var url = 'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/login';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  print(jsonString);
  var parsed = jsonDecode(jsonString);
  return parsed;
}

signupApple(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/signupwithapple';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  print(jsonString);
  var parsed = jsonDecode(jsonString);
  return statusCode;
}

loginApple(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/signupwithapple/loginwithapple';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}
