import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/dictionaries/dictionary_repository.dart';
import 'package:html/parser.dart';

class WoerterDictionaryRepository implements DictionaryRepository {
  WoerterDictionaryRepository({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: 'https://www.woerter.net/nouns/meanings/',
          ),
        );
  }

  late final Dio _dio;

  @override
  Future<Noun?> load({required String search}) async {
    try {
      final response = await _dio.get<String>('$search.htm');
      final document = parse(response.data);

      //final grade = document.getElementsByClassName('bZrt').first.text.trim();
      final gender =
          document.querySelector('span[title*="gender"]')?.text.trim();
      final definitions =
          document.getElementsByClassName('wNrn')[0].children.map(
        (element) {
          return element.getElementsByTagName('span')[1].text.trim();
        },
      ).toList()
            ..removeWhere(
              (element) =>
                  element.isEmpty ||
                  element.contains(
                    'No meaning defined yet',
                  ),
            );

      return Noun(
        name: search,
        gender: Gender.values.byName(gender!),
        definitions: definitions,
      );
    } catch (e) {
      log('Woerter Dictionary exception for noun: $search');
      return null;
    }
  }
}
