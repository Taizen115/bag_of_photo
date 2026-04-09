import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/view/parts/item_grid_part.dart';
import 'package:untitled1/view/screens/bag_detail_screen.dart';
import 'package:untitled1/view/screens/bag_master_screen.dart';
import 'package:untitled1/view/screens/item_select_screen.dart';

import '../../generated/l10n.dart';
import '../../vm/viewmodel.dart';
import 'dialog_confirm.dart';

//リセットする範囲を指定するためのシンプルな仕組みです.

enum Reset { Clear, All }

//State: アプリの画面の状態を管理するクラス
//initState(): Stateが作成されたときに最初に呼び出されるメソッド

class BagDetailPart extends StatefulWidget {
  final BagDetailOpenMode openMode;
  final int? bagId;
  final bag;

  BagDetailPart({required this.openMode, this.bagId, this.bag});

  @override
  State<BagDetailPart> createState() => _BagDetailPartState();
}

class _BagDetailPartState extends State<BagDetailPart> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.openMode == BagDetailOpenMode.NEW) {
      _createBag();
    } else {
      if (widget.bagId != null) _getSelectedBag(widget.bagId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
          * TODo Appbarのタイトルが画面の中央からズレちゃってますので、中央寄せはcenterTitle: trueで行って下さい（他の箇所も同様）
          * */
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: Padding(
            padding: const EdgeInsets.all(1.5),
            child: SizedBox(
              height: 30,
              width: 90,
              child: TextButton(
                onPressed: () => _goBagMasterScreen(context),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(20.0), // 角を丸く
                  ),
                ),
                child: Text(
                  S.of(context).register,
                  style: const TextStyle(fontSize: 10.0),
                ),
              ),
            ),
          ),
          centerTitle: true,
          title: TextField(
            onChanged: (bagName) => _updateBagName(bagName),
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2.0),
              //バッグの名前を入力してください
              hintText: S.of(context).bagNameInput,
              hintStyle: const TextStyle(
                color: Colors.white70,
              ),
              prefixIcon: Icon(Icons.edit, color: Colors.white70),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            style: TextStyle(color: Colors.white70),
          ),
        ),

        //ElevatedButton: 「持ち物選択」ボタンを押すと、持ち物を選ぶ画面に移動します。
        // ItemGridPart: 持ち物の一覧を表示する部品です。vm.itemExcludedPreparedList や
        // vm.itemIncludedPreparedList は、ViewModelから取得した、準備していない持ち物と準備済みの持ち物のリストです。

        //このコードの目的は、「持っていくものをリスト化して管理する」 という機能を作ることです。
        // 例えば、旅行に行くときに、何を持っていくか忘れずにチェックしたい場合などに役立ちます。

        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
            Row(
              children: [
                Gap(30),
                Expanded(
                  child: Text(
                    //まだ用意していないもちもの
                    S.of(context).unpreparedItem,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),

                    ///注意喚起のボタン
                    onPressed: () {
                      showConfirmDialog(
                        context: context,
                        title: S.of(context).warming,
                        content: S.of(context).warmingSentence,
                        okLabel: S.of(context).ok,
                        cancelLabel: S.of(context).cancel,
                        okStyle: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary,),
                        cancelStyle: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onOk: () {
                          _goItemSelectScreen(context);
                        },
                      );
                    },
                    child: Text(
                      //選択
                      S.of(context).selection,
                      style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.primary,),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary,),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: ItemGridPart(
                  displayMode: ItemGridDisplayMode.UNPREPARED,
                ),
              ),
            ),
            Row(
              children: [
                Gap(30),
                Expanded(
                  child: Text(
                    //用意済みのもちもの
                    S.of(context).preparedItem,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      final viewModel = context.read<ViewModel>();
                      showConfirmDialog(
                        context: context,
                        title: S.of(context).resetSentence1,
                        content: S.of(context).resetSentence2,
                        okLabel: S.of(context).ok,
                        cancelLabel: S.of(context).cancel,
                        onOk: () async {
                          await viewModel.resetItem();
                          Fluttertoast.showToast(
                            msg: S.of(context).resetSentence3,
                            toastLength: Toast.LENGTH_LONG,
                          );
                        },
                      );
                    },
                    child: Text(
                      S.of(context).reset,
                      style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.primary,),
                    ),
                  ),
                ),
              ],
            ),
            //用意済みの持ち物
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary,),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: ItemGridPart(
                  displayMode: ItemGridDisplayMode.PREPARED,
                ),
              ),
            ),
          ],
        ));
  }

  void _createBag() {
    /*
    * BagDetailScreen起動時にバッグのレコードをDBに作成
    * */
    final viewModel = context.read<ViewModel>();
    viewModel.createBag();
  }

  void _getSelectedBag(int bagId) async {
    //TODO　バッグの画面表示がされるようにする
    final viewModel = context.read<ViewModel>();
    await viewModel.getSelectedBag(bagId);
    _searchController.text = viewModel.currentBag!.name;
  }

  _goItemSelectScreen(BuildContext context) {
    /*
    * ItemSelectScreenに移動する段階で用意済みの持ち物は一旦まだ用意していない持ち物にクリア
    *  （preparedItems => unPreparedItemsにして用意を仕切り直し）
    * */
    final vm = context.read<ViewModel>();
    vm.resetPreparation();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemSelectScreen(),
      ),
    );
  }

  _updateBagName(String bagName) {
    final vm = context.read<ViewModel>();
    vm.updateBagName(bagName);
  }

  void _goBagMasterScreen(BuildContext context) {
    final vm = context.read<ViewModel>();
    final bag = vm.currentBag;

    //1.バッグ名・もちものの有無を判定
    final hasName = (bag?.name ?? '').trim().isNotEmpty;
    // ここはアプリの仕様に合わせて：
    // ・itemIds 文字列を使う
    // ・prepared + unprepared のリスト長を見る
    // などに変えてOKです
    final hasItems = (bag?.itemIds ?? '').isNotEmpty;

    //2.両方そろっている場合 → ダイアログを出さずにそのまま戻る
    if (hasName && hasItems) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BagMasterScreen(bag: widget.bag),
        ),
      );
      return;
    }

    // ③ どちらか足りない場合だけダイアログ表示
    final isNew = widget.openMode == BagDetailOpenMode.NEW;

    // メッセージ本文（新規 / 編集で出し分け）
    final String? message =
        isNew ? S.of(context).checkSentence1 : S.of(context).checkSentence2;
    // ボタンラベル（新規 / 編集で出し分け）
    final String? continueLabel =
        isNew ? S.of(context).checkSentence3 : S.of(context).checkSentence4;

    showConfirmDialog(
      context: context,
      title : message ?? '',
      okLabel: S.of(context).checkSentence5,
      // → BagMaster に戻る
      cancelLabel: continueLabel ?? '',
      // → この画面に留まる
      okStyle: TextButton.styleFrom(
        backgroundColor: Colors.white70,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      cancelStyle: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onOk: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BagMasterScreen(bag: widget.bag),
          ),
        );
      },
    );
  }
}
