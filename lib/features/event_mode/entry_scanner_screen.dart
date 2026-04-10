import 'package:cipher/features/event_mode/widgets/entry_counter_header.dart';
import 'package:cipher/features/event_mode/widgets/profile_reveal_card.dart';
import 'package:flutter/material.dart';

class EntryScannerScreen extends StatelessWidget {
  const EntryScannerScreen({super.key, required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entry Scanner • $eventId')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [EntryCounterHeader(checkedIn: 0, total: 0), SizedBox(height: 12), ProfileRevealCard()]),
      ),
    );
  }
}
