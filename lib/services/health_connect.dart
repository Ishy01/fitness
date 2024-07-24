import 'dart:async';
import 'package:flutter_health_connect/flutter_health_connect.dart';

// class HealthConnectService {
//   final List<HealthConnectDataType> types = [
//     HealthConnectDataType.Steps,
//     HealthConnectDataType.ExerciseSession,
//     HealthConnectDataType.TotalCaloriesBurned,
//   ];

//   Future<bool> isApiSupported() async {
//     return await HealthConnectFactory.isApiSupported();
//   }

//   Future<bool> isAvailable() async {
//     return await HealthConnectFactory.isAvailable();
//   }

//   Future<void> installHealthConnect() async {
//     await HealthConnectFactory.installHealthConnect();
//   }

//   Future<void> openHealthConnectSettings() async {
//     await HealthConnectFactory.openHealthConnectSettings();
//   }

//   Future<bool> hasPermissions(bool readOnly) async {
//     return await HealthConnectFactory.hasPermissions(types, readOnly: readOnly);
//   }

//   Future<bool> requestPermissions(bool readOnly) async {
//     return await HealthConnectFactory.requestPermissions(types, readOnly: readOnly);
//   }

//   Future<Map<String, dynamic>> getRecords(DateTime startTime, DateTime endTime) async {
//     Map<String, dynamic> allRecords = {};

//     for (var type in types) {
//       var result = await HealthConnectFactory.getRecord(
//         type: type,
//         startTime: startTime,
//         endTime: endTime,
//       );
//       allRecords[type.name] = result;
//     }

//     return allRecords;
//   }
// }

class HealthConnectService {
  Future<Map<String, dynamic>> getRecords(DateTime startTime, DateTime endTime) async {
    // Initialize an empty map to store the results
    Map<String, dynamic> data = {};

    // List of Health Connect data types you want to retrieve
    List<HealthConnectDataType> healthConnectDataTypes = [
      HealthConnectDataType.Steps,
      HealthConnectDataType.TotalCaloriesBurned,
    ];

    // Iterate through each Health Connect data type and fetch records
    for (var type in healthConnectDataTypes) {
      var result = await HealthConnectFactory.getRecord(
        type: type,
        startTime: startTime,
        endTime: endTime,
      );
      data[type.name] = result;
    }

    // Return the aggregated data
    return data;
  }
}




