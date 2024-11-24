import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/repository/dictionaries/woerter/woerter_dictionary_repository.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late WoerterDictionaryRepository dictionary;

  setUp(() {
    dio = Dio();
    adapter = DioAdapter(dio: dio);
    dictionary = WoerterDictionaryRepository(dio: dio);
  });

  group('Woerter dictionary', () {
    test('returns null if server does not return 200', () async {
      adapter.onGet(
        'pferd.htm',
        (server) => server.reply(403, {'some': 'value'}),
      );

      final noun = await dictionary.load(search: 'pferd');
      expect(noun, isNull);
    });

    test('returns null if HTML response cannot be parsed', () async {
      adapter.onGet(
        'pferd.htm',
        (server) => server.reply(200, '<not><html>'),
      );

      final noun = await dictionary.load(search: 'pferd');
      expect(noun, isNull);
    });
  });
}
