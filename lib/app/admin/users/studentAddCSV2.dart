import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:mymosque/constant/linkapi.dart';

class CSVImportScreen extends StatefulWidget {
  const CSVImportScreen({super.key});

  @override
  _CSVImportScreenState createState() => _CSVImportScreenState();
}

class _CSVImportScreenState extends State<CSVImportScreen> {
  File? _selectedFile;
  List<List<dynamic>> _rowsAsListOfValues = [];

  Future<void> _selectFile() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    print("file: ");
    print(file);
    if (file != null) {
      setState(() {
        print("_SelectedFile ");
        _selectedFile = File(file.files.single.path!);
        print(_selectedFile);
        _loadCSV();
      });
    }
  }

  void _loadCSV() async {
    final contents = await _selectedFile!.readAsString();
    setState(() {
      _rowsAsListOfValues = const CsvToListConverter().convert(contents);
    });
  }

  void _importCSV() async {
    String url = linkUserAddCSV2;
    final fileContent = await _selectedFile!.readAsString();
    final response = await http.post(
      Uri.parse(url),
      body: {
        'file': fileContent,
      },
    );
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data imported successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(response.body),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Import'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _selectedFile == null
                ? const Center(child: Text('No file selected'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _rowsAsListOfValues[0]
                          .map((e) => DataColumn(label: Text(e.toString())))
                          .toList(),
                      rows: _rowsAsListOfValues.skip(1).map((row) {
                        return DataRow(
                          cells: row
                              .map((e) => DataCell(Text(e.toString())))
                              .toList(),
                        );
                      }).toList(),
                    ),
                  ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("select file pressed");
                  _selectFile();
                },
                child: const Text('Select File'),
              ),
              ElevatedButton(
                onPressed: () {
                  print("import file pressed");
                  _importCSV();
                },
                child: const Text('Import CSV'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
