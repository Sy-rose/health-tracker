import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_metrics_tracker/core/errors/exceptions.dart';
import 'package:health_metrics_tracker/patient%20management/data/data_source/patient_remote_datasource.dart';
import 'package:health_metrics_tracker/patient%20management/data/models/patient_model.dart';
import 'package:health_metrics_tracker/patient%20management/domain/entities/patient.dart';

class PatientFirebaseRemoteDatasource implements PatientRemoteDataSource {
  final FirebaseFirestore _firestore;

  PatientFirebaseRemoteDatasource(this._firestore);

  @override
  Future<void> addPatient(Patient patient) async {
    try {
      final patientDocRef = _firestore.collection('patients').doc();
      final patientModel = PatientModel(
        id: patientDocRef.id,
        name: patient.name,
        age: patient.age,
        gender: patient.gender,
        contactInfo: patient.contactInfo,
      );
      await patientDocRef.set(patientModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred while adding patient',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deletePatient(String id) async {
    try {
      await _firestore.collection('patients').doc(id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred while deleting patient',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> editPatient(Patient patient) async {
    try {
      await _firestore.collection('patients').doc(patient.id).update({
        'name': patient.name,
        'age': patient.age,
        'gender': patient.gender,
        'contactInfo': patient.contactInfo,
      });
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred while editing patient',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<Patient> getPatientById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('patients').doc(id).get();
      if (!doc.exists) {
        throw Exception('Patient with ID $id not found');
      }
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Patient(
        id: doc.id,
        name: data['name'],
        age: data['age'],
        gender: data['gender'],
        contactInfo: data['contactInfo'],
      );
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred while fetching patient',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Patient>> getAllPatients() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('patients').get();
      if (snapshot.docs.isEmpty) {
        throw Exception('No patients found');
      }

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Patient(
          id: doc.id,
          name: data['name'],
          age: data['age'],
          gender: data['gender'],
          contactInfo: data['contactInfo'],
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message:
              e.message ?? 'Unknown error occurred while fetching patients',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  addHealthMetric(String tPatient) {}
}
