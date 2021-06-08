import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tfg_app/src/controllers/turn_controller.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';
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
        if (controller.turnUserInfo.length == 0) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.teal,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Turno de charcutería',
                          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 200.0,
                          child: Divider(
                            color: Colors.green,
                            thickness: 4.0,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Column(
                            children: [
                              _turnInfoText(
                                  Icons.confirmation_num_outlined,
                                  'Tu turno: ${controller.turnUserInfo[0]['tu_num'].toString()}',
                                  24.0),
                              _turnInfoText(Icons.people,
                                  'Clientes por delante: ${controller.numUsers.toString()}', 18.0),
                              _turnInfoText(Icons.access_time, 'Tiempo de espera:', 18.0),
                              _turnInfoText(null, '15 min aprox.', 18.0),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          width: 100.0,
                          child: Divider(
                            color: Colors.green,
                            thickness: 4.0,
                          ),
                        ),
                        _cancelButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    });
  }

  Widget _turnInfoText(IconData showIcon, String infoText, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(showIcon),
        Text(
          infoText,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: () {
        TurnProvider().cancelTurn();
        Get.offNamed('userPage');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          'Cancelar turno',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        primary: Colors.red,
        textStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
