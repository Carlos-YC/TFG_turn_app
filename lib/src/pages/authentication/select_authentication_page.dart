import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:tfg_app/src/pages/authentication/register_page.dart';
import 'package:tfg_app/src/pages/authentication/login_page.dart';

class SelectAuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text('Tu turno app',
              style: GoogleFonts.oswald(textStyle: TextStyle(color: Colors.white, fontSize: 32.0))),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock_open_outlined, color: Colors.white),
                text: 'Iniciar sesión',
              ),
              Tab(
                icon: Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
                text: 'Crear nueva cuenta',
              ),
            ],
            indicatorColor: Colors.white54,
            indicatorWeight: 4.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: TabBarView(
            children: [
              LoginPage(),
              RegisterPage(),
            ],
          ),
        ),
      ),
    );
  }
}
