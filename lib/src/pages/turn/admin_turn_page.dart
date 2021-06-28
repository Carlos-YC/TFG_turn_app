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

  int _timeUnix;

  void _startTimer() {
    _counter = 0;
    _counterSec = 0;
    _counterMin = 0;
    if (_timer != null) _timer.cancel();
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
    if (_timer != null) _timer.cancel();
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
            () {
              if (_adminService == 'carniceria') {
                return 'Turnos carnicería';
              } else if (_adminService == 'charcuteria') {
                return 'Turnos charcutería';
              } else if (_adminService == 'pescaderia') {
                return 'Turnos pescadería';
              }
            }(),
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 65, left: 15, right: 15),
            child: _box(controller),
          ),
        ),
        floatingActionButton: Container(child: _showTimer()),
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
        return Center(
          child: Text('No hay clientes para avisar', style: TextStyle(fontSize: 24.0)),
        );
      } else {
        return _showInfo(controller);
      }
    });
  }

  Widget _showInfo(AdminTurnController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _turnInfo(controller),
        Container(
          padding: EdgeInsets.all(10.0),
          child: SizedBox(
            height: 30.0,
            width: 300.0,
            child: Divider(
              color: Colors.green,
              thickness: 4.0,
            ),
          ),
        ),
        _turnButtons(controller),
        Container(
          padding: EdgeInsets.all(10.0),
          child: SizedBox(
            height: 20.0,
            width: 100.0,
            child: Divider(
              color: Colors.green,
              thickness: 4.0,
            ),
          ),
        ),
        _turnTimes()
      ],
    );
  }

  Widget _turnInfo(AdminTurnController controller) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            color: Colors.green,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.campaign_rounded, size: 58.0),
                  Text(
                    controller.userNumber.value.toString(),
                    style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Siguiente \n número',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
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
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people, size: 58.0),
                  Text(
                    '${controller.allUsers.value.toString()}',
                    style: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Clientes \n por atender',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _turnButtons(AdminTurnController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _callNextClientButton(controller),
              SizedBox(width: 20),
              _cancelNextTurnButton(),
            ],
          ),
          if (_counter > 0)
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: InkWell(
                onTap: () {
                  TurnProvider().finishTurnAndUpdate(_timeUnix, _counter);
                  setState(() {
                    _counter = 0;
                    _counterSec = 0;
                    _counterMin = 0;
                    _timer.cancel();
                  });
                },
                child: SizedBox(
                  width: 260,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(20.0),
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
                          'Terminar turno',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _callNextClientButton(AdminTurnController controller) {
    return InkWell(
      onTap: () async {
        if (_counter == 0) {
          _timeUnix = await TurnProvider().nextTurn(true);
          _startTimer();
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Error'),
              content: Text('Para atender a otro cliente, antes debes terminar el turno'),
            ),
          );
        }
      },
      child: _textButton('Siguiente \n turno', Colors.green),
    );
  }

  Widget _cancelNextTurnButton() {
    return InkWell(
      onTap: () {
        if (_counter == 0) {
          TurnProvider().nextTurn(false);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Error'),
              content: Text('Para pasar de cliente, antes debes terminar el turno'),
            ),
          );
        }
      },
      child: _textButton('Saltar \n turno', Colors.red[300]),
    );
  }

  Widget _textButton(String text, Color color) {
    return SizedBox(
      width: 120,
      height: 80,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
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
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _turnTimes() {
    return Column(
      children: [
        _rowWaitTime('Tiempo medio de espera: ', 10),
        _rowServiceTime('Tiempo medio de atención: ', 10)
      ],
    );
  }

  Widget _rowWaitTime(String text, int averageSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(fontSize: 18)),
        FutureBuilder(
          future: TurnProvider().waitTurnTime(averageSize, ''),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData || snapshot.data == '') {
              return Text('-', style: TextStyle(fontWeight: FontWeight.bold));
            } else {
              return Text(
                '${snapshot.data} min.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              );
            }
          },
        )
      ],
    );
  }

  Widget _rowServiceTime(String text, int averageSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(fontSize: 18)),
        FutureBuilder(
          future: TurnProvider().serviceTurnTime(averageSize),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData || snapshot.data == '') {
              return Text('-', style: TextStyle(fontWeight: FontWeight.bold));
            } else {
              return Text(
                '${snapshot.data} min.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              );
            }
          },
        )
      ],
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
