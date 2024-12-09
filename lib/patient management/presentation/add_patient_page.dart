import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  String capitalizeWords(String input) {
    return input
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientCubit, PatientState>(
      listener: (context, state) {
        if (state is PatientAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${state.patientName}  added successfully."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Pass 'true' to refresh the list
        } else if (state is PatientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isPerforming = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add New Patient",
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
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
                      FormBuilderTextField(
                        name: "name",
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "age",
                        decoration: InputDecoration(
                          labelText: "Age",
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.min(1,
                              errorText: "Invalid age"),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderDropdown<String>(
                        name: "gender",
                        decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: ['Male', 'Female', 'Other']
                            .map(
                              (gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: "contactInfo",
                        decoration: InputDecoration(
                          labelText: "Contact Number",
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: FormBuilderValidators.required(),
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
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final inputs =
                                      _formKey.currentState!.instantValue;
                                  final formattedName =
                                      capitalizeWords(inputs["name"] as String);
                                  setState(() {
                                    _isPerforming = true;
                                  });

                                  final newPatient = Patient(
                                    id: '', // Placeholder ID
                                    name: formattedName,
                                    age:
                                        int.tryParse(inputs["age"] as String) ??
                                            0,
                                    gender: inputs["gender"] as String,
                                    contactInfo:
                                        inputs["contactInfo"] as String,
                                  );
                                  context
                                      .read<PatientCubit>()
                                      .addPatient(newPatient);
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
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Add Patient"),
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
