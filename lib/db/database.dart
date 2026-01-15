import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:untitled1/main.dart';

part 'database.g.dart';

//このクラスは、スマホアプリで扱うアイテムの基本的な情報を定義するものです。
// このクラスを土台にして、様々な種類のアイテムを管理することができます。

class Items extends Table {
  IntColumn get itemId => integer().autoIncrement()();

  TextColumn get itemName => text()();

  TextColumn get itemImagePath => text()();

  /*
  * TODO[20241212]Bagテーブル追加に伴い以下の3項目は不要
  *  => alterTableでColumnの削除はできるけど、ちょっとややこしくなりそうので
  *     Nullableになってるから既存のデータは放っておいて、新規のデータはNullでいれる扱いにするか
  * */
  BoolColumn get isPrepared => boolean().nullable()();

  BoolColumn get isSelected => boolean().nullable()();

  BoolColumn get isChecked => boolean().nullable()();
}

//TODO[20241212]Bagテーブルの追加
class Bags extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  //バッグにいれるもちもの（Item）のitemIdをカンマ区切りしたもの（DriftはListが保存できないので）
  //ex. 3,5 => "3, 5"
  TextColumn get itemIds => text()();
}

//このコードは、スマホアプリのデータを安全に保存するためのデータベースを作るための最初のステップです。
// このデータベースを使って、アプリで使う様々なデータを管理することができます。

@DriftDatabase(tables: [Items, Bags])
class MyDatabase extends _$MyDatabase {
  var bagDao;

  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  //TODO[20241212]Bagテーブル追加に伴う統合処理
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
    }, onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(bags);
      }
    });
  }

  //------------------
  //TODO[持ち物関連]
  //持ち物の登録Create

  Future<int> addItem(ItemsCompanion item) {
    return into(items).insert(item);
  }

  //持ち物の読み込み
  Future<List<Item>> get allItems => select(items).get();

  //持ち物の更新
  Future updateItem(Item item) => update(items).replace(item);

  //delete
  Future deleteItem(Item item) =>
      (delete(items)..where((table) => table.itemId.equals(item.itemId))).go();

  Future deleteAllItems() {
    return delete(items).go();
  }

  //------------------
  //TODO[バッグ関連]

  //TODO 実験的に入力 1.14
  //カバンを作る

  //create
  Future<int> createBag(BagsCompanion bag) => into(bags).insert(bag);

  //Read
  Future<List<Bag>> get allBags => select(bags).get();

  //Read（特定のidのBag）
  Future<Bag> getBagById(int selectedId) =>
      (select(bags)..where((t) => t.id.equals(selectedId))).getSingle();

  //Update
  Future updateBag(Bag bag) => update(bags).replace(bag);

  //Delete
  Future deleteBag(Bag bag) =>
      (delete(bags)..where((t) => t.id.equals(bag.id))).go();

  Future<List<Bag>> getBagData() async {
    final bags = await allBags;
    var validBags = <Bag>[];
    bags.forEach((bag) {
      if (bag.name != "" &&
          bag.name.isNotEmpty &&
          bag.itemIds != "" &&
          bag.itemIds.isNotEmpty) {
        validBags.add(bag);
      }
    });
    return validBags;
  }

  Future<List<Item>> getUnpreparedItems(String strItemIds) async {
    final items = await allItems;
    final itemIds = strItemIds.split(",");
    var unpreparedItems = <Item>[];
    items.forEach((item) {
      final itemId = item.itemId.toString();
      if (itemIds.contains(itemId)) {
        unpreparedItems.add(item);
      }
    });
    return unpreparedItems;
  }

  //Delete All
  Future<void> deleteAllBag() async {
    final db = await database;
    await db.delete(db.bags).go();
    //await db.delete('bags');
  }
}

//LazyDatabase: データベースへの接続を遅延させるためのクラスです。
// getApplicationDocumentsDirectory(): アプリのデータを保存するフォルダの場所を取得します。
// NativeDatabase: データベースに接続するためのクラスです。

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.db'));
    return NativeDatabase(file);
  });
}
