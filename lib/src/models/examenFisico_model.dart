import 'dart:convert';

ExamenFisico examenFisicoFromJson(String str) =>
    ExamenFisico.fromJson(json.decode(str));

String examenFisicoToJson(ExamenFisico data) => json.encode(data.toJson());

class ExamenFisico {
  int examenFisicoId;
  int pacienteId;
  int doctorId;
  String aspectoGeneral;
  int edadAparente;
  String marcha;
  String orientaciones;
  String pulso;
  String pabd;
  String ptorax;
  String bbservaciones;
  bool dolorAusente;
  bool dolorPresente;
  bool dolorPresenteLeve;
  bool dolorPresenteModerado;
  bool dolorPresenteSevero;
  double imc;
  int pesoIdeal;
  String interpretacion;
  bool excesoDePeso;
  int librasABajar;
  String cabeza;
  String oidos;
  String ojos;
  String fo;
  String nariz;
  String oroFaringe;
  String cuello;
  String torax;
  String mamas;
  String pulmones;
  String corazon;
  String rot;
  String abdomen;
  String pielfoneras;
  String genitales;
  String rectoProstatico;
  String miembros;
  String neurologico;
  bool activo;
  String creadoPor;
  DateTime creadoFecha;
  String modificadoPor;
  DateTime modificadoFecha;
  String notas;

  ExamenFisico({
    this.examenFisicoId,
    this.pacienteId,
    this.doctorId,
    this.aspectoGeneral,
    this.edadAparente,
    this.marcha,
    this.orientaciones,
    this.pulso,
    this.pabd,
    this.ptorax,
    this.bbservaciones,
    this.dolorAusente,
    this.dolorPresente,
    this.dolorPresenteLeve,
    this.dolorPresenteModerado,
    this.dolorPresenteSevero,
    this.imc,
    this.pesoIdeal,
    this.interpretacion,
    this.excesoDePeso,
    this.librasABajar,
    this.cabeza,
    this.oidos,
    this.ojos,
    this.fo,
    this.nariz,
    this.oroFaringe,
    this.cuello,
    this.torax,
    this.mamas,
    this.pulmones,
    this.corazon,
    this.rot,
    this.abdomen,
    this.pielfoneras,
    this.genitales,
    this.rectoProstatico,
    this.miembros,
    this.neurologico,
    this.activo,
    this.creadoPor,
    this.creadoFecha,
    this.modificadoPor,
    this.modificadoFecha,
    this.notas,
  });

  factory ExamenFisico.fromJson(Map<String, dynamic> json) => ExamenFisico(
        examenFisicoId: json["examenFisicoId"],
        pacienteId: json["pacienteId"],
        doctorId: json["doctorId"],
        aspectoGeneral: json["aspectoGeneral"],
        edadAparente: json["edadAparente"],
        marcha: json["marcha"],
        orientaciones: json["orientaciones"],
        pulso: json["pulso"],
        pabd: json["pabd"],
        ptorax: json["ptorax"],
        bbservaciones: json["bbservaciones"],
        dolorAusente: json["dolorAusente"],
        dolorPresente: json["dolorPresente"],
        dolorPresenteLeve: json["dolorPresenteLeve"],
        dolorPresenteModerado: json["dolorPresenteModerado"],
        dolorPresenteSevero: json["dolorPresenteSevero"],
        imc: json["imc"].toDouble(),
        pesoIdeal: json["pesoIdeal"],
        interpretacion: json["interpretacion"],
        excesoDePeso: json["excesoDePeso"],
        librasABajar: json["librasABajar"],
        cabeza: json["cabeza"],
        oidos: json["oidos"],
        ojos: json["ojos"],
        fo: json["fo"],
        nariz: json["nariz"],
        oroFaringe: json["oroFaringe"],
        cuello: json["cuello"],
        torax: json["torax"],
        mamas: json["mamas"],
        pulmones: json["pulmones"],
        corazon: json["corazon"],
        rot: json["rot"],
        abdomen: json["abdomen"],
        pielfoneras: json["pielfoneras"],
        genitales: json["genitales"],
        rectoProstatico: json["rectoProstatico"],
        miembros: json["miembros"],
        neurologico: json["neurologico"],
        activo: json["activo"],
        creadoPor: json["creadoPor"],
        creadoFecha: DateTime.parse(json["creadoFecha"]),
        modificadoPor: json["modificadoPor"],
        modificadoFecha: DateTime.parse(json["modificadoFecha"]),
        notas: json["notas"],
      );

  Map<String, dynamic> toJson() => {
        "examenFisicoId": examenFisicoId,
        "pacienteId": pacienteId,
        "doctorId": doctorId,
        "aspectoGeneral": aspectoGeneral,
        "edadAparente": edadAparente,
        "marcha": marcha,
        "orientaciones": orientaciones,
        "pulso": pulso,
        "pabd": pabd,
        "ptorax": ptorax,
        "bbservaciones": bbservaciones,
        "dolorAusente": dolorAusente,
        "dolorPresente": dolorPresente,
        "dolorPresenteLeve": dolorPresenteLeve,
        "dolorPresenteModerado": dolorPresenteModerado,
        "dolorPresenteSevero": dolorPresenteSevero,
        "imc": imc,
        "pesoIdeal": pesoIdeal,
        "interpretacion": interpretacion,
        "excesoDePeso": excesoDePeso,
        "librasABajar": librasABajar,
        "cabeza": cabeza,
        "oidos": oidos,
        "ojos": ojos,
        "fo": fo,
        "nariz": nariz,
        "oroFaringe": oroFaringe,
        "cuello": cuello,
        "torax": torax,
        "mamas": mamas,
        "pulmones": pulmones,
        "corazon": corazon,
        "rot": rot,
        "abdomen": abdomen,
        "pielfoneras": pielfoneras,
        "genitales": genitales,
        "rectoProstatico": rectoProstatico,
        "miembros": miembros,
        "neurologico": neurologico,
        "activo": activo,
        "creadoPor": creadoPor,
        "creadoFecha": creadoFecha.toIso8601String(),
        "modificadoPor": modificadoPor,
        "modificadoFecha": modificadoFecha.toIso8601String(),
        "notas": notas,
      };
}
