import 'dart:async';
import 'dart:convert';
import 'dart:io' as prefix;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

uploadPost(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/uploadpost';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };
  String json = info;

  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

getPostsMain(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/getmainposts';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };

  String json = info;

  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}

incrementPostNumberOfTrees(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/post/incrementtrees';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };

  String json = info;

  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return parsed;
}

getCommentsOfPost(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/comments/getcommentsofpost';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };

  String json = info;

  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);

  return parsed;
}

createComment(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/comments/createcomment';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };

  String json = info;

  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

///userid time created
deletePost(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/deletepost';
  Map<String, String> headers = {
    "Content-type": "application/json; charset=UTF-8"
  };

  String json = info;

  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}
