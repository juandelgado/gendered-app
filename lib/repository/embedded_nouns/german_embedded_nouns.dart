import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:gendered/repository/embedded_nouns/embedded_noun.dart';

class GermanEmbeddedNouns {
  GermanEmbeddedNouns({String? rawJson}) {
    _rawJson = rawJson;
  }

  final List<EmbeddedNoun> _nouns = [];
  late String? _rawJson;

  Future<String> getRandomNoun() async {
    if (_nouns.isEmpty) {
      await _load();
    }
    return _nouns[Random().nextInt(_nouns.length)].noun;
  }

  Future<void> _load() async {
    _rawJson ??= await rootBundle.loadString('assets/nouns/de/nouns.json');
    final rawNounsData = jsonDecode(_rawJson!);

    _nouns.addAll(
      (rawNounsData as List)
          .map<EmbeddedNoun>(
            (json) => EmbeddedNoun.fromJson(json as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
