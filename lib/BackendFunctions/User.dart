import 'dart:async';
import 'dart:convert';
import 'dart:io' as prefix;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';

getSingleUserInfo(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/user/getuserinfo';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}

getSingleUserPosts(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/user/getposts';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;
  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}

updateUserProfilePicture(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/user/uploadprofile/updatedb';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

updateUserNumberOfPosts(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/user/update/numberofposts';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

incrementUserNumberOfTrees(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/user/incrementtrees';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

confirmUserPhone(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/confirmphone';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;

  Response response = await post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}
