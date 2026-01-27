import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../parts/item_grid_part.dart';
import '../../main.dart';
import '../../vm/viewmodel.dart';

class ItemDeleteScreen extends StatefulWidget {
  @override
  State<ItemDeleteScreen> createState() => _ItemDeleteScreenState();
}

class _ItemDeleteScreenState extends State<ItemDeleteScreen> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<ViewModel>();
    ///最初はチェック無し
    vm.clearSelectedItem();

    adManager.initBannerAd();
    adManager.loadBannerAd();
  }

  @override
  void dispose() {
    adManager.disposeBannerAd();
    super.dispose();
  }

  //このコードは、選択してアイテムを削除するための画面を作成しています。
  // 前の画面で取得したアイテムの一覧を表示し、ユーザーが削除したいアイテムを選択して、
  // 「完了」ボタンを押すと、選択したアイテムが削除される仕組みになっています。

  @override
  Widget build(BuildContext context) {
    /*
    * ItemEditPageとItemDeleteScreenで同じViewModelを使っているので
    * ItemEditPageを開いた際に取得したViewModel#itemListは有効
    * */
    // final viewModel = context.read<ViewModel>();
    // viewModel.getAllItemsNormal();

    return Consumer<ViewModel>(builder: (BuildContext context, vm, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                "☓",
                style: TextStyle(color: Colors.white70, fontSize: 25),
              )),
          title: Text(
            //選択消去
            S.of(context)!.deleteSelected,
            style: TextStyle(color: Colors.white70),
          ),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () async {
                  deleteItem();
                },
                //完了
                child: Text(S.of(context)!.done, style: TextStyle(color: Colors.white70, fontSize: 20.0),))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: ItemGridPart(
                  displayMode: ItemGridDisplayMode.DELETE,
                ),
              ),
            ),
            Container(
              width: adManager.bannerAd.size.width.toDouble(),
              height: adManager.bannerAd.size.height.toDouble(),
              child: AdWidget(
                ad: adManager.bannerAd,
              ),
            ),
          ],
        ),
      );
    });
  }

  //このコードは、ユーザーに確認をしてから、選択したアイテムを削除する機能を実現しています。

  deleteItem() {
    final viewModel = context.read<ViewModel>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //選択した持ち物を消去しますか？
        title: Text(S.of(context)!.deleteSentence1),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(S.of(context)!.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
            ),
            child: Text(S.of(context)!.ok),
            onPressed: () async {
              await viewModel.deleteSelectedItem();
              // await viewModel.deleteItem();
              // await viewModel.getAllItem();
              Navigator.pop(context);
              Navigator.pop(context);
              Fluttertoast.showToast(
                //選択消去しました
                msg: S.of(context)!.deleteSentence6,
                toastLength: Toast.LENGTH_LONG,
              );
            },
          ),
        ],
      ),
    );
  }
}
