import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../db/database.dart';
import '../../vm/viewmodel.dart';
import '../screens/item_edit_screen.dart';
import 'item_grid_part.dart';

class ItemCard extends StatefulWidget {
  final ItemGridDisplayMode displayMode;
  final Item item;

  const ItemCard({
    required this.item,
    required this.displayMode,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ViewModel>();

    ///追加
    //SELECT画面のチェック状態は「バッグに入っているかどうか」で決める
    if (widget.displayMode == ItemGridDisplayMode.SELECT) {
      final itemIdsStr = vm.currentBag?.itemIds ?? '';
      final ids = itemIdsStr
          .split(',')
          .where((e) => e.isNotEmpty)
          .toList();
      isCheck = ids.contains(widget.item.itemId.toString());
    } else {
      // それ以外の画面（UNPREPARED / PREPARED など）は従来どおり
      isCheck = vm.unpreparedItems.contains(widget.item);
    }
  }
    // isCheck = vm.unpreparedItems.contains(widget.item);

  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();
    final baseFontSize = titleFontSize(context);

    final bool pinned = viewModel.isPinned(widget.item);
    final isPinnedVisible =
        viewModel.preparedItems.contains(widget.item) &&
            widget.displayMode == ItemGridDisplayMode.PREPARED;


    return Card(
      child: Stack(children: [
        ListTile(
          title: AutoSizeText(
            "${widget.item.itemName}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: baseFontSize),
            maxLines: 1,
            minFontSize: baseFontSize - 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: LayoutBuilder(
            builder: (context, constraints) {
              ///カード内で使える幅
              final maxWidth = constraints.maxWidth;

              ///その85%を画像サイズにする
              final imageSize = maxWidth * 0.85;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20.0),
                    // 0なら完全な四角、8なら少し角丸
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.item.itemImagePath == ''
                          ? AssetImage("assets/images/gray.png")
                              as ImageProvider
                          : FileImage(File(widget.item.itemImagePath)),
                    ),
                  ),
                ),
              );
            },
          ),
          onTap: () => _tapListTile(context),
        ),
        //TODO: 削除の場合はまた今度
        (widget.displayMode == ItemGridDisplayMode.DELETE)
            ? Positioned(
                top: 0.0,
                right: 0.0,
                child: Checkbox(
                  ///追加
                  value: context
                      .watch<ViewModel>()
                      .selectedItems
                      .contains(widget.item),
                  // value: isCheck,
                  onChanged: (value) {
                    ///追加
                    final vm = context.read<ViewModel>();
                    if (value == true) {
                      vm.addSelectedItem(widget.item);
                    } else {
                      vm.removeSelectedItem(widget.item);
                    }
                  },
                ),
              )
            //SELECTの場合のチェックボックス
            : (widget.displayMode == ItemGridDisplayMode.SELECT)

        ///追加
            ? Positioned(
          top: 0.0,
          right: 0.0,
          child: Builder(
            builder: (context) {
              final vm = context.watch<ViewModel>();
              widget.displayMode == ItemGridDisplayMode.PREPARED && vm.isPinned(widget.item);
              final pinned = vm.isPinned(widget.item);

              return Checkbox(
                //ピン付きなら常に true を表示
                value: pinned ? true : isCheck,
                //ピン付きはチェックを外せないようにする
                onChanged: pinned
                    ? null  // 無効（タップできない）
                    : (value) {
                  setState(() {
                    isCheck = value!;
                    vm.updateSelectItem(
                      selectedItem: widget.item,
                      isSelect: isCheck,
                    );
                  });
                },
              );
            },
          ),
        ): Container(),

                // ? Positioned(
                //     top: 0.0,
                //     right: 0.0,
                //     child: Checkbox(
                //       value: isCheck,
                //       onChanged: (value) {
                //         setState(() {
                //           isCheck = value!;
                //           viewModel.updateSelectItem(
                //             selectedItem: widget.item,
                //             isSelect: isCheck,
                //           );
                //         });
                //       },
                //     ),
                //   )
                // : Container(),
        if (isPinnedVisible)
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              padding: const EdgeInsets.all(2),
              iconSize: 15,
              icon: Icon(
                pinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: pinned ? Theme.of(context).colorScheme.primary : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  viewModel.togglePin(widget.item);
                });
              },
            ),
          ),
      ],
      ),
    );
  }

  //この関数は、「item」という情報を持った新しい画面「ItemEditScreen」に移動する という命令です。

  editSelectedItem(BuildContext context, Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditScreen(item: item),
      ),
    );
  }

  double titleFontSize(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    if (shortestSide < 550) {
      // スマホ
      return 10.0;
    } else if (shortestSide < 800) {
      // 小さめタブレット
      return 15.0;
    } else {
      // 大きめタブレット（Pixel Tablet など）
      return 20.0;
    }
  }


  //このコードは、リストの項目をタップしたときの処理を、まるで分岐点のようなもので分けていると考えてください。
  // どの道を行くか（どの処理をするか）は、タップされた項目の種類によって決まります。

  //TODO　課題 用意済みのものと用意前のもので移動する

  void _tapListTile(BuildContext context) {
    final vm = context.read<ViewModel>();

    if (widget.displayMode == ItemGridDisplayMode.SELECT ||
        widget.displayMode == ItemGridDisplayMode.MASTER) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemEditScreen(item: widget.item),
        ),
      );
      return;
    }
    if (widget.displayMode == ItemGridDisplayMode.UNPREPARED ||
        widget.displayMode == ItemGridDisplayMode.PREPARED) {
      if(vm.isPinned(widget.item)) {
        return;
      }
      vm.toggleItemPrepared(widget.item);
    }
  }
}
