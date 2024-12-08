import 'package:equatable/equatable.dart';

class HealthMetric extends Equatable {
  final String id;
  final String patientId;
  final DateTime date;
  final double systolicBP;
  final double diastolicBP;
  final double heartRate;
  final double weight;
  final double bloodSugar;



  const HealthMetric({
    required this.id,
    required this.patientId,
    required this.date,
    required this.systolicBP,
    required this.diastolicBP,
    required this.heartRate,
    required this.weight,
    required this.bloodSugar,
    // required List healthmetric,
  });

  @override
  List<Object?> get props => [
        id,
        patientId,
        date,
        systolicBP,
        diastolicBP,
        heartRate,
        weight,
        bloodSugar,
      ];

}
