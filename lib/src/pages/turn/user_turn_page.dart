import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tfg_app/src/controllers/turn_controller.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class UserTurnPage extends StatefulWidget {
  @override
  _UserTurnPageState createState() => _UserTurnPageState();
}

class _UserTurnPageState extends State<UserTurnPage> {
  List users;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TurnUserInfoController>(
      init: TurnUserInfoController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: CustomBoxDecoration(
            color1: Colors.lightGreen,
            color2: Colors.green,
          ),
          title: Text(
            'Mi turno',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
        body: _turnInfo(controller),
      ),
    );
  }

  Widget _turnInfo(TurnUserInfoController controller) {
    return Obx(() {
      if (controller.numUsers.value < 0) {
        return Center(
          child: Center(
            child: Text('Ha habido un error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        );
      } else {
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.teal,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.confirmation_num_outlined,
                            size: 60.0,
                          ),
                          title: Text(
                            'Turno de charcutería',
                            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tu turno: ${controller.turnUserInfo[0]['tu_num'].toString()}',
                              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Clientes por delante: ${controller.numUsers.toString()}',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Tiempo de espera aproximado: -',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  width: 300.0,
                  child: Divider(
                    color: Colors.blue,
                    thickness: 4.0,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
