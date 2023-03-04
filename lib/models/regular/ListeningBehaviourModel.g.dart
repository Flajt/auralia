// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListeningBehaviourModel.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetListeningBehaviourModelCollection on Isar {
  IsarCollection<ListeningBehaviourModel> get listeningBehaviourModels =>
      this.collection();
}

const ListeningBehaviourModelSchema = CollectionSchema(
  name: r'ListeningBehaviourModel',
  id: -7092896546538375846,
  properties: {
    r'activity': PropertySchema(
      id: 0,
      name: r'activity',
      type: IsarType.string,
    ),
    r'artists': PropertySchema(
      id: 1,
      name: r'artists',
      type: IsarType.stringList,
    ),
    r'dateTimeInMis': PropertySchema(
      id: 2,
      name: r'dateTimeInMis',
      type: IsarType.long,
    ),
    r'genres': PropertySchema(
      id: 3,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'latitude': PropertySchema(
      id: 4,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 5,
      name: r'longitude',
      type: IsarType.double,
    )
  },
  estimateSize: _listeningBehaviourModelEstimateSize,
  serialize: _listeningBehaviourModelSerialize,
  deserialize: _listeningBehaviourModelDeserialize,
  deserializeProp: _listeningBehaviourModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _listeningBehaviourModelGetId,
  getLinks: _listeningBehaviourModelGetLinks,
  attach: _listeningBehaviourModelAttach,
  version: '3.0.5',
);

int _listeningBehaviourModelEstimateSize(
  ListeningBehaviourModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activity.length * 3;
  bytesCount += 3 + object.artists.length * 3;
  {
    for (var i = 0; i < object.artists.length; i++) {
      final value = object.artists[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.genres.length * 3;
  {
    for (var i = 0; i < object.genres.length; i++) {
      final value = object.genres[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _listeningBehaviourModelSerialize(
  ListeningBehaviourModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activity);
  writer.writeStringList(offsets[1], object.artists);
  writer.writeLong(offsets[2], object.dateTimeInMis);
  writer.writeStringList(offsets[3], object.genres);
  writer.writeDouble(offsets[4], object.latitude);
  writer.writeDouble(offsets[5], object.longitude);
}

ListeningBehaviourModel _listeningBehaviourModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ListeningBehaviourModel(
    reader.readStringList(offsets[1]) ?? [],
    reader.readStringList(offsets[3]) ?? [],
    reader.readDouble(offsets[4]),
    reader.readDouble(offsets[5]),
    reader.readString(offsets[0]),
    reader.readLong(offsets[2]),
  );
  object.id = id;
  return object;
}

P _listeningBehaviourModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _listeningBehaviourModelGetId(ListeningBehaviourModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _listeningBehaviourModelGetLinks(
    ListeningBehaviourModel object) {
  return [];
}

void _listeningBehaviourModelAttach(
    IsarCollection<dynamic> col, Id id, ListeningBehaviourModel object) {
  object.id = id;
}

extension ListeningBehaviourModelQueryWhereSort
    on QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QWhere> {
  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ListeningBehaviourModelQueryWhere on QueryBuilder<
    ListeningBehaviourModel, ListeningBehaviourModel, QWhereClause> {
  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ListeningBehaviourModelQueryFilter on QueryBuilder<
    ListeningBehaviourModel, ListeningBehaviourModel, QFilterCondition> {
  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
          QAfterFilterCondition>
      activityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
          QAfterFilterCondition>
      activityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activity',
        value: '',
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> activityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activity',
        value: '',
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artists',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artists',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artists',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artists',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artists',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artists',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
          QAfterFilterCondition>
      artistsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artists',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
          QAfterFilterCondition>
      artistsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artists',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artists',
        value: '',
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artists',
        value: '',
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artists',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artists',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artists',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artists',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artists',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> artistsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'artists',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> dateTimeInMisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTimeInMis',
        value: value,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> dateTimeInMisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTimeInMis',
        value: value,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> dateTimeInMisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTimeInMis',
        value: value,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> dateTimeInMisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTimeInMis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genres',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
          QAfterFilterCondition>
      genresElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
          QAfterFilterCondition>
      genresElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genres',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> genresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel,
      QAfterFilterCondition> longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ListeningBehaviourModelQueryObject on QueryBuilder<
    ListeningBehaviourModel, ListeningBehaviourModel, QFilterCondition> {}

extension ListeningBehaviourModelQueryLinks on QueryBuilder<
    ListeningBehaviourModel, ListeningBehaviourModel, QFilterCondition> {}

extension ListeningBehaviourModelQuerySortBy
    on QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QSortBy> {
  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.desc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByDateTimeInMis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTimeInMis', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByDateTimeInMisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTimeInMis', Sort.desc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }
}

extension ListeningBehaviourModelQuerySortThenBy on QueryBuilder<
    ListeningBehaviourModel, ListeningBehaviourModel, QSortThenBy> {
  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.desc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByDateTimeInMis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTimeInMis', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByDateTimeInMisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTimeInMis', Sort.desc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }
}

extension ListeningBehaviourModelQueryWhereDistinct on QueryBuilder<
    ListeningBehaviourModel, ListeningBehaviourModel, QDistinct> {
  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QDistinct>
      distinctByActivity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QDistinct>
      distinctByArtists() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artists');
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QDistinct>
      distinctByDateTimeInMis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTimeInMis');
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QDistinct>
      distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<ListeningBehaviourModel, ListeningBehaviourModel, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }
}

extension ListeningBehaviourModelQueryProperty on QueryBuilder<
    ListeningBehaviourModel, ListeningBehaviourModel, QQueryProperty> {
  QueryBuilder<ListeningBehaviourModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ListeningBehaviourModel, String, QQueryOperations>
      activityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activity');
    });
  }

  QueryBuilder<ListeningBehaviourModel, List<String>, QQueryOperations>
      artistsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artists');
    });
  }

  QueryBuilder<ListeningBehaviourModel, int, QQueryOperations>
      dateTimeInMisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTimeInMis');
    });
  }

  QueryBuilder<ListeningBehaviourModel, List<String>, QQueryOperations>
      genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<ListeningBehaviourModel, double, QQueryOperations>
      latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<ListeningBehaviourModel, double, QQueryOperations>
      longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }
}
