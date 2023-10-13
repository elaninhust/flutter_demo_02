import 'dart:io';
import 'package:flutter_demo_02/model/schemas.dart';
import 'package:realm/realm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DB {
  /// Realm 数据库单例模式
  static late Realm db;

  static late LocalConfiguration _config;

  /// 数据库存放路径
  static late String path;

  /// 数据库存放文件夹
  static const String name = 'LovingAppDB';

  /// 初始化 db
  static Future<void> initDB() async {
    await getDBPath();
    _config = Configuration.local([
      LovedApp.schema,
      Tag.schema,
    ], path: path);

    db = Realm(_config);
  }

  static Future<String> getDBPath() async {
    Directory appDocumentsPath = await getApplicationDocumentsDirectory();
    path = join(appDocumentsPath.path, 'realm', name);
    return path;
  }

  /// 增
  static T add<T extends RealmObject>(T data) => db.write(
        () => db.add<T>(data),
      );

  /// 删
  ///
  /// 在 iOS 上使用 writeAsync 会直接闪退
  static void delete(RealmObject data) => db.write(
        () => db.delete(data),
      );

  /// 改
  static update() {}

  /// 查
  static List<T> queryAll<T extends RealmObject>() {
    return db.all<T>().toList();
  }

  /// 清空
  static void clear<T extends RealmObject>() => db.write(
        () => db.deleteAll<T>(),
      );
}
