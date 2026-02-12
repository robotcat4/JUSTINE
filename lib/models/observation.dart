class Observation {
  final String matchKey;
  final int teamNumber;
  final String intakeStatus;
  final String shooterStatus;
  final String climberStatus;
  final DateTime timestamp;

  Observation({
    required this.matchKey,
    required this.teamNumber,
    required this.intakeStatus,
    required this.shooterStatus,
    required this.climberStatus,
    required this.timestamp,
  });

// Convert Observation to JSON Map
  Map<String, dynamic> toJson(){
    return{
      'matchKey': matchKey,
      'teamNumber': teamNumber,
      'intakeStatus': intakeStatus,
      'shooterStatus': shooterStatus,
      'climberStatus': climberStatus,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  // Create Observation from JSON Map
  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      matchKey: json['matchKey'] as String,
      teamNumber: json['teamNumber'] as int,
      intakeStatus: json['intakeStatus'] as String,
      shooterStatus: json['shooterStatus'] as String,
      climberStatus: json['climberStatus'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Generate unique storage key for this observation
  String get storageKey => 'obs:$matchKey:$teamNumber';
}
