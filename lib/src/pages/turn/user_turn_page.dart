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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _turnInfoCarniceria(controller, 'carniceria'),
            SizedBox(height: 20.0),
            _turnInfoCharcuteria(controller, 'charcuteria'),
            SizedBox(height: 20.0),
            _turnInfoPescaderia(controller, 'pescaderia'),
          ],
        ),
      ),
    );
  }

  Widget _turnInfoCarniceria(TurnUserInfoController controller, String service) {
    return Obx(() {
      if (controller.numUsersCarniceria.value < 0) {
        return Center(
          child: Center(
            child: Text(
              'Ha habido un error',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
        );
      } else {
        if (controller.turnUserInfoCarniceria.length == 0) {
          return Center(child: _takeTurn(service));
        } else {
          return _cardInfo(service, controller.turnUserInfoCarniceria[0]['tu_num'].toString(),
              controller.numUsersCarniceria.toString());
        }
      }
    });
  }

  Widget _turnInfoCharcuteria(TurnUserInfoController controller, String service) {
    return Obx(() {
      print(controller.turnUserInfoCharcuteria.length);
      if (controller.numUsersCharcuteria.value < 0) {
        return Center(
          child: Center(
            child: Text(
              'Ha habido un error',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
        );
      } else {
        if (controller.turnUserInfoCharcuteria.length == 0) {
          return Center(child: _takeTurn(service));
        } else {
          return _cardInfo(service, controller.turnUserInfoCharcuteria[0]['tu_num'].toString(),
              controller.numUsersCharcuteria.toString());
        }
      }
    });
  }

  Widget _turnInfoPescaderia(TurnUserInfoController controller, String service) {
    return Obx(() {
      if (controller.numUsersPescaderia.value < 0) {
        return Center(
          child: Center(
            child: Text(
              'Ha habido un error',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
        );
      } else {
        if (controller.turnUserInfoPescaderia.length == 0) {
          return Center(child: _takeTurn(service));
        } else {
          return _cardInfo(service, controller.turnUserInfoPescaderia[0]['tu_num'].toString(),
              controller.numUsersPescaderia.toString());
        }
      }
    });
  }

  Widget _cardInfo(String service, String turnUser, String numUsers) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            color: () {
              if (service == 'carniceria') {
                return Colors.red[300];
              } else if (service == 'charcuteria') {
                return Colors.orange[300];
              } else if (service == 'pescaderia') {
                return Colors.blue[300];
              }
            }(),
            elevation: 5,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        () {
                          if (service == 'carniceria') {
                            return 'Carnicería';
                          } else if (service == 'charcuteria') {
                            return 'Charcutería';
                          } else if (service == 'pescaderia') {
                            return 'Pescadería';
                          }
                        }(),
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 160.0,
                        child: Divider(
                          color: () {
                            if (service == 'carniceria') {
                              return Colors.blue[300];
                            } else if (service == 'charcuteria') {
                              return Colors.red[300];
                            } else if (service == 'pescaderia') {
                              return Colors.orange[300];
                            }
                          }(),
                          thickness: 4.0,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.confirmation_num_outlined, size: 32),
                                Text(
                                  turnUser,
                                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(width: 17),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _turnInfoText(Icons.people, 'Clientes por delante: ', numUsers),
                                _turnInfoWaitTime(
                                    Icons.access_time, 'Tiempo de espera: ', service, numUsers),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _cancelButton(service)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _turnInfoText(IconData showIcon, String text, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(showIcon),
        SizedBox(width: 5),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: text, style: TextStyle(fontSize: 16)),
              TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
            ],
          ),
        ),
      ],
    );
  }

  Widget _turnInfoWaitTime(
      IconData showIcon, String infoText, String service, String numUsersAhead) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(showIcon),
        SizedBox(width: 5),
        Text(
          infoText,
          style: TextStyle(fontSize: 16),
        ),
        FutureBuilder(
          future: TurnProvider().waitTurnTime(15, service),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData || snapshot.data == '') {
              return Text('-', style: TextStyle(fontWeight: FontWeight.bold));
            } else {
              return RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: '${int.parse(snapshot.data) * int.parse(numUsersAhead)}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    TextSpan(text: ' min.', style: TextStyle(fontSize: 16))
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }

  Widget _cancelButton(String service) {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        icon: Icon(Icons.cancel),
        color: Colors.red[800],
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => _alertDialog(service),
        ),
      ),
    );
  }

  Widget _alertDialog(String service) {
    return AlertDialog(
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
            } else if (service == 'charcuteria') {
              TurnProvider().createTurn(_marketId, 'charcuteria');
            } else if (service == 'pescaderia') {
              TurnProvider().createTurn(_marketId, 'pescaderia');
            }
            Get.offNamed('userTurn');
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
