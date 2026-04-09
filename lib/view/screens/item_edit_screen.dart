import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../parts/button_with_icon.dart';
import '../../db/database.dart';
import '../../main.dart';
import '../../vm/viewmodel.dart';

// この部分は、ItemEditScreenを作る時に、必ず「item」という名前のデータを渡さなければならない、ということを決めています

class ItemEditScreen extends StatefulWidget {
  final Item item;

  const ItemEditScreen({
    required this.item,
  });

  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  File? imageFile;
  TextEditingController _textEditingController = TextEditingController();
  Item? _item;

  //このコードは、スマホアプリの画面が表示されたとき (initState) と、
  // 画面が閉じられたとき (dispose) に、それぞれどのような処理を行うのかを定義しています。

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _textEditingController =
        TextEditingController(text: _item != null ? "${_item!.itemName}" : "");
    final vm = context.read<ViewModel>();
    vm.imageFile = null;
    adManager.initBannerAd();
    adManager.loadBannerAd();
  }

  @override
  void dispose() {
    adManager.disposeBannerAd();
    super.dispose();
  }

  Widget build(BuildContext context) {
    _item = widget.item;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: TextButton(
              onPressed: () {
                final vm = context.read<ViewModel>();
                vm.imageFile = null;
                Navigator.pop(context, true);
              },
              child: Text(
                "☓",
                style: TextStyle(color: Colors.black, fontSize: 25),
              )),
          title: Text(
            S.of(context).itemEdit,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Consumer<ViewModel>(
          builder: (context, vm, child) {
            final imageFile = vm.imageFile;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //   width: adManager.bannerAd.size.width.toDouble(),
                  //   height: adManager.bannerAd.size.height.toDouble(),
                  //   child: AdWidget(
                  //     ad: adManager.bannerAd,
                  //   ),
                  // ),
                  SizedBox(height: 20.0),
                  //持ち物の画像を表示
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageFile != null
                            ? Image.file(imageFile).image
                            : _item!.itemImagePath == ''
                                ? AssetImage('assets/images/gray.png')
                                : Image.file(File(_item!.itemImagePath),)
                                    .image,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImageItem(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70),
                    child: Text(S.of(context).selectImage),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        maxLength: 10,
                        style: TextStyle(fontSize: 22.0),
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          labelText: S.of(context).itemName,
                          counterText: S.of(context).tenWord,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  Gap(10.0),
                  ButtonWithIcon(
                      onPressed: _textEditingController.text.trim().isEmpty
                          ? null
                          : () => _ItemUpdate(context, _item!),
                      icon: Icon(Icons.add_circle_outline),
                      label: S.of(context).itemChange,
                      color: Colors.white70),
                  Gap(10.0),
                  ButtonWithIcon(
                      onPressed: () => _ItemDelete(context, _item!),
                      icon: Icon(Icons.delete),
                      label: S.of(context).itemDelete0,
                      color: Colors.white70),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //このコードは、**「画像を選ぶ」**ボタンを押すと、カメラで写真を撮るか、ギャラリーから画像を選ぶかを選べるダイアログを表示し、
  // 選択した画像をアプリで使えるようにする仕組みを作っています。

  Future _pickImageItem(BuildContext context) async {
    final vm = context.read<ViewModel>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).selectImage),
        actions: <Widget>[
          ButtonWithIcon(
              onPressed: () {
                vm.pickImage(ImageSource.camera);
                //ダイアログ閉じる
                Navigator.pop(context);
              },
              icon: Icon(Icons.photo_camera),
              label: S.of(context).camera,
              color: Colors.orangeAccent),
          SizedBox(height: 28.0),
          ButtonWithIcon(
              onPressed: () {
                vm.pickImage(ImageSource.gallery);
                //ダイアログ閉じる
                Navigator.pop(context);
              },
              icon: Icon(Icons.photo),
              label: S.of(context).gallery,
              color: Colors.lightBlueAccent),
        ],
      ),
    );
  }

  _ItemUpdate(BuildContext context, _item) async {
    var itemName = _textEditingController.text;
    var item = _item;
    final viewModel = context.read<ViewModel>();
    String itemImagePath = viewModel.imageFile != null
        ? viewModel.imageFile!.path
        : _item!.itemImagePath;
    await viewModel.updateEditItem(item, itemName, itemImagePath);
    viewModel.imageFile = null;
    Navigator.pop(context, true);
  }

  _ItemDelete(BuildContext context, _item) async {
    var item = _item;
    final viewModel = context.read<ViewModel>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(S.of(context).itemDelete1),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black87,
            ),
            child: Text(S.of(context).ok),
            onPressed: () async {
              await viewModel.deleteEditItem(item);
              await viewModel.getAllItem();
              Navigator.pop(context);
              Navigator.pop(context, true);
              viewModel.imageFile = null;
              Fluttertoast.showToast(
                msg: S.of(context).itemDelete2,
                toastLength: Toast.LENGTH_LONG,
              );
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
