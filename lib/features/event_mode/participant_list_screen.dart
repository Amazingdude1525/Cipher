import 'package:cipher/features/event_mode/widgets/participant_tile.dart';
import 'package:flutter/material.dart';

class ParticipantListScreen extends StatelessWidget {
  const ParticipantListScreen({super.key, required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Participants • $eventId')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, i) => ParticipantTile(name: 'Participant ${i + 1}', email: 'mail${i + 1}@example.com'),
      ),
    );
  }
}
