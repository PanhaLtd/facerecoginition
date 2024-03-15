import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:face_recognition/Attendance.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({Key? key}) : super(key: key);

  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  List<Attendance> attendances = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(
        Uri.parse('http://185.229.225.221:8000/students/attendance'),
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        List<Map<String, dynamic>> list = (jsonResponse['result'] as List).cast<Map<String, dynamic>>();
        List<Attendance> attendanceList = [];
        list.forEach((json) {
          attendanceList.add(Attendance(
            date: json['date'],
            id: json['id'],
            name: json['name'],
            scanTime: DateFormat.Hms().format(DateTime.parse(json['scantime'])),
          ));
        });
        setState(() {
          attendances = attendanceList;
        });
      } else {
        print("Failed to load attendance. Status code: ${response.statusCode}");
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
        title: Text('បញ្ជីវត្តមាន',
            style: GoogleFonts.khmer(
                color: const Color(0xFF0E0E5A),
                fontWeight: FontWeight.bold
            )),
      ),
      body: attendances.isNotEmpty
          ? AttendanceListScreen(attendances: attendances)
          : const Center(),
    );
  }
}

class AttendanceListScreen extends StatelessWidget {
  final List<Attendance> attendances;

  const AttendanceListScreen({super.key, required this.attendances});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            child: ListTile(
              title: Text('${attendances[index].date} ${attendances[index].name} ${attendances[index].scanTime}'),
            ),
          );
        },
      ),
    );
  }
}
