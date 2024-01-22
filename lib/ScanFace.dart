import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:face_recognition/Student.dart';

class ScanFaceScreen extends StatefulWidget {
  const ScanFaceScreen({super.key});

  @override
  State<ScanFaceScreen> createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {

  int count = 0;
  ImagePicker picker = ImagePicker();
  XFile? image;
  late File file;

  Student? student;

  Future<void> _uploadFile(BuildContext context) async {
    if (this.image == null) {
      return;
    }
    // Create a multipart request for uploading the file
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://103.195.7.153:8000/students/predict'),
    );

    final image = this.image;
    if (image != null) {
      file = File(image.path);
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image!.path,
        filename: basename(file.path),
      ),
    );

    // Send the request
    var response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      setState(() {
        student = Student.fromJson(jsonResponse);
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Found'),
            content: const Text('មិនស្គាល់'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('យកវត្តមាន'),
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Placeholder image
                Image.asset(
                  'assets/place_holder.jpg',
                  width: 250.0, // Adjust the width as needed
                  height: 250.0, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
                // Actual image if available
                if (image != null)
                  Image.file(
                    File(image!.path),
                    width: 250.0, // Adjust the width as needed
                    height: 250.0, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                image = await picker.pickImage(source: ImageSource.camera);
                student = null;
                _uploadFile(context);
                setState(() {
                  //update UI
                });
              },
              child: const Text("ថតរូប")
          ),
          ElevatedButton(
              onPressed: () async {
                image = await picker.pickImage(source: ImageSource.gallery);
                student = null;
                _uploadFile(context);
                setState(() {
                  //update UI
                });
              },
              child: const Text("ជ្រើសរើសរូប")
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: student == null ? const Text('') : const Text('ព័ត៌មាន:', style: TextStyle(fontSize: 20)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null ? const Text('') : Text('ឈ្មោះ៖ ${student!.name}'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null ? const Text('') : Text('ឈ្មោះឡាតាំង៖ ${student!.englishName}'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null ? const Text('') : Text('ភេទ៖ ${student!.gender}'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null ? const Text('') : Text('ថ្ងៃខែឆ្នាំកំណើត៖ ${student!.dob}'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null ? const Text('') : Text('ទីកន្លែងកំណើត៖ ${student!.pob}'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null ? const Text('') : Text('អាស័យដ្ឋាន៖ ${student!.address}'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null ? const Text('') : Text('លេខទូរស័ព្ទ៖ ${student!.phone}'),
          )
        ],
      ),
    );
  }
}