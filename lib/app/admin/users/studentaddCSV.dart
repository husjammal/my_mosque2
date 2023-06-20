import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mymosque/constant/linkapi.dart';
// import 'package:path/path.dart';

class CSVUploader extends StatefulWidget {
  const CSVUploader({super.key});

  @override
  _CSVUploaderState createState() => _CSVUploaderState();
}

class _CSVUploaderState extends State<CSVUploader> {
  String? _fileName;
  String? _filePath;
  PlatformFile? _file;

  _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _file = result.files.first;
        print("_file $_file");
        _fileName = result.files.first.name;

        print("_fileName $_fileName");
        print(result.files.first.bytes);
        print(result.files.first.size);
        print(result.files.first.extension);
        // _filePath = basename(result.files.single.name);
        _filePath = result.files.first.path;
        print("_fileName $_filePath");
      });
    }
  }

  _uploadFile() async {
    if (_fileName == null) {
      return;
    }

    String url = linkUserAddCSV;
    print("url $url");
    print("_filePath $_filePath");
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('csv', _filePath!,
        filename: _fileName));

    var response = await request.send();
    if (response.statusCode == 200) {
      // File uploaded successfully
      print("File uploaded successfully");
    } else {
      // Error uploading file
      print("Error uploading file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                print("pressed 'Select CSV File'");
                _selectFile();
              },
              child: Text('Select CSV File'),
            ),
            SizedBox(height: 16.0),
            Text(_fileName ?? 'No file selected'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                print("pressed 'Upload CSV File'");
                _uploadFile();
              },
              child: Text('Upload CSV File'),
            ),
          ],
        ),
      ),
    );
  }
}
