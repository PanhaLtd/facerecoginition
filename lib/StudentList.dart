import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_recognition/Student.dart'; // Assuming you have a Person class defined

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
        appBar: AppBar(
          title: const Text('បញ្ជីឈ្មោះសិស្ស'),
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
      appBar: AppBar(
        title: const Text('ព័ត៍មានលំអិត'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: 'http://103.195.7.153:8000/students/images/${student.imagePath}',
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 250.0,
              ),
            ),
            const SizedBox(height: 12),
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
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
