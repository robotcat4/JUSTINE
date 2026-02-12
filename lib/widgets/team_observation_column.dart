import 'package:flutter/material.dart';

/// A column for observing one team's subsystems during a match
class TeamObservationColumn extends StatelessWidget {
  final TextEditingController teamController;
  final String intakeStatus;
  final String shooterStatus;
  final String climberStatus;
  final Function(String) onIntakeChanged;
  final Function(String) onShooterChanged;
  final Function(String) onClimberChanged;

  const TeamObservationColumn({
    super.key,
    required this.teamController,
    required this.intakeStatus,
    required this.shooterStatus,
    required this.climberStatus,
    required this.onIntakeChanged,
    required this.onShooterChanged,
    required this.onClimberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team Number Input
            TextField(
              controller: teamController,
              decoration: const InputDecoration(
                labelText: 'Team #',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            // Subsystem Status Section
            const Text(
              'Subsystem Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Intake
            _buildSubsystemButtons(
              'Intake',
              intakeStatus,
              onIntakeChanged,
            ),

            const SizedBox(height: 16),

            // Shooter
            _buildSubsystemButtons(
              'Shooter',
              shooterStatus,
              onShooterChanged,
            ),

            const SizedBox(height: 16),

            // Climber
            _buildSubsystemButtons(
              'Climber',
              climberStatus,
              onClimberChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubsystemButtons(
      String label,
      String currentValue,
      Function(String) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'Working',
              label: Text('Working'),
              icon: Icon(Icons.check_circle),
            ),
            ButtonSegment(
              value: 'Unused',
              label: Text('Unused'),
              icon: Icon(Icons.remove_circle),
            ),
            ButtonSegment(
              value: 'Disabled',
              label: Text('Disabled'),
              icon: Icon(Icons.cancel),
            ),
          ],
          selected: {currentValue},
          onSelectionChanged: (Set<String> newSelection) {
            onChanged(newSelection.first);
          },
        ),
      ],
    );
  }
}