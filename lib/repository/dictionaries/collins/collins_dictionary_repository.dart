import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/dictionaries/collins/collins_entry_response.dart';
import 'package:gendered/repository/dictionaries/collins/collins_search_response.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class CollinsDictionaryRepository {
  CollinsDictionaryRepository({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: 'https://api.collinsdictionary.com/api/v1',
            headers: {
              'accessKey': '', // this should come from a backend
            },
          ),
        );
  }

  late final Dio _dio;

  Future<Noun?> load({required String search}) async {
    final searchResult = await _search(search: search);

    if (searchResult != null) {
      final entry = await _loadEntry(searchResult: searchResult);
      return entry;
    } else {
      return null;
    }
  }

  Future<Noun?> _loadEntry({
    required CollinsSearchResult searchResult,
  }) async {
    final entryPath =
        '/dictionaries/german-english/entries/${Uri.encodeComponent(searchResult.entryId)}';

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        entryPath,
        queryParameters: {
          'format': 'xml',
          'page': 1,
          'start': 0,
          'limit': 25,
        },
      );

      if (response.data != null) {
        final entryResponse = CollinsEntryResponse.fromJson(response.data!);

        // yes, this parsing is... not ideal :(
        // the API returns the content as an XML document inside a JSON file
        // and it does not provide dedicated nodes for gender, description,
        // audio... unfortunately it's all bundled together
        final contentDocument = XmlDocument.parse(entryResponse.entryContent);
        final genderValue = contentDocument
            .xpath('//gramGrp/pos/text()')
            .first
            .value
            ?.split(' ')
            .first;

        final gender = Gender.values.byName(genderValue!);
        return Noun(name: entryResponse.entryLabel, gender: gender);
      } else {
        return null;
      }
    } catch (e) {
      log('Collins Dictionary exception: $e');
      return null;
    }
  }

  Future<CollinsSearchResult?> _search({required String search}) async {
    const searchPath = '/dictionaries/german-english/search/';

    final queryParameters = {
      'q': search,
      'pagesize': 10,
      'pageindex': 1,
      'page': 1,
      'start': 0,
      'limit': 25,
    };

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        searchPath,
        queryParameters: queryParameters,
      );

      if (response.data != null) {
        try {
          final dicResponse = CollinsSearchResponse.fromJson(response.data!);
          return dicResponse.results.first;
        } catch (e) {
          log('Collins Dictionary exception: $e');
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      log('Collins Dictionary exception: $e');
      return null;
    }
  }
}
