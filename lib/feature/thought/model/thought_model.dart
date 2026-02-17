// To parse this JSON data, do
//
//     final tHoughtModel = tHoughtModelFromJson(jsonString);

import 'dart:convert';

List<ThoughtModel> thoughtModelFromJson(String str) => List<ThoughtModel>.from(json.decode(str).map((x) => ThoughtModel.fromJson(x)));

String thoughtModelToJson(List<ThoughtModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ThoughtModel {
  final String? q;
  final String? a;
  final String? h;

  ThoughtModel({
    this.q,
    this.a,
    this.h,
  });

  factory ThoughtModel.fromJson(Map<String, dynamic> json) => ThoughtModel(
    q: json["q"],
    a: json["a"],
    h: json["h"],
  );

  Map<String, dynamic> toJson() => {
    "q": q,
    "a": a,
    "h": h,
  };
}
