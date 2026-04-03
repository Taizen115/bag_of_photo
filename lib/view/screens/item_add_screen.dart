import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../vm/viewmodel.dart';
import '../parts/button_with_icon.dart';

class ItemAddScreen extends StatefulWidget {

  @override
  State<ItemAddScreen> createState() => _ItemAddScreenState();
}

class _ItemAddScreenState extends State<ItemAddScreen> {
  File? imageFile;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<ViewModel>();
    vm.imageFile = null;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  //TODO 広告は別のScreenで管理（Pageでの管理はやめよう）
  // @override
  // void initState() {
  //   super.initState();
  //   //バナー広告の初期化
  //   //https://developers.google.com/admob/flutter/banner#instantiate_ad
  //   adManager.initBannerAd();
  //   //バナー広告のロード（AdWidget表示前に呼び出し要）
  //   //https://developers.google.com/admob/flutter/banner#load_ad
  //   adManager.loadBannerAd();
  // }
  //
  // @override
  // void dispose() {
  //   //バナー広告の破棄
  //   //https://developers.google.com/admob/flutter/banner#display_ad
  //   adManager.disposeBannerAd();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          leading: TextButton(
            child: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            onPressed: () => _backEditSelectPage(),
          ),
          title: Text(
            //もちもの追加
            S.of(context).itemAdd,
            style: TextStyle(color: Colors.white70),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              //持ち物の画像を表示
              Consumer<ViewModel>(
                builder: (context, vm, child) {
                  final imageFile = vm.imageFile;
                  return Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (imageFile == null)
                            ? AssetImage("assets/images/gray.png")
                            : Image.file(imageFile).image,
                      ),
                      // 0なら完全な四角、8なら少し角丸
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () => _pickImageItem(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70),
                //画像選択
                child: Text(S.of(context).selectImage,)),

              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLength: 10,
                    style: TextStyle(fontSize: 22.0),
                    controller: _textEditingController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      //もちもの名
                      //10文字まで
                      labelText: S.of(context).itemName,
                      counterText: S.of(context).tenWord,
                    ),
                  ),
                ),
              ),
              ButtonWithIcon(
                onPressed: _textEditingController.text.isEmpty
                    ? null
                    : () => _ItemAdd(context),
                // onPressed: () => _ItemAdd(context),
                icon: Icon(Icons.add_circle_outline),
                //もちものを登録する
                label: S.of(context).addItemToList,
                color:Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _pickImageItem(BuildContext context) async {
    final vm = context.read<ViewModel>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        //画像を選択する
        title: Text(S.of(context).selectImage, style: TextStyle(color: Colors.black87),),
        actions: <Widget>[
          ButtonWithIcon(
              onPressed: () {
                vm.pickImage(ImageSource.camera);
                //ダイアログ閉じる
                Navigator.pop(context);
              },
              icon: Icon(Icons.photo_camera),
              label: S.of(context).camera,
              color: Colors.white70),
          SizedBox(height: 28.0),
          ButtonWithIcon(
              onPressed: () {
                vm.pickImage(ImageSource.gallery);
                //ダイアログ閉じる
                Navigator.pop(context);
              },
              icon: Icon(Icons.photo),
              label: S.of(context).gallery,
              color: Colors.white70),
          SizedBox(
            height: 28.0,
          )
        ],
      ),
    );
  }

  //このコードは、新しいアイテムの名前と画像の情報を取得し、それをリストに追加する機能を作っています。

  Future _ItemAdd(BuildContext context) async {
    var itemName = _textEditingController.text;
    // 処理をViewModelへ外注

    final viewModel = context.read<ViewModel>();
    var itemImagePath =
        viewModel.imageFile != null ? viewModel.imageFile!.path : "";
    await viewModel.addItem(itemName, itemImagePath);
    Fluttertoast.showToast(
      //登録が完了しました
      msg: S.of(context).finishAdd,
      toastLength: Toast.LENGTH_LONG,
    );
    setState(() {
      _textEditingController.clear();
      viewModel.imageFile = null;
    });
  }

  _backEditSelectPage() {
    final vm = context.read<ViewModel>();
    vm.imageFile = null;
    Navigator.pop(context);
  }
}
