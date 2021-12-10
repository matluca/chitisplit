import 'package:chitisplit/pages/add-person-to-group.dart';
import 'package:chitisplit/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chitisplit/classes/group.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Ti Split'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings(currentGroup: group)),
              ).then((value) => setState(() {}));
            },
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GroupOverview(),
              Menu(setParentState: this.setState),
            ],
          ),
        ),
      )),
    );
  }
}

class GroupOverview extends StatefulWidget {
  @override
  _GroupOverviewState createState() => _GroupOverviewState();
}

class _GroupOverviewState extends State<GroupOverview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Overview - ${group.currentUser}", style: TextStyle(fontSize: 25)),
        DataTable(
          columns: [
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Fuffa")),
          ],
          rows: buildRows(),
        ),
      ],
    );
  }
}

List<DataRow> buildRows() {
  List<DataRow> rows = [];
  for (var p in group.members) {
    DataRow row = new DataRow(cells: [
      DataCell(Text(p)),
      DataCell(Text("fuffa")),
    ]);
    rows.add(row);
  }
  return rows;
}

class Menu extends StatelessWidget {
  final void Function(void Function()) setParentState;
  Menu({this.setParentState});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        child: ListTile(
          leading: Icon(MdiIcons.pencilPlus),
          trailing: Icon(Icons.play_arrow),
          title: Text('Add expense', textAlign: TextAlign.center),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(MdiIcons.cashRefund),
          trailing: Icon(Icons.play_arrow),
          title: Text('Transfer', textAlign: TextAlign.center),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(MdiIcons.formatListBulletedSquare),
          trailing: Icon(Icons.play_arrow),
          title: Text('View expenses', textAlign: TextAlign.center),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.person_add),
          trailing: Icon(Icons.play_arrow),
          title: Text('Add person to group', textAlign: TextAlign.center),
          onTap: () {
            //Navigator.pushNamed(context, '/add-person-to-group');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPersonToGroup()),
            ).then((value) => setParentState(() {}));
          },
        ),
      ),
    ]);
  }
}
