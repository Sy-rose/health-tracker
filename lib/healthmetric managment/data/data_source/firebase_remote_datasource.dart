import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_metrics_tracker/core/errors/exceptions.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/data/data_source/health_metric_remote_datasource.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/data/models/health_metric_model.dart';
import 'package:health_metrics_tracker/healthmetric%20managment/domain/entities/health_metric.dart';

class HealthMetricFirebaseRemoteDatasource
    implements HealthMetricRemoteDataSource {
  final FirebaseFirestore _firestore;

  HealthMetricFirebaseRemoteDatasource(this._firestore);

  @override
  Future<void> addHealthMetric(HealthMetric healthMetric) async {
    try {
      final healthMetricDocRef = _firestore.collection('health_metrics').doc();
      final healthMetricModel = HealthMetricModel(
        id: healthMetricDocRef.id,
        patientId: healthMetric.patientId,
        date: healthMetric.date,
        systolicBP: healthMetric.systolicBP,
        diastolicBP: healthMetric.diastolicBP,
        heartRate: healthMetric.heartRate,
        weight: healthMetric.weight,
        bloodSugar: healthMetric.bloodSugar,
      );
      await healthMetricDocRef.set(healthMetricModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<HealthMetric>> getAllHealthMetrics() async {
    try {
      QuerySnapshot snapshot = await _firestore
        .collection('health_metrics')
        .orderBy('date', descending: true) // Order by 'date' in descending order
        .get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return HealthMetric(
          id: doc.id,
          patientId: data['patientId'],
          date: (data['date'] as Timestamp).toDate(),
          systolicBP: data['systolicBP'].toDouble(),
          diastolicBP: data['diastolicBP'].toDouble(),
          heartRate: data['heartRate'].toDouble(),
          weight: data['weight'].toDouble(),
          bloodSugar: data['bloodSugar'].toDouble(),
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> deleteHealthMetric(String id) async {
    try {
      await _firestore.collection('health_metrics').doc(id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> editHealthMetric(HealthMetric healthMetric) async {
    try {
      await _firestore
          .collection('health_metrics')
          
          .doc(healthMetric.id)
          .update({
        'patientId': healthMetric.patientId,
        'date': healthMetric.date,
        'systolicBP': healthMetric.systolicBP,
        'diastolicBP': healthMetric.diastolicBP,
        'heartRate': healthMetric.heartRate,
        'weight': healthMetric.weight,
        'bloodSugar': healthMetric.bloodSugar,
      });
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<HealthMetric> getHealthMetricById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('health_metrics').doc(id).get();
      if (!doc.exists) {
        throw APIException(
            message: 'Health metric with ID $id not found', statusCode: '404');
      }
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return HealthMetric(
        id: data['id'],
        patientId: data['patientId'],
        date: (data['date'] as Timestamp).toDate(),
        systolicBP: data['systolicBP'],
        diastolicBP: data['diastolicBP'],
        heartRate: data['heartRate'],
        weight: data['weight'],
        bloodSugar: data['bloodSugar'],
      );
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<HealthMetric>> getHealthMetricByPatientId(
      String patientId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('health_metrics')
          .where('patientId', isEqualTo: patientId)
          .get();

      if (snapshot.docs.isEmpty) {
        throw APIException(
            message: 'No health metrics found for patient with ID $patientId',
            statusCode: '404');
      }

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return HealthMetric(
          id: data['id'],
          patientId: data['patientId'],
          date: (data['date'] as Timestamp).toDate(),
          systolicBP: data['systolicBP'],
          diastolicBP: data['diastolicBP'],
          heartRate: data['heartRate'],
          weight: data['weight'],
          bloodSugar: data['bloodSugar'],
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occurred',
          statusCode: e.code);
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
