import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:tfg_app/src/dialog/display_dialog.dart';
import 'package:tfg_app/src/providers/user_provider.dart';
import 'package:tfg_app/src/widgets/custom_text_field_widget.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0),
            _registerForm(size, context),
          ],
        ),
      ),
    );
  }

  Widget _registerForm(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 40.0,
            ),
          ),
          Container(
            width: size.width * 0.80,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.0),
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
              children: [_customForm(), SizedBox(height: 40.0), _createButton(context)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailTextEditingController,
            data: Icons.email_outlined,
            hintText: 'Correo electrónico',
            isObsecure: false,
          ),
          SizedBox(height: 30.0),
          CustomTextField(
            controller: _passwordTextEditingController,
            data: Icons.lock_outline,
            hintText: 'Contraseña',
            isObsecure: true,
          ),
          SizedBox(height: 30.0),
          CustomTextField(
            controller: _confirmPasswordTextEditingController,
            data: Icons.lock_outline,
            hintText: 'Confirmar contraseña',
            isObsecure: true,
          ),
        ],
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Text(
          'Crear cuenta',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0.0,
        primary: Colors.green,
        textStyle: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _comparePasswords(context);
      },
    );
  }

  void _comparePasswords(BuildContext context) {
    if (_passwordTextEditingController.text != _confirmPasswordTextEditingController.text) {
      DisplayDialog.displayErrorDialog(context, 'Las contraseñas no coincide');
    } else {
      if (_emailTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
          _confirmPasswordTextEditingController.text.isNotEmpty) {
        _register(context);
      } else {
        DisplayDialog.displayErrorDialog(context, 'Rellene todos los campos');
      }
    }
  }

  void _register(BuildContext context) async {
    User user;

    String _email = _emailTextEditingController.text.trim();
    String _password = _passwordTextEditingController.text.trim();
    await UserProvider().register(context, user, _email, _password);
  }
}
