import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';

@immutable
class AddPersonToGroup extends StatefulWidget {
  final Group currentGroup;
  const AddPersonToGroup(this.currentGroup);
  @override
  _AddPersonToGroupState createState() => _AddPersonToGroupState();
}

class _AddPersonToGroupState extends State<AddPersonToGroup> {
  final TextEditingController _nameController = TextEditingController();
  String? _userError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add person to group'),
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
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          children: [
            const Text(
              "Insert new user name",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                hintText: "Maccio Capatonda",
                errorText: _userError,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.cyan),
              child: const Text(
                'Add and return to home',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                try {
                  widget.currentGroup.addMember(_nameController.text);
                  setState(() {
                    _userError = null;
                  });
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                } on ArgumentError catch (error) {
                  setState(() {
                    _userError = error.message;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
