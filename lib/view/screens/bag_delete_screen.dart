import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/view/parts/bag_grid_part.dart';
import '../../generated/l10n.dart';
import '../../vm/viewmodel.dart';

class BagDeleteScreen extends StatelessWidget {
  final validBag;

  const BagDeleteScreen({required this.validBag});

  @override
  Widget build(BuildContext context) {
    ///追加
    Future(() {
      final vm = context.read<ViewModel>();
      vm.clearSelectBag();
    });

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
                style: TextStyle(color: Colors.black, fontSize: 25),
              )),
          title: Text(
            //選択消去
            S.of(context)!.deleteSelected,
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () async {
                  deleteBag(context);
                },
                //完了
                child: Text(S.of(context)!.done))
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
                child: BagGridPart(displayCondition: BagGridDisplayMode.CHOOSE),
              ),
            ),
          ],
        ),
      );
    });
  }

  deleteBag(BuildContext context) {
    final viewModel = context.read<ViewModel>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //選択したバッグを消去しますか？
        title: Text(S.of(context)!.deleteSentence3),
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
              // final viewModel = context.read<ViewModel>();
              await viewModel.deleteSelectBag();
              // await viewModel.getAllItem();
              Navigator.pop(context);

              ///追加
              Navigator.pop(context, true);
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
