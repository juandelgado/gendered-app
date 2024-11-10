import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';
import 'package:gendered/repository/dictionaries/collins/collins_dictionary_repository.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('Collins Dictionary', () {
    late Dio dio;
    late DioAdapter adapter;
    late CollinsDictionaryRepository dictionary;

    setUp(() {
      dio = Dio();
      adapter = DioAdapter(dio: dio);
      dictionary = CollinsDictionaryRepository(dio: dio);
    });

    test('returns null if no search results returned', () async {
      adapter.onGet(
        '/dictionaries/german-english/search/',
        (server) => server.reply(200, searchNoResult),
      );

      final noun = await dictionary.load(search: 'pferd');
      expect(noun, isNull);
    });

    test('returns null if the search returns 403', () async {
      adapter.onGet(
        '/dictionaries/german-english/search/',
        (server) => server.reply(403, forbiddenResponse),
      );

      final noun = await dictionary.load(search: 'pferd');
      expect(noun, isNull);
    });

    test('returns null if entry request returns 404, invalid entry', () async {
      adapter
        ..onGet(
          '/dictionaries/german-english/search/',
          (server) => server.reply(200, searchResult),
        )
        ..onGet(
          '/dictionaries/german-english/entries/${Uri.encodeComponent('kunst_1')}',
          (server) => server.reply(404, entryInvalid),
        );

      final noun = await dictionary.load(search: 'kunst');
      expect(noun, isNull);
    });

    test('returns null if entry request returns 403', () async {
      adapter
        ..onGet(
          '/dictionaries/german-english/search/',
          (server) => server.reply(200, searchResult),
        )
        ..onGet(
          '/dictionaries/german-english/entries/${Uri.encodeComponent('kunst_1')}',
          (server) => server.reply(403, forbiddenResponse),
        );

      final noun = await dictionary.load(search: 'kunst');
      expect(noun, isNull);
    });

    test('returns null if it fails to parse entry content', () async {
      adapter
        ..onGet(
          '/dictionaries/german-english/search/',
          (server) => server.reply(200, searchResult),
        )
        ..onGet(
          '/dictionaries/german-english/entries/${Uri.encodeComponent('kunst_1')}',
          (server) => server.reply(200, bogusEntryResult),
        );

      final noun = await dictionary.load(search: 'kunst');
      expect(noun, isNull);
    });

    test('correctly parses search and entry results', () async {
      adapter
        ..onGet(
          '/dictionaries/german-english/search/',
          (server) => server.reply(200, searchResult),
        )
        ..onGet(
          '/dictionaries/german-english/entries/${Uri.encodeComponent('kunst_1')}',
          (server) => server.reply(200, entryResult),
        );

      final noun = await dictionary.load(search: 'kunst');
      expect(
        noun,
        const Noun(name: 'Kunst', gender: Gender.feminine, definitions: []),
      );
    });
  });
}

const searchResult = {
  'resultNumber': 2,
  'results': [
    {
      'entryLabel': 'Kunst',
      'entryUrl':
          'http://api.collinsdictionary.com/api/v1/dictionaries/german-english/entries/kunst_1',
      'entryId': 'kunst_1',
    },
    {
      'entryLabel': 'BK',
      'entryUrl':
          'http://api.collinsdictionary.com/api/v1/dictionaries/german-english/entries/bk_1',
      'entryId': 'bk_1',
    },
  ],
  'dictionaryCode': 'german-english',
  'currentPageIndex': 1,
  'pageNumber': 1,
};

const entryResult = {
  'topics': <dynamic>[],
  'dictionaryCode': 'german-english',
  'entryLabel': 'Kunst',
  'entryContent':
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<entry mld-id=\"w0004490\" id=\"kunst_1\" lang=\"de\" idm_id=\"000026772\"><form><orth>Kunst</orth><span> [</span><pron type=\"\">kʊnst<audio type=\"pronunciation\" title=\"Kunst\"><source type=\"audio/mpeg\" src=\"https://api.collinsdictionary.com/media/sounds/sounds/d/de_/de_w0/de_w0004490.mp3\"/>Your browser does not support HTML5 audio.</audio></pron><span>]</span></form><hom id=\"kunst_1.1\"><span>   </span><gramGrp><pos>feminine noun</pos></gramGrp><form type=\"infl\"><orth><span class=\"bluebold\">, </span>Kunst</orth><lbl type=\"gram\"><span> </span>genitive</lbl></form><form type=\"infl\"><orth><span class=\"bluebold\">, </span>Künste</orth><form><span> [</span><pron type=\"\">ˈkʏnstə<audio type=\"pronunciation\" title=\"\"><source type=\"audio/mpeg\" src=\"https://api.collinsdictionary.com/media/sounds/sounds/d/de_/de_ku/de_kunste.mp3\"/>Your browser does not support HTML5 audio.</audio></pron><span>]</span></form><lbl type=\"gram\"><span> </span>plural</lbl></form><sense n=\"1\"><span>   </span><span class=\"bold\">1 </span><cit lang=\"en-gb\" type=\"translation\"><quote>art</quote></cit><cit type=\"example\" id=\"kunst_1.2\"><span>;   </span><quote>die schönen Künste</quote><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>fine art <hi rend=\"i\">sing</hi></quote></cit><span>, </span><cit type=\"translation\" lang=\"en-gb\"><quote>the fine arts</quote></cit></cit></sense><sense n=\"2\"><span><br/></span><span class=\"bold\">2 </span><lbl type=\"syn\"><span>(= </span>Können, Fertigkeit<span>)</span></lbl><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>art</quote></cit><span>, </span><cit type=\"translation\" lang=\"en-gb\"><quote>skill</quote></cit><cit type=\"example\" id=\"kunst_1.3\"><span>;   </span><quote>mit seiner Kunst am <hi rend=\"i\">or</hi> zu Ende sein</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>to be at one's wits' end</quote></cit></cit><cit type=\"example\" id=\"kunst_1.4\"><span>;   </span><quote>die Kunst besteht darin, ...</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>the art is in ...</quote></cit></cit><cit id=\"kunst_1.5\" type=\"example\"><span>;   </span><quote>ärztliche Kunst</quote><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>medical skill</quote></cit></cit></sense><sense n=\"3\"><span><br/></span><span class=\"bold\">3 </span><lbl type=\"syn\"><span>(= </span>Kunststück<span>)</span></lbl><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>trick</quote></cit><cit id=\"kunst_1.6\" type=\"example\"><span>;   </span><quote>das ist keine Kunst!</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>it's like taking candy from a baby <lbl type=\"register\"><span>(</span>inf<span>)</span></lbl></quote></cit><span>; </span><lbl type=\"syn\"><span>(= </span>ein Kinderspiel<span>)</span></lbl><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>it's a piece of cake <lbl type=\"register\"><span>(</span>inf<span>)</span></lbl></quote></cit></cit><cit id=\"kunst_1.7\" type=\"example\"><span>;   </span><quote>so einfach ist das, das ist die ganze Kunst</quote><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>it's that easy, that's all there is to it</quote></cit></cit></sense><sense n=\"4\"><span><br/></span><span class=\"bold\">4 </span><lbl type=\"register\"><span>(</span>informal<span>)</span></lbl><re id=\"kunst_1.8\" type=\"minimalunit\"><span>: </span><form type=\"min_phr\"><orth>das ist eine brotlose Kunst</orth></form><sense><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>there's no money in that</quote></cit></sense></re><cit type=\"example\" id=\"kunst_1.9\"><span>;   </span><quote>was macht die Kunst?</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>how are things?</quote></cit></cit></sense></hom><form type=\"inflected\"><orth>Künste</orth><orth>Künsten</orth></form></entry>\n",
  'entryUrl':
      'http://api.collinsdictionary.com/api/v1/dictionaries/german-english/entries/kunst_1',
  'format': 'xml',
  'entryId': 'kunst_1',
};

const bogusEntryResult = {
  'topics': <dynamic>[],
  'dictionaryCode': 'german-english',
  'entryLabel': 'Kunst',
  'entryContent':
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<entry mld-id=\"w0004490\" id=\"kunst_1\" lang=\"de\" idm_id=\"000026772\"><form><orth>Kunst</orth><span> [</span><pron type=\"\">kʊnst<audio type=\"pronunciation\" title=\"Kunst\"><source type=\"audio/mpeg\" src=\"https://api.collinsdictionary.com/media/sounds/sounds/d/de_/de_w0/de_w0004490.mp3\"/>Your browser does not support HTML5 audio.</audio></pron><span>]</span></form><hom id=\"kunst_1.1\"><span>   </span><form type=\"infl\"><orth><span class=\"bluebold\">, </span>Kunst</orth><lbl type=\"gram\"><span> </span>genitive</lbl></form><form type=\"infl\"><orth><span class=\"bluebold\">, </span>Künste</orth><form><span> [</span><pron type=\"\">ˈkʏnstə<audio type=\"pronunciation\" title=\"\"><source type=\"audio/mpeg\" src=\"https://api.collinsdictionary.com/media/sounds/sounds/d/de_/de_ku/de_kunste.mp3\"/>Your browser does not support HTML5 audio.</audio></pron><span>]</span></form><lbl type=\"gram\"><span> </span>plural</lbl></form><sense n=\"1\"><span>   </span><span class=\"bold\">1 </span><cit lang=\"en-gb\" type=\"translation\"><quote>art</quote></cit><cit type=\"example\" id=\"kunst_1.2\"><span>;   </span><quote>die schönen Künste</quote><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>fine art <hi rend=\"i\">sing</hi></quote></cit><span>, </span><cit type=\"translation\" lang=\"en-gb\"><quote>the fine arts</quote></cit></cit></sense><sense n=\"2\"><span><br/></span><span class=\"bold\">2 </span><lbl type=\"syn\"><span>(= </span>Können, Fertigkeit<span>)</span></lbl><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>art</quote></cit><span>, </span><cit type=\"translation\" lang=\"en-gb\"><quote>skill</quote></cit><cit type=\"example\" id=\"kunst_1.3\"><span>;   </span><quote>mit seiner Kunst am <hi rend=\"i\">or</hi> zu Ende sein</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>to be at one's wits' end</quote></cit></cit><cit type=\"example\" id=\"kunst_1.4\"><span>;   </span><quote>die Kunst besteht darin, ...</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>the art is in ...</quote></cit></cit><cit id=\"kunst_1.5\" type=\"example\"><span>;   </span><quote>ärztliche Kunst</quote><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>medical skill</quote></cit></cit></sense><sense n=\"3\"><span><br/></span><span class=\"bold\">3 </span><lbl type=\"syn\"><span>(= </span>Kunststück<span>)</span></lbl><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>trick</quote></cit><cit id=\"kunst_1.6\" type=\"example\"><span>;   </span><quote>das ist keine Kunst!</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>it's like taking candy from a baby <lbl type=\"register\"><span>(</span>inf<span>)</span></lbl></quote></cit><span>; </span><lbl type=\"syn\"><span>(= </span>ein Kinderspiel<span>)</span></lbl><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>it's a piece of cake <lbl type=\"register\"><span>(</span>inf<span>)</span></lbl></quote></cit></cit><cit id=\"kunst_1.7\" type=\"example\"><span>;   </span><quote>so einfach ist das, das ist die ganze Kunst</quote><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>it's that easy, that's all there is to it</quote></cit></cit></sense><sense n=\"4\"><span><br/></span><span class=\"bold\">4 </span><lbl type=\"register\"><span>(</span>informal<span>)</span></lbl><re id=\"kunst_1.8\" type=\"minimalunit\"><span>: </span><form type=\"min_phr\"><orth>das ist eine brotlose Kunst</orth></form><sense><span> </span><cit type=\"translation\" lang=\"en-gb\"><quote>there's no money in that</quote></cit></sense></re><cit type=\"example\" id=\"kunst_1.9\"><span>;   </span><quote>was macht die Kunst?</quote><span> </span><cit lang=\"en-gb\" type=\"translation\"><quote>how are things?</quote></cit></cit></sense></hom><form type=\"inflected\"><orth>Künste</orth><orth>Künsten</orth></form></entry>\n",
  'entryUrl':
      'http://api.collinsdictionary.com/api/v1/dictionaries/german-english/entries/kunst_1',
  'format': 'xml',
  'entryId': 'kunst_1',
};

const searchNoResult = {
  'resultNumber': 0,
  'results': <dynamic>[],
  'dictionaryCode': 'german-english',
  'currentPageIndex': 1,
  'pageNumber': 0,
};

const forbiddenResponse = {
  'errorCode': 'NoAccessKey',
  'errorMessage': 'No access key!',
};

const entryInvalid = {
  'errorCode': 'InvalidEntryId',
  'errorMessage': "Entry 'lol' not found.",
};
