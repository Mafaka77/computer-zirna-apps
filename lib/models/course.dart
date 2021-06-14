import 'package:flutter/foundation.dart';

class Course {
  final String id;
  final String name;
  final String details;
  final String imageUrl;
  final String price;
  final String vidUrl;

  Course(
      {required this.id,
      required this.name,
      required this.details,
      required this.imageUrl,
      required this.price,
      required this.vidUrl});
}
