import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../db/database.dart';
import '../main.dart';

class ViewModel extends ChangeNotifier {
  final MyDatabase db;

  ViewModel({required this.db});

  //有効なBag(名前もアイテムも入ってるもののみ)
  List<Bag> validBags = [];

  //選択されたバッグを保存
  List<Bag> selectedBags = [];

  //もちもの全部（どのバッグに属しているかにかかわらず）
  List<Item> allItems = [];

  //選択状態を管理
  final Set<Item> selectedItems = {};

  //まだ用意していないもちもの（特定のバッグ）
  List<Item> unpreparedItems = [];

  //用意済みのもちもの（特定のバッグ）
  List<Item> preparedItems = [];

  File? imageFile;

  //今HomeScreen（Bag登録画面）で扱っているBagのid
  Bag? currentBag;

  List<Bag> allBags = [];

  final Set<int> pinnedItemIds = {};

  bool isPinned(Item item) => pinnedItemIds.contains(item.itemId);

  List<Item> get pinnedItemsInCurrentBag => preparedItems;

  Future<void> pickImage(ImageSource source) async {
    imageFile = null;
    notifyListeners();

    final imagePicker = ImagePicker();
    final XFile? _image = await imagePicker.pickImage(
      source: source,
      imageQuality: 15,
    );
    if (_image == null) {
      return;
    }

    imageFile = File(_image.path);

    final appDirectory = await getApplicationDocumentsDirectory();
    final String inAppPath = appDirectory.path;
    final itemImageName = basename(_image.path);
    final File _savedImage = await imageFile!.copy('$inAppPath/$itemImageName');

    imageFile = _savedImage;

    notifyListeners();
  }

  Future<void> updateSelectItem(
      {required Item selectedItem, required bool isSelect}) async {
    /*
  * ItemSelectScreenからカバンにいれるもちものの選択・非選択行為
  * => 1. vm.currentBagIdで現在扱っているカバンのIDがわかっている
  * => 2. そのカバン（bags）のレコードのitemIdsを更新
  * => 3. vm.unpreparedItems も更新要
  * */
    if (currentBag == null) return;

    ///追加
    if (!isSelect && isPinned(selectedItem)) {
      return;
    }
    final strItemIdsUpdated = _updateItemIds(selectedItem.itemId, isSelect);
    //白板⑤
    currentBag = currentBag!.copyWith(itemIds: strItemIdsUpdated);
    await database.updateBag(currentBag!);
    //3. vm.unpreparedItemsも更新要
    ///すべての Item を取得
    allItems = await database.allItems;

    ///currentBag に入っている itemId をセットにする
    final idStrings =
        currentBag!.itemIds.split(',').where((e) => e.isNotEmpty).toList();
    final idsInBag = idStrings.map(int.parse).toSet();

    ///バッグに入っている Item 達
    final bagItems =
        allItems.where((item) => idsInBag.contains(item.itemId)).toList();

    ///ピン付きは prepared、その他は unprepared に振り分ける
    preparedItems = bagItems.where((item) => isPinned(item)).toList();
    unpreparedItems = bagItems.where((item) => !isPinned(item)).toList();

    // unpreparedItems = await database.getUnpreparedItems(currentBag!.itemIds);
    notifyListeners();
  }

  String _updateItemIds(int selectedItemId, bool isSelected) {
    //白板①"1,3" => ["1", "3"]
    final itemIdsBeforeChanged = currentBag!.itemIds;
    final strItemIds = currentBag!.itemIds.split(",");
    final List<int> itemIds =
        (itemIdsBeforeChanged != "" && strItemIds.isNotEmpty)
            ? strItemIds.map((strItemId) {
                return int.parse(strItemId);
              }).toList()
            : [];
    //白板⓶
    if (isSelected) {
      itemIds.add(selectedItemId);
    } else {
      itemIds.removeWhere((itemId) => itemId == selectedItemId);
    }
    //白板⓷
    itemIds.sort((a, b) => a.compareTo(b));
    //白板⓸
    //final strItemIdsUpdated = itemIds.map((itemId) => itemId.toString()).toList().join(",");
    final strItemIdsUpdated = itemIds
        .toSet()
        .toList()
        .map((itemId) => itemId.toString())
        .toList()
        .join(",");
    return strItemIdsUpdated;
  }

  Future<void> deleteAllItem() async {
    await database.deleteAllItems();
    getAllItem();
    notifyListeners();
  }

  Future<void> getAllItem() async {
    allItems = await database.allItems;
    //TODO
    notifyListeners();
  }

  Future<void> resetItem() async {
    //preparedの中身を unPreparedItems に追加
    unpreparedItems.addAll(preparedItems);

    //preparedItems を空にする
    preparedItems.clear();

    allItems = await database.allItems;
    notifyListeners(); // ← UI更新の通知（必要なら追加）
  }

  Future<void> addItem(String itemName, String itemImagePath) async {
    final item = ItemsCompanion(
      itemName: Value(itemName.toString()),
      itemImagePath: Value(itemImagePath),
      isPrepared: Value(false),
      isSelected: Value(false),
      isChecked: Value(false),
    );
    await database.addItem(item);
    getAllItem();
    notifyListeners();
  }

  ///追加
  void addSelectedItem(Item item) {
    selectedItems.add(item);
    notifyListeners();
  }

  ///追加
  void removeSelectedItem(Item item) {
    selectedItems.remove(item);
    notifyListeners();
  }

  ///追加
  void clearSelectedItem() {
    selectedItems.clear();
    notifyListeners();
  }

  ///追加

  Future<void> deleteSelectedItem() async {
    for (final item in selectedItems) {
      await database.deleteItem(item);
    }
    clearSelectedItem();
    await getAllItem();
  }

  Future<void> updateEditItem(
      item, String itemName, String itemImagePath) async {
    var updateItem = Item(
        itemId: item.itemId,
        itemName: itemName,
        itemImagePath: itemImagePath,
        isPrepared: false,
        isSelected: false,
        isChecked: false);
    await database.updateItem(updateItem);
    getAllItem();
    notifyListeners();
  }

  Future<void> deleteEditItem(item) async {
    var deleteItem = Item(
        itemId: item.itemId,
        itemName: item.itemName,
        itemImagePath: item.itemImagePath,
        isPrepared: false,
        isSelected: false,
        isChecked: false);
    await database.deleteItem(deleteItem);
    getAllItem();
    notifyListeners();
  }

  Future<void> createBag() async {
    final newBag = BagsCompanion(
      id: Value.absent(),
      name: Value(""),
      itemIds: Value(""),
    );
    final currentBagId = await database.createBag(newBag);
    currentBag = await database.getBagById(currentBagId);

    //TODO[0918]新規にバッグを作成した場合は「まだ用意していな持ち物（unPreparedItems）をクリアする必要あり
    unpreparedItems.clear();
    preparedItems.clear();

    ///追加
    pinnedItemIds.clear();
    notifyListeners();
  }

  Future<void> updateBagName(String bagName) async {
    if (currentBag == null) return;
    currentBag = currentBag!.copyWith(name: bagName);
    database.updateBag(currentBag!);
  }

  Future<void> getBagData() async {
    validBags = await database.getBagData();
    notifyListeners();
  }

  //TODO bagの名前、持ち物を表示する

  Future<void> getSelectedBag(int bagId) async {
    currentBag = await database.getBagById(bagId);

    ///全アイテム取得
    allItems = await database.allItems;

    ///このバッグに入っているitemId
    final idStrings =
        currentBag!.itemIds.split(',').where((e) => e.isNotEmpty).toList();
    final idsInBag = idStrings.map(int.parse).toSet();

    ///バッグに属するItem達
    final bagItems =
        allItems.where((item) => idsInBag.contains(item.itemId)).toList();

    ///ピン付きとそれ以外に振り分け
    preparedItems = bagItems.where((item) => isPinned(item)).toList();
    unpreparedItems = bagItems.where((item) => !isPinned(item)).toList();

    // unpreparedItems = await database.getUnpreparedItems(currentBag!.itemIds);

    notifyListeners();
  }

  Future<void> deleteAllBag() async {
    await database.deleteAllBag();
    validBags.clear();
    notifyListeners();
  }

  //追加
  Future<void> deleteSelectBag() async {
    for (var bag in selectedBags) {
      await database.deleteBag(bag);
      validBags.remove(bag);
    }
    selectedBags.clear();
    notifyListeners();
  }

  Future<void> getAllIBag() async {
    allBags = await database.allBags;
    getAllIBag();
    notifyListeners();
  }

  Future<void> resetPreparation() async {
    ///ItemSelectScreenに移動する段階で、ピン付きのものを用意済みに残す
    ///それ以外の用意済みをまだ用意してないに戻す

    // preparedItems をピン付き / 非ピンで分ける
    final pinnedPrepared = preparedItems
        .where((item) => pinnedItemIds.contains(item.itemId))
        .toList();
    final nonPinnedPrepared = preparedItems
        .where((item) => !pinnedItemIds.contains(item.itemId))
        .toList();

    // 非ピンの用意済みだけ未準備に戻す
    unpreparedItems = [...unpreparedItems, ...nonPinnedPrepared];

    // 用意済みは「ピン付きだけ」残す
    preparedItems = pinnedPrepared;

    notifyListeners();

    // unpreparedItems = [...unpreparedItems, ...preparedItems];
    // preparedItems.clear();
    // pinnedItemIds.clear();
    //
    // notifyListeners();
  }

  ///アイテムを行ったり来たりする
  Future<void> toggleItemPrepared(Item item) async {
    if (unpreparedItems.contains(item)) {
      unpreparedItems.remove(item);
      preparedItems.add(item);
    } else if (preparedItems.contains(item)) {
      preparedItems.remove(item);
      unpreparedItems.add(item);
    }
    notifyListeners();
  }

  //追加
  Future<void> addValidBag(Bag bag) async {
    if (!selectedBags.contains(bag)) {
      selectedBags.add(bag);
      notifyListeners();
    }
  }

  //追加
  Future<void> removeValidBag(Bag bag) async {
    selectedBags.remove(bag);
    notifyListeners();
  }

  //追加
  Future<void> clearSelectBag() async {
    selectedBags.clear();
    notifyListeners();
  }

  Future<void> deleteOneBag(Bag bag) async {
    await database.deleteBag(bag);
    validBags.remove(bag);
    notifyListeners();
  }

  Future<void> togglePin(Item item) async {
    if (isPinned(item)) {
      // ピン解除
      pinnedItemIds.remove(item.itemId);
    } else {
      // ピン付与
      pinnedItemIds.add(item.itemId);

      // もし未準備側にいるなら、用意済みに移動させる（画面上の位置だけ）
      if (unpreparedItems.contains(item)) {
        unpreparedItems.remove(item);
        preparedItems.add(item);
      }
    }
    notifyListeners();
  }
}
