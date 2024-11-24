// ignore_for_file: one_member_abstracts

import 'package:gendered/model/noun.dart';

abstract class Dictionary {
  Future<Noun> loadRandomNoun();
}

class UnavailableNounException implements Exception {
  UnavailableNounException(this.message);

  final String message;

  @override
  String toString() => 'UnavailableNounException: $message';
}
