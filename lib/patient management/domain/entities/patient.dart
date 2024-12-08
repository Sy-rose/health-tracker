import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String contactInfo;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.contactInfo,
  });

  @override
  List<Object?> get props => [id, name, age, gender, contactInfo];

  get patientIds => null;

  copyWith({required String name, required int age, required contactInfo}) {}
}
