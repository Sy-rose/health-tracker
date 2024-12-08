import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_cubit.dart';
import 'package:health_metrics_tracker/patient%20management/presentation/cubit/patient_state.dart';

class EditPatientPage extends StatefulWidget {
  final Patient patient;

  const EditPatientPage({super.key, required this.patient});

  @override
  State<EditPatientPage> createState() => _EditPatientPageState();
}

class _EditPatientPageState extends State<EditPatientPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientCubit, PatientState>(
      listener: (context, state) {
        if (state is PatientUpdated) {
          // After successful update, navigate back and refresh the list
          Navigator.pop(context, true); // Pass 'true' to refresh the list
        } else if (state is PatientError) {
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
            "Edit Patient",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
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
                  initialValue: {
                    'name': widget.patient.name,
                    'age': widget.patient.age.toString(),
                    'gender': widget.patient.gender,
                    'contactInfo': widget.patient.contactInfo,
                  },
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
                          FormBuilderValidators.min(1, errorText: "Invalid age"),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderDropdown(
                        name: "gender",
                        decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: const TextStyle(color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: ['Male', 'Female', 'Other']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
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
                      const SizedBox(height: 8),
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
                                Navigator.pop(context); // Go back to previous page
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
                                final isValid = _formKey.currentState!.saveAndValidate();
                                final inputs = _formKey.currentState!.value;

                                if (isValid) {
                                  setState(() {
                                    _isPerforming = true;
                                  });

                                  final updatedPatient = Patient(
                                    id: widget.patient.id,
                                    name: inputs["name"] as String,
                                    age: int.parse(inputs["age"] as String),
                                    gender: inputs["gender"] as String,
                                    contactInfo: inputs["contactInfo"] as String,
                                  );

                                  context.read<PatientCubit>().editPatient(updatedPatient);
                                }
                              },
                        style: ElevatedButton.styleFrom(
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
                            : const Text("Update Patient"),
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
