import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';

// Utility function to capitalize patient name
String capitalizeName(String name) {
  return name.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

class AddHealthMetricPage extends StatefulWidget {
  const AddHealthMetricPage({super.key});

  @override
  State<AddHealthMetricPage> createState() => _AddHealthMetricPageState();
}

class _AddHealthMetricPageState extends State<AddHealthMetricPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  List<Map<String, dynamic>> patients = []; // List of patients from Firestore
  
  @override
  void initState() {
    super.initState();
    _fetchPatients(); // Fetch patient data from Firestore
  }

  // Function to fetch patients from Firestore
  Future<void> _fetchPatients() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('patients').get();
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
    return BlocListener<HealthMetricCubit, HealthMetricState>(
      listener: (context, state) {
        if (state is HealthMetricAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Health Metric added successfully."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Pop the screen after adding
        } else if (state is HealthMetricError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isPerforming = false; // Stop loading on error
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Health Metric"),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormBuilder(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      // Dropdown for selecting patient
                      FormBuilderDropdown<String>(
                        name: "patientId",
                        decoration: InputDecoration(
                          labelText: "Patient",
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        hint: const Text('Select Patient'),
                        items: patients
                            .map((patient) => DropdownMenuItem<String>(
                                  value: patient['id'],
                                  child: Text(capitalizeName(patient['name'])),
                                ))
                            .toList(),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      // Date Picker for health metric date
                      FormBuilderDateTimePicker(
                        name: "date",
                        decoration: InputDecoration(
                          labelText: 'Date of Registration',
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        inputType: InputType.date,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      // Text Fields for Health Metrics
                      _buildNumericInputField("systolicBP", "Systolic Blood Pressure"),
                      const SizedBox(height: 8),
                      _buildNumericInputField("diastolicBP", "Diastolic Blood Pressure"),
                      const SizedBox(height: 8),
                      _buildNumericInputField("heartRate", "Heart Rate"),
                      const SizedBox(height: 8),
                      _buildNumericInputField("weight", "Weight"),
                      const SizedBox(height: 8),
                      _buildNumericInputField("bloodSugar", "Blood Sugar"),
                    ],
                  ),
                ),
              ),
              // Action buttons (Cancel and Save)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isPerforming
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
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
                                if (_formKey.currentState?.saveAndValidate() ?? false) {
                                  final inputs = _formKey.currentState!.value;

                                  setState(() {
                                    _isPerforming = true;
                                  });

                                  final newHealthMetric = HealthMetric(
                                    id: '',
                                    patientId: inputs["patientId"].toString(),
                                    date: inputs["date"] as DateTime,
                                    systolicBP: double.parse(inputs["systolicBP"].toString()),
                                    diastolicBP: double.parse(inputs["diastolicBP"].toString()),
                                    heartRate: double.parse(inputs["heartRate"].toString()),
                                    weight: double.parse(inputs["weight"].toString()),
                                    bloodSugar: double.parse(inputs["bloodSugar"].toString()),
                                  );

                                  context.read<HealthMetricCubit>().addHealthMetric(newHealthMetric);
                                }
                              },
                        child: _isPerforming
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Save'),
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

  // Utility function to build numeric input fields
  Widget _buildNumericInputField(String name, String labelText) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.numeric(),
      ]),
    );
  }
}
