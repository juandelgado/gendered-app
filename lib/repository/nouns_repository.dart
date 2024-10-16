import 'dart:math';

import 'package:gendered/model/gender.dart';
import 'package:gendered/model/noun.dart';

final List<Noun> _nouns = [
  const Noun(name: 'Liebe', gender: Gender.feminine),
  const Noun(name: 'Orange', gender: Gender.feminine),
  const Noun(name: 'Auto', gender: Gender.neuter),
  const Noun(name: 'Pferd', gender: Gender.neuter),
  const Noun(name: 'Gebäude', gender: Gender.neuter),
  const Noun(name: 'Teppich', gender: Gender.masculine),
  const Noun(name: 'Sittich', gender: Gender.masculine),
];

class NounsRepository {
  Future<Noun> load() async {
    await Future<void>.delayed(
      Duration(milliseconds: Random().nextInt(250)),
    );
    return _nouns[Random().nextInt(_nouns.length)];
  }
}
