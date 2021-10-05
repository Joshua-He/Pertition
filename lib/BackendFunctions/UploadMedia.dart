import 'dart:async';
import 'dart:convert';
import 'dart:io' as prefix;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

uploadFile(String path, String userid) async {
  var url = 'https://s3.us-west-2.amazonaws.com/pertition-media-testing';

  var request = http.MultipartRequest('POST', Uri.parse(url));

  request.files.add(await http.MultipartFile.fromPath('file', path));

  request.fields.addAll({
    'key': (path + "/$userid" + "-" + "${request.files[0].filename}")
        .split('/')
        .last,
    'acl': 'public-read',
  });

  await request.send();
  /*
  final response = await retry(
    // Make a GET request
    () => request.send(),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is prefix.SocketException || e is TimeoutException,
  );
  */

  return ("$url" + "/$userid" + "-" + "${request.files[0].filename}");
}

pickFile() async {
  List<PlatformFile> files;
  FilePickerResult result = await FilePicker.platform
      .pickFiles(allowMultiple: false, type: FileType.video);

  if (result != null) {
    files = result.files.toList();
  } else {
    // User canceled the picker
  }

  return result.paths;
}

///Delete
deleteMedia(String info) async {
  var url =
      'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/deletemedia';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = info;
  print(info);
  http.Response response =
      await http.post(Uri.parse(url), headers: headers, body: json);
  int statusCode = response.statusCode;
  String jsonString = response.body;

  var parsed = jsonDecode(jsonString);
  return statusCode;
}

uploadPicturePertition(String pertitionName) async {
  var image;
  String base64Image;
  var picked = await FilePicker.platform
      .pickFiles(allowMultiple: false, type: FileType.image);
  if (picked != null) {
    image = prefix.File(picked.paths[0]);
    base64Image = base64Encode(image.readAsBytesSync());
    var url =
        'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/pertitions/uploadpicture';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{"picture": "$base64Image", "pertitionid": "$pertitionName"}';
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: json);
    print(response.statusCode);
    //print(response.body);
    var parsed = jsonDecode(response.body);
    var parsed2 = jsonDecode(parsed['body']);
    print(parsed2['Location']);
    return parsed2['Location'];
  } else {
    // User canceled the picker
  }
}

uploadProfilePicture(String userid) async {
  var image;
  String base64Image;
  var picked = await FilePicker.platform
      .pickFiles(allowMultiple: false, type: FileType.image);
  if (picked != null) {
    image = prefix.File(picked.paths[0]);
    base64Image = base64Encode(image.readAsBytesSync());
    var url =
        'https://29bbbetk3g.execute-api.us-west-2.amazonaws.com/beta/user/uploadprofile';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"picture": "$base64Image", "userid": "$userid"}';
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: json);

    //print(response.body);
    var parsed = jsonDecode(response.body);
    var parsed2 = jsonDecode(parsed['body']);
    print(parsed2['Location']);
    return parsed2['Location'];
  } else {
    // User canceled the picker
  }
}
