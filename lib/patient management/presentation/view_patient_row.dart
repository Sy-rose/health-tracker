import 'package:flutter/material.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';

class LabelValueRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const LabelValueRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text("$value"),
      ],
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LabelValueRow(label: 'Name', value: patient.name),
            LabelValueRow(label: 'Age', value: patient.age),
            LabelValueRow(label: 'Gender', value: patient.gender),
            LabelValueRow(label: 'Contact Info', value: patient.contactInfo),
          ],
        ),
      ),
    );
  }
}
