/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_cubit.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/presentation/cubit/health_metric_state.dart';

class AddEditHealthMetricPage extends StatefulWidget {
  final HealthMetric? healthMetric;

  const AddEditHealthMetricPage({super.key, this.healthMetric});

  @override
  State<AddEditHealthMetricPage> createState() =>
      _AddEditHealthMetricPageState();
}

class _AddEditHealthMetricPageState extends State<AddEditHealthMetricPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;
  List<Map<String, dynamic>> patients = []; // List to store patients

  @override
  void initState() {
    super.initState();
    _fetchPatients(); // Fetch the list of patients when the page loads
  }

  // Fetch patients from Firestore
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
    String appBarTitle = widget.healthMetric == null
        ? "Add New Health Metric"
        : "Edit Health Metric";
    String buttonLabel = widget.healthMetric == null
        ? "Add Health Metric"
        : "Update Health Metric";

    final initialValues = {
      'patientId': widget.healthMetric?.patientId ?? '',
      'date': widget.healthMetric?.date,
      'systolicBP': widget.healthMetric?.systolicBP ?? '',
      'diastolicBP': widget.healthMetric?.diastolicBP ?? '',
      'heartRate': widget.healthMetric?.heartRate ?? '',
      'weight': widget.healthMetric?.weight ?? '',
      'bloodSugar': widget.healthMetric?.bloodSugar ?? '',
    };

    return BlocListener<HealthMetricCubit, HealthMetricState>(
      listener: (context, state) {
        if (state is HealthMetricAdded) {
          Navigator.pop(context, "Health Metric Added Successfully.");
        } else if (state is HealthMetricError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is HealthMetricUpdated) {
          Navigator.pop(context, state.newHealthMetric);
        } else if (state is HealthMetricDelete) {
          Navigator.pop(context, "Health Metric Deleted Successfully.");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
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
                  initialValue: initialValues,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      // patientId (dropdown for patients)
                      FormBuilderDropdown<String>(
                        name: "patientId",
                        decoration: InputDecoration(
                          labelText: "Patient",
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        hint: Text('Select Patient'),
                        items: patients
                            .map((patient) => DropdownMenuItem<String>(
                                  value: patient['id'],
                                  child: Text(patient['name']),
                                ))
                            .toList(),
                        initialValue: initialValues["patientId"] as String?,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8), // Add margin

                      // date
                      FormBuilderDateTimePicker(
                        name: "date",
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        inputType: InputType.date,
                        initialValue: initialValues["date"] as DateTime?,
                      ),
                      const SizedBox(height: 8), // Add margin

                      // systolic BP
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
                      const SizedBox(height: 8), // Add margin

                      // diastolic BP
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
                      const SizedBox(height: 8), // Add margin

                      // heart rate
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
                      const SizedBox(height: 8), // Add margin

                      // weight
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
                      const SizedBox(height: 8), // Add margin

                      // blood sugar
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
                      const SizedBox(height: 8), // Add margin
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
                        onPressed: _isPerforming
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blue),
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
                        onPressed: () {
                          bool isValid = _formKey.currentState!.validate();
                          final inputs = _formKey.currentState!.instantValue;

                          if (isValid) {
                            setState(() {
                              _isPerforming = true;
                            });

                            final newHealthMetric = HealthMetric(
                              id: widget.healthMetric?.id ?? '',
                              patientId: inputs["patientId"].toString(),
                              date: inputs["date"] as DateTime,
                              systolicBP: double.tryParse(
                                      inputs["systolicBP"].toString()) ??
                                  0.0,
                              diastolicBP: double.tryParse(
                                      inputs["diastolicBP"].toString()) ??
                                  0.0,
                              heartRate: double.tryParse(
                                      inputs["heartRate"].toString()) ??
                                  0.0,
                              weight: double.tryParse(
                                      inputs["weight"].toString()) ??
                                  0.0,
                              bloodSugar: double.tryParse(
                                      inputs["bloodSugar"].toString()) ??
                                  0.0,
                            );

                            if (widget.healthMetric == null) {
                              context
                                  .read<HealthMetricCubit>()
                                  .addHealthMetric(newHealthMetric);
                            } else {
                              context
                                  .read<HealthMetricCubit>()
                                  .editHealthMetric(newHealthMetric);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Change the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isPerforming
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(buttonLabel),
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
 */