// To parse this JSON data, do
//
//     final productModel = productModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ProductModel {
  ProductModel({
    @required this.informacionNutricional,
    @required this.ingredientes,
    @required this.alergenos,
    @required this.disponible,
    @required this.id,
    @required this.imagenUrl,
    @required this.marca,
    @required this.nombre,
    @required this.oferta,
    @required this.origen,
    @required this.precioKg,
    @required this.proveedor,
    @required this.tipo,
  });

  final InformacionNutricional informacionNutricional;
  final List<String> ingredientes;
  final List<String> alergenos;
  final bool disponible;
  final String id;
  final String imagenUrl;
  final String marca;
  final String nombre;
  final bool oferta;
  final String origen;
  final double precioKg;
  final String proveedor;
  final String tipo;

  factory ProductModel.fromJson(String str) => ProductModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductModel.fromMap(Map<String, dynamic> json) => ProductModel(
    informacionNutricional  : InformacionNutricional.fromMap(json["informacionNutricional"]),
    ingredientes            : List<String>.from(json["ingredientes"].map((x) => x)),
    alergenos               : List<String>.from(json["alergenos"].map((x) => x)),
    disponible              : json["disponible"] == '' ? false : json["disponible"],
    id                      : json["id"].toString(),
    imagenUrl               : json["imagenUrl"].toString(),
    marca                   : json["marca"].toString(),
    nombre                  : json["nombre"].toString(),
    oferta                  : json["oferta"] == '' ? false : json["oferta"],
    origen                  : json["origen"].toString(),
    precioKg                : json["precioKg"].toDouble(),
    proveedor               : json["proveedor"].toString(),
    tipo                    : json["tipo"].toString(),
  );

  Map<String, dynamic> toMap() => {
    "informacionNutricional"  : informacionNutricional.toMap(),
    "ingredientes"            : List<dynamic>.from(ingredientes.map((x) => x)),
    "alergenos"               : List<dynamic>.from(alergenos.map((x) => x)),
    "disponible"              : disponible,
    "id"                      : id,
    "imagenUrl"               : imagenUrl,
    "marca"                   : marca,
    "nombre"                  : nombre,
    "oferta"                  : oferta,
    "origen"                  : origen,
    "precioKg"                : precioKg,
    "proveedor"               : proveedor,
    "tipo"                    : tipo,
  };
}

class InformacionNutricional {
  InformacionNutricional({
    @required this.azucares,
    @required this.calcio,
    @required this.energeticoKcal,
    @required this.grasas,
    @required this.grasasSaturadas,
    @required this.hidratosCarbono,
    @required this.proteinas,
    @required this.sal,
  });

  final double azucares;
  final double calcio;
  final double energeticoKcal;
  final double grasas;
  final double grasasSaturadas;
  final double hidratosCarbono;
  final double proteinas;
  final double sal;

  factory InformacionNutricional.fromJson(String str) => InformacionNutricional.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InformacionNutricional.fromMap(Map<String, dynamic> json) => InformacionNutricional(
    azucares          : json["azucares"] == '' ? 0.0 : json["azucares"].toDouble(),
    calcio            : json["calcio"] == '' ? 0.0 : json["calcio"].toDouble(),
    energeticoKcal    : json["energeticoKcal"] == '' ? 0.0 : json["energeticoKcal"].toDouble(),
    grasas            : json["grasas"] == '' ? 0.0 : json["grasas"].toDouble(),
    grasasSaturadas   : json["grasasSaturadas"] == '' ? 0.0 : json["grasasSaturadas"].toDouble(),
    hidratosCarbono   : json["hidratosCarbono"] == '' ? 0.0 : json["hidratosCarbono"].toDouble(),
    proteinas         : json["proteinas"] == '' ? 0.0 : json["proteinas"].toDouble(),
    sal               : json["sal"] == '' ? 0.0 : json["sal"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "azucares"        : azucares,
    "calcio"          : calcio,
    "energeticoKcal"  : energeticoKcal,
    "grasas"          : grasas,
    "grasasSaturadas" : grasasSaturadas,
    "hidratosCarbono" : hidratosCarbono,
    "proteinas"       : proteinas,
    "sal"             : sal,
  };
}
