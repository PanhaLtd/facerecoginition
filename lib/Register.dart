import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';


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
      isLoading = true; // Show the loading modal
    });
    await _uploadFile();
    await _uploadProfile();
    final url = Uri.parse('http://114.29.238.64:8000/students/addNewStudent');

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

    // Handle response
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false; // Hide the loading modal
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
      // Request failed
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
      // User canceled the file selection.
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
      // User canceled the image selection.
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
      Uri.parse('http://114.29.238.64:8000/students/addStudentVideo?student_id=$id&student_name=$name'),
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
      Uri.parse('http://114.29.238.64:8000/students/upload'),
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
      // File upload failed, show an error message.
    }
  }

  Future<void> train(BuildContext context) async {
    try {
      var response = await http.get(
        Uri.parse('http://114.29.238.64:8000/students/train'),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Model training is processing in background!'),
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
    } catch (e) {
      print('Error during request: $e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('បញ្ចូលទិន្នន័យ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'លេខសម្គាល់'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ឈ្មោះ'),
              ),
              TextField(
                controller: englishNameController,
                decoration: const InputDecoration(labelText: 'ឈ្មោះឡាតាំង'),
              ),
              Row(
                children: [
                  const Text('ភេទ:'),
                  Radio(
                    value: 'ប្រុស',
                    groupValue: genderController.text,
                    onChanged: (value) {
                      setState(() {
                        genderController.text = value!;
                      });
                    },
                  ),
                  const Text('ប្រុស'),
                  Radio(
                    value: 'ស្រី',
                    groupValue: genderController.text,
                    onChanged: (value) {
                      setState(() {
                        genderController.text = value!;
                      });
                    },
                  ),
                  const Text('ស្រី'),
                ],
              ),
              TextField(
                controller: dobController,
                decoration: const InputDecoration(labelText: 'ថ្ងៃខែឆ្នាំកំណើត'),
              ),
              TextField(
                controller: placeOfBirthController,
                decoration: const InputDecoration(labelText: 'ទីកន្លែងកំណើត'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'អាស័យដ្ឋាន'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'លេខទូរស័ព្ទ'),
              ),
              ElevatedButton.icon(
                onPressed: _selectImage,
                icon: const Icon(Icons.image),
                label: const Text('Select Image'),
              ),
              ElevatedButton.icon(
                onPressed: _selectFile,
                icon: const Icon(Icons.videocam),
                label: const Text('Take Video'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : sendData,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call fetchData with the current context
          train(context);
        },
        child: const Text('Train'),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Register(),
  ));
}