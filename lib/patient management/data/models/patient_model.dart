import 'dart:convert';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';


class PatientModel extends Patient {
  const PatientModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.contactInfo,
  });

  // Factory method to create a PatientModel from a Map
  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      contactInfo: map['contactInfo'],
    );
  }

  // Factory method to create a PatientModel from a JSON string
  factory PatientModel.fromJson(String source) {
    return PatientModel.fromMap(json.decode(source));
  }

  // Method to convert a PatientModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'contactInfo': contactInfo,
    };
  }

  // Method to convert a PatientModel to a JSON string
  String toJson() {
    return json.encode(toMap());
  }
}
