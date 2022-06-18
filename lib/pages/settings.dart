import 'package:chitisplit/pages/home.dart';
import 'package:chitisplit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:chitisplit/classes/group.dart';
import '../utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  HomeState state;

  Settings(this.state, {Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return futurify<List<List<String>>>(
        Future.wait(
            [DatabaseService().groupList(), widget.state.group.members()]),
        (context, snapshot, futures) {
      List<String> groups = futures[0];
      List<String> members = futures[1];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Change settings'),
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
                  const Text('Current group',
                      style: TextStyle(fontSize: 20, color: Colors.black54)),
                  const SizedBox(width: 15),
                  DropdownButton<String>(
                    value: widget.state.group.name,
                    elevation: 16,
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                    underline: Container(
                      height: 2,
                      color: Colors.black54,
                    ),
                    onChanged: (String? newValue) async {
                      String groupName = newValue ??= widget.state.group.name;
                      Group group = Group(groupName, "");
                      List<String> members = await group.members();
                      group.currentUser =
                          members.contains(widget.state.group.currentUser)
                              ? widget.state.group.currentUser
                              : members[0];
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('group', groupName);
                      await prefs.setString('user', group.currentUser);
                      setState(() {
                        widget.state.group = group;
                      });
                    },
                    items: groups.map<DropdownMenuItem<String>>((String value) {
                      int l = value.length;
                      String text = value;
                      if (l > 15) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Current user',
                      style: TextStyle(fontSize: 20, color: Colors.black54)),
                  const SizedBox(width: 15),
                  DropdownButton<String>(
                    value: widget.state.group.currentUser,
                    elevation: 16,
                    style: const TextStyle(fontSize: 20, color: Colors.black54),
                    underline: Container(
                      height: 2,
                      color: Colors.black54,
                    ),
                    onChanged: (String? newValue) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String newUser = newValue ??= widget.state.group.currentUser;
                      await prefs.setString('user', newUser);
                      setState(() {
                        widget.state.group.currentUser = newUser;
                      });
                    },
                    items:
                        members.map<DropdownMenuItem<String>>((String value) {
                      int l = value.length;
                      String text = value;
                      if (l > 15) {
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
    });
  }
}
