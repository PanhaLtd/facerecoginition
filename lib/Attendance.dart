class Attendance {
  final String date;
  final int id;
  final String name;
  final String scanTime;

  Attendance({
    required this.date,
    required this.id,
    required this.name,
    required this.scanTime,
  });

  factory Attendance.fromJsonList(Map<String, dynamic> json) {
    return Attendance(
      date: json['date'],
      id: json['id'],
      name: json['name'],
      scanTime: json['scantime'],
    );
  }
}