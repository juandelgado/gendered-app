import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/repository/embedded_nouns/german_embedded_nouns.dart';

void main() async {
  group('German embedded nouns', () {
    test('returns a noun from the list', () async {
      final rawJson = jsonEncode([
        {'noun': 'ABC'},
      ]);

      final embedded = GermanEmbeddedNouns(rawJson: rawJson);

      final noun = await embedded.getRandomNoun();
      expect(noun, equals('ABC'));
    });
  });
}
