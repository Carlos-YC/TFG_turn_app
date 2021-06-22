import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tfg_app/src/config/config.dart';
import 'package:tfg_app/src/controllers/turn/admin_turn_controller.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class AdminTurnPage extends StatefulWidget {
  @override
  _AdminTurnPageState createState() => _AdminTurnPageState();
}

class _AdminTurnPageState extends State<AdminTurnPage> {
  final String _adminService = SupermarketApp.sharedPreferences.getString(SupermarketApp.service);
  Timer _timer;
  int _counter = 0;
  int _counterSec = 0;
  int _counterMin = 0;

  void _startTimer() {
    _counter = 0;
    _counterSec = 0;
    _counterMin = 0;
    if (_timer != null) {
      _timer.cancel();
    }
    if (mounted) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _counter++;
          if (_counterSec < 59) {
            _counterSec++;
          } else {
            _counterSec = 0;
            _counterMin++;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

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
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
            child: Column(
              children: [
                _title(_adminService),
                SizedBox(height: 45),
                _box(controller),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(child: _showTimer()),
      ),
    );
  }

  Widget _title(String service) {
    return Text(
      () {
        if (service == 'carniceria') {
          return 'Turnos Carnicería';
        } else if (service == 'charcuteria') {
          return 'Turnos Charcutería';
        } else if (service == 'pescaderia') {
          return 'Turnos Pescadería';
        }
      }(),
      style: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        decoration: TextDecoration.underline,
      ),
    );
  }

  Widget _box(AdminTurnController controller) {
    return Obx(() {
      if (controller.userNumber.value == null) {
        return Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
        );
      } else if (controller.userNumber.value < 1) {
        return Center(child: Text('No hay clientes para avisar', style: TextStyle(fontSize: 24.0)));
      } else {
        return _showInfo(controller);
      }
    });
  }

  Widget _showInfo(AdminTurnController controller) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          _nextTurnButton(controller),
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
            color: Colors.green,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.campaign_rounded, size: 80.0),
                  Text(
                    controller.userNumber.value.toString(),
                    style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            color: Colors.green,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people, size: 80.0),
                  Text(
                    '${controller.allUsers.value.toString()}',
                    style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextTurnButton(AdminTurnController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      child: InkWell(
        onTap: () {
          if (_counterSec > 0) {
            _timer.cancel();
          } else if (_counterMin > 0) {
            _timer.cancel();
          }
          TurnProvider().nextTurn();
          _startTimer();
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
            color: Colors.redAccent[200],
            borderRadius: BorderRadius.circular(40.0),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showTimer() {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer),
          SizedBox(width: 5.0),
          Text(
            () {
              if (_counterMin > 59) {
                return '--:--';
              } else if (_counterSec <= 9 && _counterMin <= 9) {
                return '0$_counterMin:0$_counterSec';
              } else if (_counterSec > 9 && _counterSec <= 59 && _counterMin <= 9) {
                return '0$_counterMin:$_counterSec';
              } else if (_counterSec <= 9 && _counterMin > 9) {
                return '$_counterMin:0$_counterSec';
              } else if (_counterSec > 9 &&
                  _counterSec <= 59 &&
                  _counterMin > 9 &&
                  _counterMin <= 59) {
                return '$_counterMin:$_counterSec';
              }
            }(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
