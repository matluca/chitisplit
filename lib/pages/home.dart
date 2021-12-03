import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


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
      ),
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 300,
                  width: 300,
                  child: Text(
                    'Overview',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
              Menu(),
            ],
          ),
        ),
      )),
    );
  }
}

class Menu extends StatelessWidget {
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
        ),
      ),
    ]);
  }
}
