import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:tfg_app/src/providers/supermarket_services_provider.dart';
import 'package:tfg_app/src/widgets/custom_box_decoration_widget.dart';

class SelectSupermarketServicePage extends StatelessWidget {
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
          'Ver productos de',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
      body: _services(),
    );
  }

  Widget _services() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0),
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
                padding: EdgeInsets.all(10.0),
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
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: InkWell(
          onTap: () {
            if (text == 'carniceria') {
              Get.toNamed('products', arguments: 'carniceria');
            } else if (text == 'charcuteria') {
              Get.toNamed('products', arguments: 'charcuteria');
            } else if (text == 'pescaderia') {
              Get.toNamed('products', arguments: 'pescaderia');
            }
          },
          child: Container(
            padding: EdgeInsets.all(30.0),
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
            child: Center(
              child: Text(
                (() {
                  if (text == 'carniceria') {
                    return 'Carnicería';
                  } else if (text == 'charcuteria') {
                    return 'Charcutería';
                  } else if (text == 'pescaderia') {
                    return 'Pescadería';
                  }
                }()),
                style: TextStyle(fontSize: 38, color: Color(0xFF3f4756)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
