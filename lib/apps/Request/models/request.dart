// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

List<Request> requestFromJson(String str) =>
    List<Request>.from(json.decode(str).map((x) => Request.fromJson(x)));

String requestToJson(List<Request> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Request {
  String model;
  int pk;
  Fields fields;

  Request({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
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
  String title;
  String author;
  String description;

  Fields({
    required this.title,
    required this.author,
    required this.description,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        author: json["author"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "description": description,
      };
}
