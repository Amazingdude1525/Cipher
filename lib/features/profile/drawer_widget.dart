import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Text('Cipher')),
          ListTile(title: Text('Home')),
          ListTile(title: Text('Scanner')),
          ListTile(title: Text('Generator')),
        ],
      ),
    );
  }
}
