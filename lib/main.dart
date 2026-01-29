import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JUSTINE',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MatchInputScreen(),
    );
  }
}

class MatchInputScreen extends StatefulWidget {
  const MatchInputScreen({super.key});

  @override
  State<MatchInputScreen> createState() => _MatchInputScreenState();
}

class TeamCard extends StatefulWidget {
  const TeamCard({super.key});

  @override
  State<TeamCard> createState() => _TeamCardState();
}

const List<String> systemStatusOptions = ['Working', 'Unused', 'Disabled'];

class _TeamCardState extends State<TeamCard>{
  String intakeStatus = 'Working';
  String shooterStatus = 'Working';
  String climberStatus = 'Working';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Team #'),
            const SizedBox(height: 4),
            SizedBox(
                width: 120,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '1234',
                  ),
                ),
              ),
              const SizedBox(height: 16),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Subsystem Status',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Intake'),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: systemStatusOptions
                        .map((status) => ButtonSegment(value: status, label: Text(status)))
                        .toList(),
                    selected: {intakeStatus},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        intakeStatus = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Shooter'),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: systemStatusOptions
                        .map((status) => ButtonSegment(value: status, label: Text(status)))
                        .toList(),
                    selected: {shooterStatus},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        shooterStatus = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text('Climber'),
                  const SizedBox(height: 4),
                  SegmentedButton<String>(
                    segments: systemStatusOptions
                        .map((status) => ButtonSegment(value: status, label: Text(status)))
                        .toList(),
                    selected: {climberStatus},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        climberStatus = newSelection.first;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchInputScreenState extends State<MatchInputScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUSTINE Match Input'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            Expanded(child: TeamCard()),
            SizedBox(width: 16),
            Expanded(child: TeamCard()),
            SizedBox(width: 16),
            Expanded(child: TeamCard()),
          ],
        ),
      ),
    );
  }
}

