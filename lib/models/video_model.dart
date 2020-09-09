// To parse this JSON data, do
//
//     final superVideoEval = superVideoEvalFromJson(jsonString);

import 'dart:convert';

List<VideoModel> superVideoEvalFromJson(String str) => List<VideoModel>.from(json.decode(str).map((x) => VideoModel.fromJson(x)));

String superVideoEvalToJson(List<VideoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoModel {
  VideoModel({
    this.file,
    this.label,
  });

  String file;
  String label;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    file: json["file"],
    label: json["label"] == null ? "Unkown" : json["label"],
  );

  Map<String, dynamic> toJson() => {
    "file": file,
    "label": label == null ? null : label,
  };
}
