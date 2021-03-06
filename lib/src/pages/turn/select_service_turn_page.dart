import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tfg_app/src/config/config.dart';

import 'package:tfg_app/src/providers/supermarket_services_provider.dart';
import 'package:tfg_app/src/providers/turn_provider.dart';

import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class SelectServiceTurnPage extends StatelessWidget {
  final String supermarketID = SupermarketApp.sharedPreferences.getString(SupermarketApp.marketId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: CustomBoxDecoration(
          color1: Colors.lightGreen,
          color2: Colors.green,
        ),
        title: Text(
          'Pedir turno',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
      body: _services(),
    );
  }

  Widget _services() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: FutureBuilder(
        future: SupermarketServicesProvider().supermarketServices(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Widget> listServices = [];
            snapshot.data.map((service) {
              if (!service.isBlank) {
                listServices.add(_boxButton(service));
              }
            }).toString();

            return Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(30.0),
                children: listServices,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _boxButton(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40.0),
        child: InkWell(
          onTap: () {
            if (text == 'carniceria') {
              TurnProvider().createTurn(supermarketID, 'carniceria');
              Get.toNamed('userTurn');
            } else if (text == 'charcuteria') {
              TurnProvider().createTurn(supermarketID, 'charcuteria');
              Get.toNamed('userTurn');
            } else if (text == 'pescaderia') {
              TurnProvider().createTurn(supermarketID, 'pescaderia');
              Get.toNamed('userTurn');
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50),
            decoration: BoxDecoration(
              color: () {
                if (text == 'carniceria') {
                  return Colors.red[300];
                } else if (text == 'charcuteria') {
                  return Colors.orange[300];
                } else if (text == 'pescaderia') {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  height: 80,
                  image: AssetImage(
                    () {
                      if (text == 'carniceria') {
                        return 'assets/images/meat.png';
                      } else if (text == 'charcuteria') {
                        return 'assets/images/jammed.png';
                      } else if (text == 'pescaderia') {
                        return 'assets/images/fish.png';
                      }
                    }(),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  () {
                    if (text == 'carniceria') {
                      return 'Carnicer??a';
                    } else if (text == 'charcuteria') {
                      return 'Charcuter??a';
                    } else if (text == 'pescaderia') {
                      return 'Pescader??a';
                    }
                  }(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
