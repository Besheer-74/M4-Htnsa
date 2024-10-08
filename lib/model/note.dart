import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note {
  final int id;
  final String title;
  final String content;
  final String timestamp;
  final Color? color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.color,
  });

  // Convert a Map from the database to a Note object
  factory Note.fromMap(Map<dynamic, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      timestamp: map['timestamp'] as String,
      color: Color(map['color']), // Convert int to Color
    );
  }

// Convert a Note object to a Map for the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'color': color?.value, // Convert Color to int
    };
  }

  Note copyWith({
    Color? color,
    int? id,
    String? title,
    String? content,
    String? timestamp,
  }) {
    return Note(
      id: id ?? this.id,
      color: color ?? this.color,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  static fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}
