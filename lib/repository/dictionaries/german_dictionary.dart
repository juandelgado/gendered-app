import 'dart:developer';

import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/dictionaries/collins/collins_dictionary_repository.dart';
import 'package:gendered/repository/dictionary_repository.dart';
import 'package:gendered/repository/embedded_nouns/german_embedded_nouns.dart';

class GermanDictionary implements DictionaryRepository {
  GermanDictionary({
    CollinsDictionaryRepository? collins,
    GermanEmbeddedNouns? embeddedNouns,
  }) {
    _collins = collins ?? CollinsDictionaryRepository();
    _embeddedNouns = embeddedNouns ?? GermanEmbeddedNouns();
  }

  late final CollinsDictionaryRepository _collins;
  late final GermanEmbeddedNouns _embeddedNouns;
  final int _maxRetries = 10;

  @override
  Future<Noun> loadRandomNoun() async {
    Noun? entry;

    // collins is far from our control,
    // so being super defensive here
    for (var i = 0; i < _maxRetries; i++) {
      try {
        entry = await _loadDictionaryEntry();
        if (entry == null) {
          await Future<void>.delayed(const Duration(milliseconds: 200));
        } else {
          break;
        }
      } catch (e) {
        log('German dictionary exception: $e');
      }
    }

    if (entry == null) {
      throw UnavailableNounException(
        'Could not load an entry from the German dictionary',
      );
    }

    return entry;
  }

  Future<Noun?> _loadDictionaryEntry() async {
    final randomNound = await _embeddedNouns.getRandomNoun();
    return _collins.load(search: randomNound);
  }
}
