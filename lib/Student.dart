class Student {
  final int id;
  final String name;
  final String englishName;
  final String gender;
  final String dob;
  final String pob;
  final String address;
  final String phone;
  final String imagePath;

  Student({
    required this.id,
    required this.name,
    required this.englishName,
    required this.gender,
    required this.dob,
    required this.pob,
    required this.address,
    required this.phone,
    required this.imagePath,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['result']['id'],
      name: json['result']['name'],
      englishName: json['result']['enname'],
      gender: json['result']['gender'],
      dob: json['result']['dob'],
      pob: json['result']['pob'],
      address: json['result']['address'],
      phone: json['result']['phone'],
      imagePath: json['result']['imagepath'],
    );
  }

  factory Student.fromJsonList(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      englishName: json['enname'],
      gender: json['gender'],
      dob: json['dob'],
      pob: json['pob'],
      address: json['address'],
      phone: json['phone'],
      imagePath: json['imagepath'],
    );
  }
}