import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode/jsonDecode
import '../models/observation.dart';

class ObservationService {
  final SharedPreferences _prefs;

  ObservationService._(this._prefs);

  static Future<ObservationService> create() async{
    final prefs = await SharedPreferences.getInstance();
    return ObservationService._(prefs);
  }

  Future<void> saveObservation(Observation obs) async{
    final jsonString = jsonEncode(obs.toJson());
    await _prefs.setString(obs.storageKey, jsonString);
  }

  Future<Observation?> loadObservation(String matchKey, int teamNumber) async {
    final key = 'obs:$matchKey:$teamNumber';
    final jsonString = _prefs.getString(key);

    if (jsonString == null) {
      return null; // No observation found
    }

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return Observation.fromJson(jsonMap);
  }

  Future<List<Observation>> loadAllObservations() async {
    final allKeys = _prefs.getKeys();
    final observationKeys = allKeys.where((key) => key.startsWith('obs:'));

    final observations = <Observation>[];
    for (final key in observationKeys) {
      final jsonString = _prefs.getString(key);
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        observations.add(Observation.fromJson(jsonMap));
      }
    }
    // Sort by timestamp (newest first)
    observations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return observations;
  }
  // Delete an observation
  Future<void> deleteObservation(String matchKey, int teamNumber) async {
    final key = 'obs:$matchKey:$teamNumber';
    await _prefs.remove(key);
  }
}