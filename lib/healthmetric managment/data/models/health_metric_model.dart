import 'dart:convert';
import '../../domain/entities/health_metric.dart';

class HealthMetricModel extends HealthMetric {
  const HealthMetricModel({
    required super.id,
    required super.patientId,
    required super.date,
    required super.systolicBP,
    required super.diastolicBP,
    required super.heartRate,
    required super.weight,
    required super.bloodSugar,
  });

// Factory method to create a HealthMetricModel from a Map
  factory HealthMetricModel.fromMap(Map<String, dynamic> map) {
    return HealthMetricModel(
      id: map['id'] as String,
      patientId: map['patientId'] as String,
      date: map['date'],
      systolicBP: (map['systolicBP'] as num?)?.toDouble() ?? 0.0,
      diastolicBP: (map['diastolicBP'] as num?)?.toDouble() ?? 0.0,
      heartRate: (map['heartRate'] as num?)?.toDouble() ?? 0.0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      bloodSugar: (map['bloodSugar'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Factory method to create a HealthMetricModel from a JSON string
  factory HealthMetricModel.fromJson(String source) =>
      HealthMetricModel.fromMap(json.decode(source));

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'date': date,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'heartRate': heartRate,
      'weight': weight,
      'bloodSugar': bloodSugar,
    };
  }

  // Method to convert a HealthMetricModel to a JSON string
  String toJson() => json.encode(toMap());
}
