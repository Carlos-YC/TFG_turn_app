import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tfg_app/src/config/config.dart';

import 'package:tfg_app/src/controllers/turn/turn_user_info_controller.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';

import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class UserTurnPage extends StatefulWidget {
  @override
  _UserTurnPageState createState() => _UserTurnPageState();
}

class _UserTurnPageState extends State<UserTurnPage> {
  final String _marketId = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed('userPage'),
          ),
          title: Text(
            'Mis turnos',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _turnInfoCarniceria(controller, 'carniceria'),
              SizedBox(height: 20.0),
              _turnInfoCharcuteria(controller, 'charcuteria'),
              SizedBox(height: 20.0),
              _turnInfoPescaderia(controller, 'pescaderia'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _turnInfoCarniceria(TurnUserInfoController controller, String service) {
    return Obx(() {
      if (controller.numUsersCarniceria.value < 0) {
        return Center(
          child: Center(
            child: Text('Ha habido un error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        );
      } else {
        if (controller.turnUserInfoCarniceria.length == 0) {
          return Center(child: _takeTurn(service));
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
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Turno de $service',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 160.0,
                          child: Divider(
                            color: Colors.blue[300],
                            thickness: 4.0,
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              _turnInfoText(
                                  Icons.confirmation_num_outlined,
                                  'Turno: ${controller.turnUserInfoCarniceria[0]['tu_num'].toString()}',
                                  20.0),
                              _turnInfoText(
                                  Icons.people,
                                  'Clientes por delante: ${controller.numUsersCarniceria.toString()}',
                                  16.0),
                              _turnInfoText(Icons.access_time, 'Tiempo de espera: -', 16.0),
                              //_turnInfoText(null, '15 min aprox.', 16.0),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          width: 80.0,
                          child: Divider(
                            color: Colors.blue[300],
                            thickness: 4.0,
                          ),
                        ),
                        _cancelButton(service),
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

  Widget _turnInfoCharcuteria(TurnUserInfoController controller, String service) {
    return Obx(() {
      if (controller.numUsersCharcuteria.value < 0) {
        return Center(
          child: Center(
            child: Text('Ha habido un error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        );
      } else {
        if (controller.turnUserInfoCharcuteria.length == 0) {
          return Center(child: _takeTurn(service));
        } else {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.orange[300],
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Turno de $service',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 160.0,
                          child: Divider(
                            color: Colors.teal,
                            thickness: 4.0,
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              _turnInfoText(
                                  Icons.confirmation_num_outlined,
                                  'Turno: ${controller.turnUserInfoCharcuteria[0]['tu_num'].toString()}',
                                  20.0),
                              _turnInfoText(
                                  Icons.people,
                                  'Clientes por delante: ${controller.numUsersCharcuteria.toString()}',
                                  16.0),
                              _turnInfoText(Icons.access_time, 'Tiempo de espera:', 16.0),
                              //_turnInfoText(null, '15 min aprox.', 16.0),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          width: 80.0,
                          child: Divider(
                            color: Colors.teal,
                            thickness: 4.0,
                          ),
                        ),
                        _cancelButton(service),
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

  Widget _turnInfoPescaderia(TurnUserInfoController controller, String service) {
    return Obx(() {
      if (controller.numUsersPescaderia.value < 0) {
        return Center(
          child: Center(
            child: Text('Ha habido un error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
          ),
        );
      } else {
        if (controller.turnUserInfoPescaderia.length == 0) {
          return Center(child: _takeTurn(service));
        } else {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.blue[300],
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Turno de $service',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: 160.0,
                          child: Divider(
                            color: Colors.orange[300],
                            thickness: 4.0,
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              _turnInfoText(
                                  Icons.confirmation_num_outlined,
                                  'Turno: ${controller.turnUserInfoPescaderia[0]['tu_num'].toString()}',
                                  20.0),
                              _turnInfoText(
                                  Icons.people,
                                  'Clientes por delante: ${controller.numUsersPescaderia.toString()}',
                                  16.0),
                              _turnInfoText(Icons.access_time, 'Tiempo de espera:', 16.0),
                              //_turnInfoText(null, '15 min aprox.', 16.0),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          width: 80.0,
                          child: Divider(
                            color: Colors.orange[300],
                            thickness: 4.0,
                          ),
                        ),
                        _cancelButton(service),
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

  Widget _cancelButton(String service) {
    return ElevatedButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Cancelar turno de $service'),
          content: Text('¿Seguro que quiere cancelar su turno?'),
          actions: [
            TextButton(
              onPressed: () {
                TurnProvider().cancelTurn(service);
                Get.offAllNamed('userPage');
              },
              child: Text('Confirmar'),
              style: TextButton.styleFrom(primary: Colors.green),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancelar'),
              child: Text('Cancelar'),
              style: TextButton.styleFrom(primary: Colors.red),
            )
          ],
        ),
      ),
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

  Widget _takeTurn(String service) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
        child: InkWell(
          onTap: () {
            if (service == 'carniceria') {
              TurnProvider().createTurn(_marketId, 'carniceria');
              Get.toNamed('userTurn');
            } else if (service == 'charcuteria') {
              TurnProvider().createTurn(_marketId, 'charcuteria');
              Get.toNamed('userTurn');
            } else if (service == 'pescaderia') {
              TurnProvider().createTurn(_marketId, 'pescaderia');
              Get.toNamed('userTurn');
            }
          },
          child: Container(
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: () {
                if (service == 'carniceria') {
                  return Colors.red[300];
                } else if (service == 'charcuteria') {
                  return Colors.orange[300];
                } else if (service == 'pescaderia') {
                  return Colors.blue[300];
                }
              }(),
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.5, 1.5),
                  spreadRadius: 3.0,
                )
              ],
            ),
            child: Center(
              child: Text(
                (() {
                  if (service == 'carniceria') {
                    return 'Pedir turno carnicería';
                  } else if (service == 'charcuteria') {
                    return 'Pedir turno charcutería';
                  } else if (service == 'pescaderia') {
                    return 'Pedir turno pescadería';
                  }
                }()),
                style:
                    TextStyle(fontSize: 24, color: Color(0xFF3f4756), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
