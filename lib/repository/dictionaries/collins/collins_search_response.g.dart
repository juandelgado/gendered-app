// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collins_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollinsSearchResponse _$CollinsSearchResponseFromJson(
  Map<String, dynamic> json,
) =>
    CollinsSearchResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => CollinsSearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

CollinsSearchResult _$CollinsSearchResultFromJson(Map<String, dynamic> json) =>
    CollinsSearchResult(
      entryUrl: json['entryUrl'] as String,
      entryId: json['entryId'] as String,
    );
