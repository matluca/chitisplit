import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';

class Settings extends StatefulWidget {
  final Group currentGroup;
  const Settings(this.currentGroup);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change group settings'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current user', style: TextStyle(fontSize: 20, color: Colors.black54)),
                const SizedBox(width: 15),
                DropdownButton<String>(
                  value: widget.currentGroup.currentUser,
                  elevation: 16,
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      widget.currentGroup.currentUser = newValue ??= widget.currentGroup.currentUser;
                    });
                  },
                  items: widget.currentGroup.members.map<DropdownMenuItem<String>>((String value) {
                    int l = value.length;
                    String text = value;
                    if (l>15) {
                      text = value.replaceRange(15, l, "...");
                    }
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(text),
                    );
                  }).toList(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
