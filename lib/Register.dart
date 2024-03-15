import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _AddNewStudentScreenState createState() => _AddNewStudentScreenState();
}

class _AddNewStudentScreenState extends State<Register> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController englishNameController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String imagePath = '';
  late File _selectedImage;
  String videoPath = '';
  bool isLoading = false;

  Future<void> sendData() async {
    setState(() {
      isLoading = true;
    });
    await _uploadFile();
    await _uploadProfile();
    final url = Uri.parse('http://185.229.225.221:8000/students/addNewStudent');

    Map<String, dynamic> requestData = {
      "student": {
        "id": idController.text,
        "name": nameController.text,
        "dob": dobController.text,
        "gender": genderController.text,
        "enname": englishNameController.text,
        "pob": placeOfBirthController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "imagepath": imagePath,
      }
    };

    final response = await http.post(
      url,
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        idController.clear();
        nameController.clear();
        dobController.clear();
        placeOfBirthController.clear();
        genderController.clear();
        englishNameController.clear();
        addressController.clear();
        phoneController.clear();
        videoPath = '';
      });
    } else {
      print('Failed to send data. Error: ${response.statusCode}');
    }
  }

  late File _selectedFile;

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
      });
    } else {
    }
  }

  Future<void> _selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File image = File(result.files.single.path!);
      setState(() {
        _selectedImage = image;
      });
    } else {
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      return;
    }

    int? id = int.tryParse(idController.text);
    String name = englishNameController.text.toLowerCase().replaceAll(' ', '_');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://185.229.225.221:8000/students/addStudentVideo?student_id=$id&student_name=$name'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        _selectedFile.path,
        filename: basename(_selectedFile.path),
      ),
    );

    await request.send();
  }

  Future<void> _uploadProfile() async {
    if (_selectedImage == null) {
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://185.229.225.221:8000/students/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _selectedImage.path,
        filename: basename(_selectedImage.path),
      ),
    );

    http.Response response;
    try {
      response = await http.Response.fromStream(await request.send());
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      imagePath = responseBody['image_url'];
    } catch (e) {
      print('Error during request: $e');
      return;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      setState(() {
        imagePath = responseBody['image_url'];
      });
    } else {
    }
  }

  Future<void> train(BuildContext context) async {
    try {
      var response = await http.get(
        Uri.parse('http://185.229.225.221:8000/students/train'),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content:
                  const Text('Model training is processing in background!'),
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
    } catch (e) {
      print('Error during request: $e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF0E0E5A),
        ),
        backgroundColor: Colors.white,
        title: Text('បញ្ចូលទិន្នន័យ',
            style: GoogleFonts.khmer(
                color: const Color(0xFF0E0E5A), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white
            ),
            child: Column(
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'លេខសម្គាល់', labelStyle: TextStyle(fontSize: 18)),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'ឈ្មោះ', labelStyle: TextStyle(fontSize: 18)),
                ),
                TextField(
                  controller: englishNameController,
                  decoration: const InputDecoration(labelText: 'ឈ្មោះឡាតាំង', labelStyle: TextStyle(fontSize: 18)),
                ),
                Row(
                  children: [
                    const Text('ភេទ:', style: TextStyle(fontSize: 18)),
                    Radio(
                      value: 'ប្រុស',
                      groupValue: genderController.text,
                      onChanged: (value) {
                        setState(() {
                          genderController.text = value!;
                        });
                      },
                    ),
                    const Text('ប្រុស', style: TextStyle(fontSize: 18)),
                    Radio(
                      value: 'ស្រី',
                      groupValue: genderController.text,
                      onChanged: (value) {
                        setState(() {
                          genderController.text = value!;
                        });
                      },
                    ),
                    const Text('ស្រី', style: TextStyle(fontSize: 18)),
                  ],
                ),
                TextField(
                  controller: dobController,
                  decoration:
                  const InputDecoration(labelText: 'ថ្ងៃខែឆ្នាំកំណើត', labelStyle: TextStyle(fontSize: 18)),
                ),
                TextField(
                  controller: placeOfBirthController,
                  decoration: const InputDecoration(labelText: 'ទីកន្លែងកំណើត', labelStyle: TextStyle(fontSize: 18)),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'អាស័យដ្ឋាន', labelStyle: TextStyle(fontSize: 18)),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'លេខទូរស័ព្ទ', labelStyle: TextStyle(fontSize: 18)),
                ),
                Container(
                  width: 200.0,
                  margin: const EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _selectImage,
                    icon: const Icon(Icons.image, color: Color(0xFF0E0E5A),),
                    label: Text('ជ្រើសរើសរូប', style: GoogleFonts.khmer(
                      color: const Color(0xFF0E0E5A),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDADADA),
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _selectFile,
                    icon: const Icon(Icons.videocam, color: const Color(0xFF0E0E5A),),
                    label: Text('ជ្រើសរើសវីដេអូ', style: GoogleFonts.khmer(
                      color: const Color(0xFF0E0E5A),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDADADA),
                    ),
                  ),
                ),
                Container(
                  width: 120.0,
                  height: 40,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : sendData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E0E5A),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : Text('បញ្ចូន', style:  GoogleFonts.khmer(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          train(context);
        },
        backgroundColor: const Color(0xFF0E0E5A),
        child: const Text('Train', style: TextStyle(fontSize: 16, color: Colors.white),),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Register(),
  ));
}
