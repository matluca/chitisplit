import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chitisplit/classes/group.dart';

class AddPersonToGroup extends StatefulWidget {
  @override
  _AddPersonToGroupState createState() => _AddPersonToGroupState();
}

class _AddPersonToGroupState extends State<AddPersonToGroup> {
  TextEditingController _nameController = TextEditingController();
  String _userError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Person To Group'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
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
            Text(
              "Insert new user name",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.cyan,
              child: Text(
                'Add and return to home',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                try {
                  group.addMember(_nameController.text);
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
