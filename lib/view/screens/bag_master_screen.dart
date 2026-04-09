import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/view/parts/bag_grid_part.dart';
import 'package:untitled1/view/screens/bag_delete_screen.dart';
import 'package:untitled1/view/screens/bag_detail_screen.dart';
import 'package:untitled1/view/screens/item_master_screen.dart';
import 'package:untitled1/view/screens/theme_setting_screen.dart';
import 'package:untitled1/vm/viewmodel.dart';

import '../../generated/l10n.dart';
import '../../main.dart';

class BagMasterScreen extends StatefulWidget {
  final bag;

  BagMasterScreen({required this.bag});

  @override
  State<BagMasterScreen> createState() => _BagMasterScreenState();
}

class _BagMasterScreenState extends State<BagMasterScreen> {
  bool isCheck = false;
  var validBag;

  @override
  void initState() {
    super.initState();
    adManager.initBannerAd();
    adManager.loadBannerAd();
    _getBagData();
  }

  @override
  void dispose() {
    adManager.disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white70,
        leadingWidth: 100,
        title: Text(
          //バッグ一覧
          S.of(context).bagList,
          style: TextStyle(fontSize: 20.0, color: Colors.white70),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,

        //ゴミ箱アイコンを作る

        actions: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.white70,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ThemeSettingScreen(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<DeleteType>(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white70,
                  ),
                  onSelected: (DeleteType selectedClear) async {
                    if (selectedClear == DeleteType.Select) {
                      startBagDeletePart(context);
                    } else {
                      deleteAllBag();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<DeleteType>>[
                    PopupMenuItem<DeleteType>(
                      value: DeleteType.Select,
                      //選択消去
                      child: Text(S.of(context).deleteSelected),
                    ),
                    PopupMenuItem<DeleteType>(
                      value: DeleteType.All,
                      //全消去
                      child: Text(S.of(context).deleteAll),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              side: BorderSide(color: Colors.transparent),
            ),
            onPressed: () => _goItemMasterScreen(),
            child: Text(
              //もちもの
              S.of(context).item,
              style: TextStyle(fontSize: 15.0, color: Colors.white70),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BagGridPart(
              displayCondition: BagGridDisplayMode.NORMAL,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 10.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _goBagDetailScreen(openMode: BagDetailOpenMode.NEW);
                },
                child: Text(
                  //バッグ作成
                  S.of(context).makeBag,
                  style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
          //TODO　バッグ一覧
          // Container(
          //   width: adManager.bannerAd.size.width.toDouble(),
          //   height: adManager.bannerAd.size.height.toDouble(),
          //   child: AdWidget(
          //     ad: adManager.bannerAd,
          //   ),
          // ),
          Gap(kToolbarHeight + 2.0),
        ],
      ),
    );
  }

  deleteAllBag() {
    final viewModel = context.read<ViewModel>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //全消去
        title: Text(S.of(context).deleteAll),
        content: Text(
          //バッグを全消去しますか？
          S.of(context).deleteSentence4,
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white70,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(S.of(context).ok),
            onPressed: () async {
              await viewModel.deleteAllBag();
              // await viewModel.getAllItem();
              Fluttertoast.showToast(
                //バッグを全部消去しました
                msg: S.of(context).deleteSentence5,
                toastLength: Toast.LENGTH_LONG,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _goBagDetailScreen({required BagDetailOpenMode openMode, int? bagId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BagDetailScreen(openMode: openMode, bagId: bagId),
      ),
    );
  }

  _goItemMasterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemMasterScreen(),
      ),
    );
  }

  void _getBagData() {
    final vm = context.read<ViewModel>();
    vm.getBagData();
  }

  //TODO
  void startBagDeletePart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BagDeleteScreen(
          validBag: validBag,
        ),
      ),
    );
  }
}
