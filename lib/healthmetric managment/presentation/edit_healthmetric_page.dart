import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';

class EditHealthMetricPage extends StatefulWidget {
  final HealthMetric healthMetric;

  const EditHealthMetricPage({super.key, required this.healthMetric});

  @override
  State<EditHealthMetricPage> createState() => _EditHealthMetricPageState();
}

class _EditHealthMetricPageState extends State<EditHealthMetricPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;
  List<Map<String, dynamic>> patients = [];

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('patients').get();
      setState(() {
        patients = snapshot.docs
            .map((doc) => {'id': doc.id, 'name': doc['name']})
            .toList();
      });
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialValues = {
      'patientId': widget.healthMetric.patientId,
      'date': widget.healthMetric.date,
      'systolicBP': widget.healthMetric.systolicBP,
      'diastolicBP': widget.healthMetric.diastolicBP,
      'heartRate': widget.healthMetric.heartRate,
      'weight': widget.healthMetric.weight,
      'bloodSugar': widget.healthMetric.bloodSugar,
    };

    return BlocListener<HealthMetricCubit, HealthMetricState>(
      listener: (context, state) {
        if (state is HealthMetricUpdated) {
          // Show success message in a SnackBar after update completes
          final patientName = patients.firstWhere(
            (p) => p['id'] == widget.healthMetric.patientId,
            orElse: () => {'name': 'Patient'},
          )['name'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Health Metric for $patientName updated successfully!",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate back and refresh the list
          Navigator.pop(context, true);
        } else if (state is HealthMetricError) {
          // Show error message in a SnackBar
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Health Metric",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormBuilder(
                  key: _formKey,
                  initialValue: initialValues,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      FormBuilderDropdown<String>(
                        name: "patientId",
                        decoration: InputDecoration(
                          labelText: "Patient",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        hint: const Text('Select Patient'),
                        items: patients
                            .map((patient) => DropdownMenuItem<String>(
                                  value: patient['id'],
                                  child: Text(patient['name']),
                                ))
                            .toList(),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderDateTimePicker(
                        name: "date",
                        decoration: InputDecoration(
                          labelText: 'Date of Registered',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        inputType: InputType.date,
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "systolicBP",
                        decoration: InputDecoration(
                          labelText: "Systolic BP",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialValue: initialValues["systolicBP"].toString(),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "diastolicBP",
                        decoration: InputDecoration(
                          labelText: "Diastolic BP",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialValue: initialValues["diastolicBP"].toString(),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "heartRate",
                        decoration: InputDecoration(
                          labelText: "Heart Rate",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialValue: initialValues["heartRate"].toString(),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "weight",
                        decoration: InputDecoration(
                          labelText: "Weight",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialValue: initialValues["weight"].toString(),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "bloodSugar",
                        decoration: InputDecoration(
                          labelText: "Blood Sugar",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialValue: initialValues["bloodSugar"].toString(),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _isPerforming ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isPerforming
                            ? null
                            : () {
                                final isValid =
                                    _formKey.currentState!.saveAndValidate();
                                final inputs = _formKey.currentState!.value;

                                if (isValid) {
                                  setState(() => _isPerforming = true);

                                  final updatedHealthMetric = HealthMetric(
                                    id: widget.healthMetric.id,
                                    patientId: inputs["patientId"].toString(),
                                    date: inputs["date"] as DateTime,
                                    systolicBP: double.parse(
                                        inputs["systolicBP"].toString()),
                                    diastolicBP: double.parse(
                                        inputs["diastolicBP"].toString()),
                                    heartRate: double.parse(
                                        inputs["heartRate"].toString()),
                                    weight: double.parse(
                                        inputs["weight"].toString()),
                                    bloodSugar: double.parse(
                                        inputs["bloodSugar"].toString()),
                                  );

                                  context
                                      .read<HealthMetricCubit>()
                                      .editHealthMetric(updatedHealthMetric);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isPerforming
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : const Text("Update Health Metric"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
