import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/controllers/turn_controller.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class AdminTurnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminTurnController>(
      init: AdminTurnController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: CustomBoxDecoration(
            color1: Colors.lightBlueAccent,
            color2: Colors.blue,
          ),
          title: Text(
            'Turno',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: _box(controller),
          ),
        ),
      ),
    );
  }

  Widget _box(AdminTurnController controller) {
    return Obx(() {
      print('User Number: ${controller.userNumber.value}');
      if (controller.userNumber.value < 1) {
        return Center(child: Text('No hay clientes', style: TextStyle(fontSize: 24.0)));
      } else {
        return _showInfo(controller);
      }
    });
  }

  Widget _showInfo(AdminTurnController controller) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _turnInfo(controller),
          Container(
            padding: EdgeInsets.all(30.0),
            child: SizedBox(
              height: 30.0,
              width: 300.0,
              child: Divider(
                color: Colors.green,
                thickness: 4.0,
              ),
            ),
          ),
          _nextTurnButton(),
        ],
      ),
    );
  }

  Widget _turnInfo(AdminTurnController controller) {
    return Container(
      child: Row(
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
                  Icon(Icons.confirmation_num_outlined, size: 32.0),
                  Text(
                    controller.userNumber.value.toString(),
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
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
                  Icon(Icons.people, size: 32.0),
                  Text(
                    controller.allUsers.value.toString(),
                    style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextTurnButton() {
    return Padding(
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      child: InkWell(
        onTap: () => TurnProvider().nextTurn(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
            color: Colors.redAccent[200],
            borderRadius: BorderRadius.circular(7.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(0.5, 1.5),
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                'Siguiente turno',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 36.0, color: Color(0xFF3f4756)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
