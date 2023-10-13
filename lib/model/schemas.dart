import 'package:realm/realm.dart';

part 'schemas.g.dart';

@RealmModel()
class _LovedApp {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  late String raw;

  late String country;

  late String image;

  late DateTime createdAt;

  late DateTime updatedAt;

  late List<_Tag> tags;
}

@RealmModel()
class _Tag {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  late String background;

  late DateTime createdAt;

  late DateTime updatedAt;
}
