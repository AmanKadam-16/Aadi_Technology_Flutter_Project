class FormDetails {
  final int id;
  final String empName;
  final String email;
  final String birthDate;
  final String designation;
  final String gender;

  FormDetails({
    required this.id,
    required this.empName,
    required this.email,
    required this.birthDate,
    required this.designation,
    required this.gender,
  });

  factory FormDetails.fromJson(Map<String, dynamic> json) {
    return FormDetails(
      id: json['ID'],
      empName: json['EmpName'],
      email: json['Email'],
      birthDate: json['BirthDate'],
      designation: json['Designation'],
      gender: json['Gender'],
    );
  }
}
