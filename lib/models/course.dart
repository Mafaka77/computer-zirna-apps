import 'package:flutter/foundation.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final String thumbnail_url;
  final String price;
  final String intro_url;

  Course(
      {required this.id,
      required this.name,
      required this.description,
      required this.thumbnail_url,
      required this.price,
      required this.intro_url});
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnail_url: json['thumbnail_url'],
      price: json['price'],
      intro_url: json['intro_url']
    );
  }
}
