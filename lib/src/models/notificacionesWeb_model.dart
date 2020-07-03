// To parse this JSON data, do
//
//     final notificacionesWebModel = notificacionesWebModelFromJson(jsonString);

import 'dart:convert';

NotificacionesWebModel notificacionesWebModelFromJson(String str) =>
    NotificacionesWebModel.fromJson(json.decode(str));

String notificacionesWebModelToJson(NotificacionesWebModel data) =>
    json.encode(data.toJson());

class NotificacionesWebModel {
  NotificacionesWebModel({
    this.total,
    this.doctorId,
  });

  int total;
  int doctorId;

  factory NotificacionesWebModel.fromJson(Map<String, dynamic> json) =>
      NotificacionesWebModel(
        total: json["total"],
        doctorId: json["doctorId"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "doctorId": doctorId,
      };
}
