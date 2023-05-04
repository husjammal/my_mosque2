import "dart:convert";
import "package:http/http.dart";
import 'package:flutter/material.dart';

// class UpdateMosqueFormPage extends StatefulWidget {
// @override
// _UpdateMosqueFormPageState createState() => _UpdateMosqueFormPageState();
// }

// class _UpdateMosqueFormPageState extends State<UpdateMosqueFormPage> {
// final _formKey = GlobalKeyState>();

// String value1; // value-1
// String value2; // value-2
// String value3; // value-3
// // ... other variables for the remaining columns

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
// title: Text('Update Mosque Marks'),
// ),
// body: Padding(
// padding: EdgeInsets.all(16.0),
// child: Form(
// key: _formKey,
// child: GridView.count(
// crossAxisCount: 2, // 2 columns in a row
// childAspectRatio: 3, // aspect ratio between height and width of each cell
// crossAxisSpacing: 10,
// mainAxisSpacing: 10,
// children: [
// Text('ID'), // value-1
// TextFormField(
// validator: (value) {
// if (value.isEmpty) {
// return 'Please enter ID';
// }
// return null;
// },
// onChanged: (value) {
// value1 = value;
// },
// ),
// Text('Subuh'), // value-2
// TextFormField(
// validator: (value) {
// if (value.isEmpty) {
// return 'Please enter Subuh value';
// }
// return null;
// },
// onChanged: (value) {
// value2 = value;
// },
// ),
// Text('Zhur'), // value-3
// TextFormField(
// validator: (value) {
// if (value.isEmpty) {
// return 'Please enter Zhur value';
// }
// return null;
// },
// onChanged: (value) {
// value3 = value;
// },
// ),
// // ... other cells for the remaining columns
// ],
// ),
// ),
// ),
// floatingActionButton: FloatingActionButton(
// onPressed: () {
// if (_formKey.currentState.validate()) {
// // Submit the form data to the database via API call (using http package)
// Uri url = Uri.parse('https://your-api-endpoint.com/update-mosque-marks');
// Map, dynamic> body = {
// 'id': value1,
// 'subuh': value2,
// 'zhur': value3,
// // ... other key-value pairs for the remaining columns
// };
// http.put(
// url,
// body: json.encode(body),
// headers: {'Content-Type': 'application/json'},
// ).then((response) {
// // Handle the response
// print('Response body: ${response.body}');
// }).catchError((error) {
// // Handle the error
// print('Error occured: $error');
// });
// }
// },
// child: Icon(Icons.save),
// ),
// );
// }
// }
