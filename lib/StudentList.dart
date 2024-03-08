import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_recognition/Student.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(
        Uri.parse('http://103.195.7.153:8000/students'),
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        List<Map<String, dynamic>> list = (jsonResponse['result'] as List).cast<Map<String, dynamic>>();
        List<Student> studentList = [];
        list.forEach((json) {
          studentList.add(Student(
            id: json['id'],
            name: json['name'],
            englishName: json['enname'],
            gender: json['gender'],
            dob: json['dob'],
            pob: json['pob'],
            address: json['address'],
            phone: json['phone'],
            imagePath: json['imagepath'],
          ));
        });
        setState(() {
          students = studentList;
        });
      } else {
        print("Failed to load students. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
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
          title: Text('បញ្ជីឈ្មោះសិស្ស',
                style: GoogleFonts.khmer(
                color: const Color(0xFF0E0E5A),
                fontWeight: FontWeight.bold
              )),
        ),
        body: students.isNotEmpty
            ? StudentListScreen(students: students)
            : const Center(),
    );
  }
}

class StudentListScreen extends StatelessWidget {
  final List<Student> students;

  const StudentListScreen({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            child: ListTile(
              title: Text(' ${students[index].id} ${students[index].name}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentDetailScreen(student: students[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF0E0E5A), //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text('ព័ត៍មានលំអិត',
            style: GoogleFonts.khmer(
                color: const Color(0xFF0E0E5A),
                fontWeight: FontWeight.bold
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white, // Set the color of the border
                    width: 6.0, // Set the width of the border
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(105.0),
                  child: CachedNetworkImage(
                    imageUrl: 'http://103.195.7.153:8000/students/images/${student.imagePath}',
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 210.0,
                    width: 210.0,
                  ),
                ),
              )
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('លេខសម្គាល់: ${student.id}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 7),
                    Text('ឈ្មោះ: ${student.name}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 7),
                    Text('ឈ្មោះឡាតាំង: ${student.englishName}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 7),
                    Text('ភេទ: ${student.gender}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 7),
                    Text('ថ្ងៃខែឆ្នាំកំណើត: ${student.dob}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 7),
                    Text('ទីកន្លែងកំណើត: ${student.pob}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 7),
                    Text('អាស័យដ្ឋាន: ${student.address}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 7),
                    Text('លេខទូរស័ព្ទ: ${student.phone}', style: const TextStyle(fontSize: 20))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
