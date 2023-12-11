// To parse this JSON data, do
//
//     final laporan = laporanFromJson(jsonString);

import 'dart:convert';

List<Laporan> laporanFromJson(String str) => List<Laporan>.from(json.decode(str).map((x) => Laporan.fromJson(x)));

String laporanToJson(List<Laporan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Laporan {
    String model;
    int pk;
    Fields fields;

    Laporan({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String name;
    String description;
    bool isRusak;

    Fields({
        required this.user,
        required this.name,
        required this.description,
        required this.isRusak,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
        description: json["description"],
        isRusak: json["is_rusak"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "description": description,
        "is_rusak": isRusak,
    };
}
