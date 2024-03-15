import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
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
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://185.229.225.221:8000/students/predict'),
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
                  Navigator.of(context).pop();
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
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF0E0E5A), //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text('យកវត្តមាន',
            style: GoogleFonts.khmer(
                color: const Color(0xFF0E0E5A), fontWeight: FontWeight.bold)),
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
                Image.asset(
                  'assets/place_holder.jpg',
                  width: 250.0,
                  height: 250.0,
                  fit: BoxFit.cover,
                ),
                if (image != null)
                  Image.file(
                    File(image!.path),
                    width: 250.0,
                    height: 250.0,
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
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Set the background color to white
                onPrimary: Color(0xFF0E0E5A), // Set the text color
              ),
              child: Text("ថតរូប", style: GoogleFonts.khmer(fontSize: 18.0, color: Color(0xFF0E0E5A)))),
          ElevatedButton(
              onPressed: () async {
                image = await picker.pickImage(source: ImageSource.gallery);
                student = null;
                _uploadFile(context);
                setState(() {
                  //update UI
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Set the background color to white
                onPrimary: Color(0xFF0E0E5A), // Set the text color
              ),
              child: Text("ជ្រើសរើសរូប", style: GoogleFonts.khmer(fontSize: 18.0, color: Color(0xFF0E0E5A)))),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: student == null
                ? const Text('')
                : const Text('ព័ត៌មាន:', style: TextStyle(fontSize: 20)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null
                ? const Text('')
                : Text('ឈ្មោះ៖ ${student!.name}', style: TextStyle(fontSize: 18.0)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null
                ? const Text('')
                : Text('ឈ្មោះឡាតាំង៖ ${student!.englishName}', style: TextStyle(fontSize: 18.0),),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null
                ? const Text('')
                : Text('ភេទ៖ ${student!.gender}', style: TextStyle(fontSize: 18.0)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null
                ? const Text('')
                : Text('ថ្ងៃខែឆ្នាំកំណើត៖ ${student!.dob}', style: TextStyle(fontSize: 18.0)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null
                ? const Text('')
                : Text('ទីកន្លែងកំណើត៖ ${student!.pob}', style: TextStyle(fontSize: 18.0)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null
                ? const Text('')
                : Text('អាស័យដ្ឋាន៖ ${student!.address}', style: TextStyle(fontSize: 18.0)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: student == null
                ? const Text('')
                : Text('លេខទូរស័ព្ទ៖ ${student!.phone}', style: TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    );
  }
}
