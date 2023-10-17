import 'dart:io';
import 'package:face_recognition/person.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MaterialApp(
  home: Home()
));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int count = 0;
  ImagePicker picker = ImagePicker();
  XFile? image;

  Person person = new Person("ឡុង បញ្ញា", "Long Panha", "ប្រុស", "2000-03-07", "ស្រុកខ្សាច់កណ្តាល ខេត្តកណ្តាល", "ខណ្ឌសែនសុខ ភ្នំពេញ", "098-989-898");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition'),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            height: 250.0,
            child: image == null ? Container() : Image.file(File(image!.path)),
          ),
          ElevatedButton(
              onPressed: () async {
                image = await picker.pickImage(source: ImageSource.camera);
                setState(() {
                  //update UI
                });
              },
              child: Text("ថតរូប")
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text('ព័ត៌មាន:'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('ឈ្មោះ៖ ${person.name}'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('ឈ្មោះឡាតាំង៖ ${person.englishName}'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('ភេទ៖៖ ${person.gender}'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('ថ្ងៃខែឆ្នាំកំណើត៖ ${person.dob}'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('ទីកន្លែងកំណើត៖ ${person.pob}'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('អាស័យដ្ឋាន៖ ${person.address}'),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('លេខទូរស័ព្ទ៖ ${person.phone}'),
          )
        ],
      ),
    );
  }
}

