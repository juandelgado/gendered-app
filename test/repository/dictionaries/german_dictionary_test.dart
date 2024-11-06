import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/dictionaries/collins/collins_dictionary_repository.dart';
import 'package:gendered/repository/dictionaries/german_dictionary.dart';
import 'package:gendered/repository/dictionary_repository.dart';
import 'package:gendered/repository/embedded_nouns/german_embedded_nouns.dart';
import 'package:mocktail/mocktail.dart';

class MockCollins extends Mock implements CollinsDictionaryRepository {}

class MockGermanNouns extends Mock implements GermanEmbeddedNouns {}

void main() {
  group('German Dictionary', () {
    late CollinsDictionaryRepository mockCollins;
    late GermanEmbeddedNouns mockNouns;
    late GermanDictionary dictionary;

    const wadusName = 'wadus';
    const wadusNoun = Noun(name: wadusName, gender: Gender.neuter);

    setUp(() {
      mockCollins = MockCollins();
      mockNouns = MockGermanNouns();

      dictionary =
          GermanDictionary(collins: mockCollins, embeddedNouns: mockNouns);
    });

    test('returns random noun from Collins', () async {
      when(
        () => mockNouns.getRandomNoun(),
      ).thenAnswer(
        (_) async => wadusName,
      );

      when(
        () => mockCollins.load(
          search: any(named: 'search', that: equals(wadusName)),
        ),
      ).thenAnswer(
        (_) async => wadusNoun,
      );

      final noun = await dictionary.loadRandomNoun();
      expect(noun, wadusNoun);
    });

    test('throws if Collins does not return a random noun', () async {
      when(
        () => mockNouns.getRandomNoun(),
      ).thenAnswer(
        (_) async => wadusName,
      );

      when(
        () => mockCollins.load(
          search: any(named: 'search', that: equals(wadusName)),
        ),
      ).thenAnswer(
        (_) async => null,
      );

      expect(
        () => dictionary.loadRandomNoun(),
        throwsA(isA<UnavailableNounException>()),
      );
    });
  });
}
