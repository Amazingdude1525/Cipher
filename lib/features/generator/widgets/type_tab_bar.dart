import 'package:flutter/material.dart';

class TypeTabBar extends StatelessWidget {
  const TypeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: TabBar(tabs: [Tab(text: 'URL'), Tab(text: 'Text'), Tab(text: 'WiFi'), Tab(text: 'Contact')]),
    );
  }
}
