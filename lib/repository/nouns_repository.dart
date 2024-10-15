import 'dart:math';

import 'package:gendered/model/genre.dart';
import 'package:gendered/model/noun.dart';

final List<Noun> _nouns = [
  const Noun(name: 'Liebe', genre: Genre.femenine),
  const Noun(name: 'Orange', genre: Genre.femenine),
  const Noun(name: 'Auto', genre: Genre.neuter),
  const Noun(name: 'Pferd', genre: Genre.neuter),
  const Noun(name: 'Gebäude', genre: Genre.neuter),
  const Noun(name: 'Teppich', genre: Genre.masculine),
  const Noun(name: 'Sittich', genre: Genre.masculine),
];

class NounsRepository {
  Future<Noun> load() async {
    await Future<void>.delayed(
      Duration(milliseconds: Random().nextInt(250)),
    );
    return _nouns[Random().nextInt(_nouns.length)];
  }
}
