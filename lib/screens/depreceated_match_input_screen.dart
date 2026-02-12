import 'package:flutter/material.dart';
import 'package:justine_flutter/models/observation.dart';
import 'package:justine_flutter/services/observation_service.dart';
import '../theme/app_theme.dart';

// --- Design constants ---
const double _sidebarWidth = 72;
const List<String> _systemStatusOptions = ['Working', 'Unused', 'Disabled'];
const List<String> _allianceOptions = ['Red', 'Blue'];

// --- Navigation sidebar ---
class _NavSidebar extends StatelessWidget {
  const _NavSidebar({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _sidebarWidth,
      color: AppTheme.backgroundDark,
      child: Column(
        children: [
          const SizedBox(height: 24),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          _NavItem(
            icon: Icons.edit,
            label: 'Input',
            selected: selectedIndex == 0,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.settings,
            label: 'Settings',
            selected: selectedIndex == 1,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.schedule,
            label: 'Schedule',
            selected: selectedIndex == 2,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: selected ? AppTheme.accentPurple : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Subsystem status chip row ---
class _StatusChips extends StatelessWidget {
  const _StatusChips({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _systemStatusOptions.map((option) {
        final selected = value == option;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Material(
            color: selected ? AppTheme.accentPurple : AppTheme.inputBackground,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => onChanged(option),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selected) ...[
                      const Icon(Icons.check, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      option,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// --- Team column (Team # + Subsystem Status) ---
class _TeamColumn extends StatefulWidget {
  const _TeamColumn({this.initialTeamNumber = '1234'});

  final String initialTeamNumber;

  @override
  State<_TeamColumn> createState() => _TeamColumnState();
}

class _TeamColumnState extends State<_TeamColumn> {
  late TextEditingController _teamController;
  String _intakeStatus = 'Working';
  String _shooterStatus = 'Working';
  String _climberStatus = 'Working';

  @override
  void initState() {
    super.initState();
    _teamController = TextEditingController(text: widget.initialTeamNumber);
  }

  @override
  void dispose() {
    _teamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team #',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 120,
            child: TextField(
              controller: _teamController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppTheme.inputBackground,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Subsystem Status',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Intake', style: TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(height: 4),
          _StatusChips(value: _intakeStatus, onChanged: (v) => setState(() => _intakeStatus = v)),
          const SizedBox(height: 12),
          const Text('Shooter', style: TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(height: 4),
          _StatusChips(value: _shooterStatus, onChanged: (v) => setState(() => _shooterStatus = v)),
          const SizedBox(height: 12),
          const Text('Climber', style: TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(height: 4),
          _StatusChips(value: _climberStatus, onChanged: (v) => setState(() => _climberStatus = v)),
        ],
      ),
    );
  }
}

// --- History row model ---
class _HistoryRow {
  final String matchNumber;
  final String teamNumber;
  final String intakeStatus;
  final String shooterStatus;
  final String climberStatus;
  final String lastSaved;

  const _HistoryRow({
    required this.matchNumber,
    required this.teamNumber,
    required this.intakeStatus,
    required this.shooterStatus,
    required this.climberStatus,
    required this.lastSaved,
  });
}

// --- Match Input Screen ---
class MatchInputScreen extends StatefulWidget {
  const MatchInputScreen({super.key});

  @override
  State<MatchInputScreen> createState() => _MatchInputScreenState();
}

class _MatchInputScreenState extends State<MatchInputScreen> {
  int _navIndex = 0;
  final TextEditingController _qualController = TextEditingController(text: '0');
  String _alliance = 'Red';
  ObservationService? _observationService;
  List<Observation> _history = [];

  final _team1Controller = TextEditingController();
  final _team2Controller = TextEditingController();
  final _team3Controller = TextEditingController();

  String _team1Intake = 'Working';
  String _team1Shooter = 'Working';
  String _team1Climber = 'Working';

  String _team2Intake = 'Working';
  String _team2Shooter = 'Working';
  String _team2Climber = 'Working';

  String _team3Intake = 'Working';
  String _team3Shooter = 'Working';
  String _team3Climber = 'Working';

  int _matchNumber = 0;

  final List<_HistoryRow> _historyRows = [
    const _HistoryRow(
      matchNumber: '2',
      teamNumber: '1234',
      intakeStatus: 'Working',
      shooterStatus: 'Disabled',
      climberStatus: 'Working',
      lastSaved: '12:01pm Today',
    ),
    const _HistoryRow(
        matchNumber: '3',
        teamNumber: '1234',
        intakeStatus: 'Text',
        shooterStatus: 'Text',
        climberStatus: 'Text',
        lastSaved: 'Text'
    ),
    const _HistoryRow(
        matchNumber: '4',
        teamNumber: '1234',
        intakeStatus: 'Text',
        shooterStatus: 'Text',
        climberStatus: 'Text',
        lastSaved: 'Text'
    ),
    const _HistoryRow(
        matchNumber: '5',
        teamNumber: '1234',
        intakeStatus: 'Text',
        shooterStatus: 'Text',
        climberStatus: 'Text',
        lastSaved: 'Text'
    ),
  ];

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
    if (_observationService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service not initialized yet')),
      );
      return;
    }

    final matchKey = 'qm$_matchNumber';

    // Create observations for each team
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
// Save all observations
    for (final obs in observations) {
      await _observationService!.saveObservation(obs);
    }

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Match $_matchNumber saved!')),
      );
    }

    // Reload history
    await _loadHistory();
  }

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    _team3Controller.dispose();
    _qualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NavSidebar(selectedIndex: _navIndex),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'JUSTINE Match Input',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Match controls row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Qualification #', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 64,
                        child: TextField(
                          controller: _qualController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: AppTheme.inputBackground,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Text('Alliance', style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _alliance,
                            dropdownColor: AppTheme.inputBackground,
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            items: _allianceOptions
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (v) => setState(() => _alliance = v ?? 'Red'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.inputBackground,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Load Match'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Qualification Match: 1',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Three team columns
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _TeamColumn(initialTeamNumber: '1234'),
                      SizedBox(width: 24),
                      _TeamColumn(initialTeamNumber: '1234'),
                      SizedBox(width: 24),
                      _TeamColumn(initialTeamNumber: '1234'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: FilledButton.icon(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.inputBackground,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Save Match'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // History table
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(0.8),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1.2),
                        3: FlexColumnWidth(1.2),
                        4: FlexColumnWidth(1.2),
                        5: FlexColumnWidth(1.5),
                        6: FixedColumnWidth(48),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: AppTheme.tableHeaderBg),
                          children: [
                            _tableHeader('Match #'),
                            _tableHeader('Team #'),
                            _tableHeader('Intake Status'),
                            _tableHeader('Shooter Status'),
                            _tableHeader('Climber Status'),
                            _tableHeader('Last Saved'),
                            _tableHeader(''),
                          ],
                        ),
                        ..._historyRows.asMap().entries.map((entry) {
                          final i = entry.key;
                          final row = entry.value;
                          return TableRow(
                            decoration: BoxDecoration(
                              color: i.isEven ? AppTheme.surfaceDark : AppTheme.backgroundDark,
                            ),
                            children: [
                              _tableCell(row.matchNumber),
                              _tableCell(row.teamNumber),
                              _tableCell(row.intakeStatus),
                              _tableCell(row.shooterStatus),
                              _tableCell(row.climberStatus),
                              _tableCell(row.lastSaved),
                              TableCell(
                                child: IconButton(
                                  icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}