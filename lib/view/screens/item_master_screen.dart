import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/view/screens/item_delete_screen.dart';
import 'package:untitled1/view/screens/item_add_screen.dart';

import '../../generated/l10n.dart';
import '../../main.dart';
import '../parts/item_grid_part.dart';
import '../../vm/viewmodel.dart';

//READの場合の右上のPopupMenuから削除する場合の選択肢
enum DeleteType { Select, All }

//このコードは、ItemEditPageという名前の画面を作成し、
// その画面が表示される前に広告を表示するための準備をしていることがわかります。

class ItemMasterScreen extends StatefulWidget {
  @override
  State<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends State<ItemMasterScreen> {
  @override
  void initState() {
    super.initState();
    adManager.initBannerAd();
    adManager.loadBannerAd();
  }

  @override
  void dispose() {
    adManager.disposeBannerAd();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();
    viewModel.getAllItem();
    return Consumer<ViewModel>(builder: (BuildContext context, vm, child) {
      return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: TextButton(
            child: Text(
              //新規もちもの追加
              S.of(context)!.addNewItem,
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () => _itemPlus(),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          leading: IconButton(
              color: Colors.white70,
              onPressed: () => _goBackPage(context),
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
          title: Text(
            //全体のもちもの
            S.of(context)!.itemList,
            style: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
          elevation: 2,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PopupMenuButton<DeleteType>(
                child: Icon(
                  Icons.delete,
                  color: Colors.white70,
                ),
                onSelected: (DeleteType selectedClear) async {
                  if (selectedClear == DeleteType.Select) {
                    startItemDeleteScreen(context);
                  } else {
                    deleteAllItem();
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<DeleteType>>[
                  PopupMenuItem<DeleteType>(
                    value: DeleteType.Select,
                    //選択消去
                    child: Text(S.of(context)!.deleteSelected),
                  ),
                  PopupMenuItem<DeleteType>(
                    value: DeleteType.All,
                    //全消去
                    child: Text(S.of(context)!.deleteAll),
                  ),
                ],
              ),
            )
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
                  displayMode: ItemGridDisplayMode.MASTER,
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

  //このコードは、現在の画面からItemDeleteScreenという名前の新しい画面に移動する、ということを行っています。
  // 新しい画面では、おそらくアイテムを削除するための操作ができる画面が表示されるでしょう。

  startItemDeleteScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ItemDeleteScreen()),
    );
  }

  //このコードは、スマホアプリで**「全てのアイテムを削除しますか？」**と確認する画面を表示し、
  // ユーザーが「はい」と答えると、登録されている全てのアイテムを削除する機能です。
  // 例えば、買い物リストアプリで「全ての商品を削除」するような場合に使われます。

  deleteAllItem() {
    final viewModel = context.read<ViewModel>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(S.of(context)!.deleteAll),
        content: Text(
          //登録している持ち物を全部消しますか？
          S.of(context)!.deleteSentence2,
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightBlue,
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
              await viewModel.deleteAllItem();
              await viewModel.getAllItem();
              Fluttertoast.showToast(
                //全消去しました
                msg: S.of(context)!.deleteSentence5,
                toastLength: Toast.LENGTH_LONG,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _itemPlus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemAddScreen(),
      ),
    );
  }

  _goBackPage(BuildContext context) {
    Navigator.pop(context);
  }
}
