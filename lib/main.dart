import 'package:face_recognition/AttendanceList.dart';
import 'package:face_recognition/Register.dart';
import 'package:face_recognition/ScanFace.dart';
import 'package:face_recognition/StudentList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: const Color(0xFF0E0E5A),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1F1),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 7,
              color: Colors.white,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_alt,
                      size: 40.0,
                      color: Color(0xFF0E0E5A),
                    ),
                    const SizedBox(width: 8.0),
                    Text('ប្រព័ន្ធគ្រប់គ្រងវត្តមានសិស្ស',
                        style: GoogleFonts.khmer(
                            color: const Color(0xFF0E0E5A),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold)),
                  ],
                )
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFFDADADA),
              child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: <Widget>[
                    HomeButton(
                      icon: Icons.camera_enhance_outlined,
                      name: 'យកវត្តមាន',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScanFaceScreen()),
                        );
                      },
                    ),
                    HomeButton(
                      icon: Icons.app_registration_rounded,
                      name: 'បញ្ចូលទិន្នន័យ',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                    ),
                    HomeButton(
                      icon: Icons.list,
                      name: 'បញ្ជីឈ្មោះសិស្ស',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentList()),
                        );
                      },
                    ),
                    HomeButton(
                      icon: Icons.list_alt,
                      name: 'បញ្ជីវត្តមាន',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AttendanceList()),
                        );
                      },
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final void Function() onPressed;

  const HomeButton({
    Key? key,
    required this.name,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: const Color(0xFF0E0E5A),
              ),
              Text(
                name,
                style: GoogleFonts.khmer(
                  color: const Color(0xFF0E0E5A),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
