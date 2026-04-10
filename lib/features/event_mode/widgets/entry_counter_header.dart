import 'package:flutter/material.dart';

class EntryCounterHeader extends StatelessWidget {
  const EntryCounterHeader({super.key, required this.checkedIn, required this.total});

  final int checkedIn;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('Checked In: $checkedIn'), Text('Total: $total')],
    );
  }
}
