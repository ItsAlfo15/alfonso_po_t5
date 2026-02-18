// To parse this JSON data, do
//
//     final watchResponse = watchResponseFromJson(jsonString);

import 'dart:convert';

WatchResponse watchResponseFromJson(String str) => WatchResponse.fromJson(json.decode(str));

String watchResponseToJson(WatchResponse data) => json.encode(data.toJson());

class WatchResponse {
    String status;
    int total;
    int currentPage;
    int totalPages;
    int perPage;
    List<Reloj> data;

    WatchResponse({
        required this.status,
        required this.total,
        required this.currentPage,
        required this.totalPages,
        required this.perPage,
        required this.data,
    });

    factory WatchResponse.fromJson(Map<String, dynamic> json) => WatchResponse(
        status: json["status"],
        total: json["total"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        perPage: json["perPage"],
        data: List<Reloj>.from(json["data"].map((x) => Reloj.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "total": total,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "perPage": perPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Reloj {
    String id;
    DateTime fechaRegistro;
    String marca;
    String modelo;
    String referencia;
    String descripcionResumida;
    Estado estado;
    bool disponibilidad;
    int anioFabricacion;
    bool tieneCaja;
    bool tienePapeles;
    double valoracion;
    InformacionGeneral informacionGeneral;
    Calibre calibre;
    String descripcion;
    Pulsera pulsera;
    int precio;
    Caja caja;
    String fechaModificacion;
    List<String> imagenes;

    Reloj({
        required this.id,
        required this.fechaRegistro,
        required this.marca,
        required this.modelo,
        required this.referencia,
        required this.descripcionResumida,
        required this.estado,
        required this.disponibilidad,
        required this.anioFabricacion,
        required this.tieneCaja,
        required this.tienePapeles,
        required this.valoracion,
        required this.informacionGeneral,
        required this.calibre,
        required this.descripcion,
        required this.pulsera,
        required this.precio,
        required this.caja,
        required this.fechaModificacion,
        required this.imagenes,
    });

    factory Reloj.fromJson(Map<String, dynamic> json) => Reloj(
        id: json["id"],
        fechaRegistro: DateTime.parse(json["fecha_registro"]),
        marca: json["marca"],
        modelo: json["modelo"],
        referencia: json["referencia"],
        descripcionResumida: json["descripcion_resumida"],
        estado: Estado.fromJson(json["estado"]),
        disponibilidad: json["disponibilidad"],
        anioFabricacion: json["anio_fabricacion"],
        tieneCaja: json["tiene_caja"],
        tienePapeles: json["tiene_papeles"],
        valoracion: json["valoracion"]?.toDouble(),
        informacionGeneral: InformacionGeneral.fromJson(json["informacion_general"]),
        calibre: Calibre.fromJson(json["calibre"]),
        descripcion: json["descripcion"],
        pulsera: Pulsera.fromJson(json["pulsera"]),
        precio: json["precio"],
        caja: Caja.fromJson(json["caja"]),
        fechaModificacion: json["fecha_modificacion"],
        imagenes: List<String>.from(json["imagenes"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fecha_registro": fechaRegistro.toIso8601String(),
        "marca": marca,
        "modelo": modelo,
        "referencia": referencia,
        "descripcion_resumida": descripcionResumida,
        "estado": estado.toJson(),
        "disponibilidad": disponibilidad,
        "anio_fabricacion": anioFabricacion,
        "tiene_caja": tieneCaja,
        "tiene_papeles": tienePapeles,
        "valoracion": valoracion,
        "informacion_general": informacionGeneral.toJson(),
        "calibre": calibre.toJson(),
        "descripcion": descripcion,
        "pulsera": pulsera.toJson(),
        "precio": precio,
        "caja": caja.toJson(),
        "fecha_modificacion": fechaModificacion,
        "imagenes": List<dynamic>.from(imagenes.map((x) => x)),
    };
}

class Caja {
    String material;
    int diametro;
    String? resistenciaAgua;
    String materialBisel;
    String cristal;
    String esfera;
    String tipoNumeros;

    Caja({
        required this.material,
        required this.diametro,
        required this.resistenciaAgua,
        required this.materialBisel,
        required this.cristal,
        required this.esfera,
        required this.tipoNumeros,
    });

    factory Caja.fromJson(Map<String, dynamic> json) => Caja(
        material: json["material"],
        diametro: json["diametro"],
        resistenciaAgua: json["resistencia_agua"] ?? 'Sin datos' ,
        materialBisel: json["material_bisel"],
        cristal: json["cristal"],
        esfera: json["esfera"],
        tipoNumeros: json["tipo_numeros"],
    );

    Map<String, dynamic> toJson() => {
        "material": material,
        "diametro": diametro,
        "resistencia_agua": resistenciaAgua,
        "material_bisel": materialBisel,
        "cristal": cristal,
        "esfera": esfera,
        "tipo_numeros": tipoNumeros,
    };
}

class Calibre {
    String tipoCalibre;
    String? codCalibre;
    int? reservaMarcha;

    Calibre({
        required this.tipoCalibre,
        required this.codCalibre,
        required this.reservaMarcha,
    });

    factory Calibre.fromJson(Map<String, dynamic> json) => Calibre(
        tipoCalibre: json["tipo_calibre"],
        codCalibre: json["cod_calibre"] ?? 'Sin datos',
        reservaMarcha: json["reserva_marcha"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "tipo_calibre": tipoCalibre,
        "cod_calibre": codCalibre,
        "reserva_marcha": reservaMarcha,
    };
}

class Estado {
    String tipo;
    String descripcionEstado;

    Estado({
        required this.tipo,
        required this.descripcionEstado,
    });

    factory Estado.fromJson(Map<String, dynamic> json) => Estado(
        tipo: json["tipo"],
        descripcionEstado: json["descripcion_estado"],
    );

    Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "descripcion_estado": descripcionEstado,
    };
}

class InformacionGeneral {
    String categoria;
    String genero;
    String ubicacion;

    InformacionGeneral({
        required this.categoria,
        required this.genero,
        required this.ubicacion,
    });

    factory InformacionGeneral.fromJson(Map<String, dynamic> json) => InformacionGeneral(
        categoria: json["categoria"],
        genero: json["genero"],
        ubicacion: json["ubicacion"],
    );

    Map<String, dynamic> toJson() => {
        "categoria": categoria,
        "genero": genero,
        "ubicacion": ubicacion,
    };
}

class Pulsera {
    String materialPulsera;
    String color;
    String cierre;
    String materialCierre;

    Pulsera({
        required this.materialPulsera,
        required this.color,
        required this.cierre,
        required this.materialCierre,
    });

    factory Pulsera.fromJson(Map<String, dynamic> json) => Pulsera(
        materialPulsera: json["material_pulsera"],
        color: json["color"],
        cierre: json["cierre"],
        materialCierre: json["material_cierre"],
    );

    Map<String, dynamic> toJson() => {
        "material_pulsera": materialPulsera,
        "color": color,
        "cierre": cierre,
        "material_cierre": materialCierre,
    };
}
