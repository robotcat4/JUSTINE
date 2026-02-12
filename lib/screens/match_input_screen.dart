import 'package:flutter/material.dart';
import '../widgets/team_observation_column.dart';
import '../services/observation_service.dart';
import '../models/observation.dart';

class MatchInputScreen extends StatefulWidget {
  const MatchInputScreen({super.key});

  @override
  State<MatchInputScreen> createState() => _MatchInputScreenState();
}

class _MatchInputScreenState extends State<MatchInputScreen> {
  // Service
  ObservationService? _observationService;
  List<Observation> _history = [];

  // Match info
  int _matchNumber = 0;
  String _selectedAlliance = 'Red';

  // Team 1 controllers and state
  final _team1Controller = TextEditingController();
  String _team1Intake = 'Working';
  String _team1Shooter = 'Working';
  String _team1Climber = 'Working';

  // Team 2 controllers and state
  final _team2Controller = TextEditingController();
  String _team2Intake = 'Working';
  String _team2Shooter = 'Working';
  String _team2Climber = 'Working';

  // Team 3 controllers and state
  final _team3Controller = TextEditingController();
  String _team3Intake = 'Working';
  String _team3Shooter = 'Working';
  String _team3Climber = 'Working';

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _observationService = await ObservationService.create();
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (_observationService == null) return;
    final observations = await _observationService!.loadAllObservations();
    setState(() {
      _history = observations;
    });
  }

  Future<void> _saveMatch() async {
    if (_observationService == null) return;

    final matchKey = 'qm$_matchNumber';

    // Create observations for all three teams
    final observations = [
      Observation(
        matchKey: matchKey,
        teamNumber: int.tryParse(_team1Controller.text) ?? 0,
        intakeStatus: _team1Intake,
        shooterStatus: _team1Shooter,
        climberStatus: _team1Climber,
        timestamp: DateTime.now(),
      ),
      Observation(
        matchKey: matchKey,
        teamNumber: int.tryParse(_team2Controller.text) ?? 0,
        intakeStatus: _team2Intake,
        shooterStatus: _team2Shooter,
        climberStatus: _team2Climber,
        timestamp: DateTime.now(),
      ),
      Observation(
        matchKey: matchKey,
        teamNumber: int.tryParse(_team3Controller.text) ?? 0,
        intakeStatus: _team3Intake,
        shooterStatus: _team3Shooter,
        climberStatus: _team3Climber,
        timestamp: DateTime.now(),
      ),
    ];

    for (final obs in observations) {
      await _observationService!.saveObservation(obs);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Match $_matchNumber saved!')),
      );
    }

    await _loadHistory();
  }

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    _team3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUSTINE Match Input'),
      ),
      body: Row(
        children: [
        // Navigation Rail
        NavigationRail(
          backgroundColor: const Color(0xFF1a1625),
          selectedIndex: 0,
          onDestinationSelected: (int index) {
            // TODO: Handle navigation
          },
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.edit),
              label: Text('Input'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.schedule),
              label: Text('Schedule'),
           ),
         ],
       ),

        // Vertical divider
        const VerticalDivider(thickness: 1, width: 1),

        // Main content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Match Input Section
                  Row(
                    children: [
                      // Match Number
                      SizedBox(
                        width: 120,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Qualification #',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _matchNumber = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Alliance Dropdown
                      DropdownButton<String>(
                        value: _selectedAlliance,
                        items: const [
                          DropdownMenuItem(value: 'Red', child: Text('Red')),
                          DropdownMenuItem(value: 'Blue', child: Text('Blue')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedAlliance = value!;
                          });
                        },
                      ),

                      const SizedBox(width: 16),

                      // Load Match Button (placeholder for now)
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Load match from TBA
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Load Match'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Three Team Columns
                  SizedBox(
                    height: 400,
                    child: Row(
                      children: [
                        // Team 1
                        Expanded(
                          child: TeamObservationColumn(
                            teamController: _team1Controller,
                            intakeStatus: _team1Intake,
                            shooterStatus: _team1Shooter,
                            climberStatus: _team1Climber,
                            onIntakeChanged: (value) {
                              setState(() => _team1Intake = value);
                            },
                            onShooterChanged: (value) {
                              setState(() => _team1Shooter = value);
                            },
                            onClimberChanged: (value) {
                              setState(() => _team1Climber = value);
                            },
                          ),
                        ),

                        // Team 2
                        Expanded(
                          child: TeamObservationColumn(
                            teamController: _team2Controller,
                            intakeStatus: _team2Intake,
                            shooterStatus: _team2Shooter,
                            climberStatus: _team2Climber,
                            onIntakeChanged: (value) {
                              setState(() => _team2Intake = value);
                            },
                            onShooterChanged: (value) {
                              setState(() => _team2Shooter = value);
                            },
                            onClimberChanged: (value) {
                              setState(() => _team2Climber = value);
                            },
                          ),
                        ),

                        // Team 3
                        Expanded(
                          child: TeamObservationColumn(
                            teamController: _team3Controller,
                            intakeStatus: _team3Intake,
                            shooterStatus: _team3Shooter,
                            climberStatus: _team3Climber,
                            onIntakeChanged: (value) {
                              setState(() => _team3Intake = value);
                            },
                            onShooterChanged: (value) {
                              setState(() => _team3Shooter = value);
                            },
                            onClimberChanged: (value) {
                              setState(() => _team3Climber = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Save Button
                  ElevatedButton.icon(
                    onPressed: _saveMatch,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Match'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // History Section
                  const Text(
                    'History',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // History Table
                  SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Match #')),
                          DataColumn(label: Text('Team #')),
                          DataColumn(label: Text('Intake')),
                          DataColumn(label: Text('Shooter')),
                          DataColumn(label: Text('Climber')),
                        ],
                        rows: _history.map((obs) {
                          return DataRow(cells: [
                            DataCell(Text(obs.matchKey)),
                            DataCell(Text(obs.teamNumber.toString())),
                            DataCell(Text(obs.intakeStatus)),
                            DataCell(Text(obs.shooterStatus)),
                            DataCell(Text(obs.climberStatus)),
                          ]);
                        }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          )
        ]
      )
    );
  }
}