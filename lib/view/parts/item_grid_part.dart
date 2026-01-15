import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/vm/viewmodel.dart';
import '../../db/database.dart';
import '../../generated/l10n.dart';
import 'item_card.dart';

/*
* TODO[20250206]enumで状況に分けてパーツの表示を分ける
*   （BagDetailScreen）
*   ・PREPARED：用意済みのもちもの（チェック無し・かばん特定）
*   ・UNPREPARED：まだ用意していないもちもの（チェック無し・かばん特定）
*   （ItemSelectScreen）
*   ・SELECT：バッグの作成画面からもちものを選択する場合（チェック有り）
*   （ItemMasterScreen）
*   ・MASTER：バッグ一覧画面から「もちもの」を選択した場合（チェック無し）
*   （ItemDeleteScreen)con
*   ・DELETE：もちもの一覧画面から「選択消去」して削除するもちものを選択する場合（チェック有り）
*   => TODO 竹割さんがItemGridOpenModeを作ってくれているようで、まだ必要かわからん
* */
enum ItemGridDisplayMode {
  SELECT,
  MASTER,
  DELETE,
  PREPARED,
  UNPREPARED,
}

class ItemGridPart extends StatelessWidget {
  final ItemGridDisplayMode displayMode;

  const ItemGridPart({required this.displayMode});

  //アイテムがあるか確認: まず、表示するアイテムがあるかどうかを確認します。
  // アイテムがある場合:
  // スクロールバー付きのグリッド: アイテムを格子状に並べて表示し、スクロールバーをつけて、たくさんのアイテムでも見やすくします。
  // それぞれのアイテム: ItemCard という部品を使って、一つ一つのアイテムを表示します。
  // アイテムがない場合:
  // 空の画面: 「もちものはありません。」という文字を表示して、何も表示するものが無いことを知らせます。

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ViewModel>();
    List<Item> items;
    // final items = (displayMode == ItemGridDisplayMode.UNPREPARED)
    //     ? vm.unpreparedItems
    //     : (displayMode == ItemGridDisplayMode.PREPARED)
    //         ? vm.preparedItems
    //         : vm.allItems;
    switch (displayMode) {
      case ItemGridDisplayMode.UNPREPARED:
        items = vm.unpreparedItems;
        break;

      case ItemGridDisplayMode.PREPARED:
        items = vm.preparedItems;
        break;

      case ItemGridDisplayMode.SELECT:
        items = vm.allItems;
        break;

      case ItemGridDisplayMode.MASTER:
        items = vm.allItems;
        break;

      case ItemGridDisplayMode.DELETE:
        items = vm.allItems;
        break;
    }


    return (items.isNotEmpty)
        ? Scrollbar(
            thickness: 8,
            //hoverThickness: 16,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: List.generate(
                items.length,
                ((index) {
                  return ItemCard(
                    item: items[index],
                    displayMode: displayMode,
                  );
                }),
              ),
            ),
          )
        : Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      //もちものはありません。
                      S.of(context)!.noItem,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  //このコードは、スマホアプリの画面で、アイテムを格子状に並べる時に、
  // 横方向に並べるアイテムの数を決めるための計算をしています。
  //1. スマホの向きを確認: スマホが縦向きか横向きかを確認します。
  //2. 表示モードを確認: アイテムの表示モード（チェックモードなど）を確認します。
  //3. アイテムの数を決める: スマホの向きと表示モードによって、横方向に並べるアイテムの数を決めます。

  crossAxisCount(BuildContext context) {
    if (displayMode == ItemGridDisplayMode.PREPARED ||
        displayMode == ItemGridDisplayMode.UNPREPARED) {
      return 4;
    } else {
      return 4;
    }
  }
}
