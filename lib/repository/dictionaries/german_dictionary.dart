import 'dart:developer';

import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/dictionaries/dictionary_repository.dart';
import 'package:gendered/repository/dictionaries/woerter/woerter_dictionary_repository.dart';
import 'package:gendered/repository/dictionary.dart';
import 'package:gendered/repository/embedded_nouns/german_embedded_nouns.dart';

class GermanDictionary implements Dictionary {
  GermanDictionary({
    DictionaryRepository? repository,
    GermanEmbeddedNouns? embeddedNouns,
  }) {
    _repository = repository ?? WoerterDictionaryRepository();
    _embeddedNouns = embeddedNouns ?? GermanEmbeddedNouns();
  }

  late final DictionaryRepository _repository;
  late final GermanEmbeddedNouns _embeddedNouns;
  final int _maxRetries = 10;

  @override
  Future<Noun> loadRandomNoun() async {
    Noun? entry;

    // repositories are far from our control,
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
    return _repository.load(search: randomNound);
  }
}
