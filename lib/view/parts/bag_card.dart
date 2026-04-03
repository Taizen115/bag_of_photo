import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/view/parts/bag_grid_part.dart';
import 'package:untitled1/vm/viewmodel.dart';

import '../../db/database.dart';
import '../../generated/l10n.dart';

class BagCard extends StatefulWidget {
  final Bag bag;
  final VoidCallback onTap;
  final displayCondition;

  const BagCard(
      {super.key,
      required this.bag,
      required this.onTap,
      required this.displayCondition});

  @override
  State<BagCard> createState() => _BagCardState();
}

class _BagCardState extends State<BagCard> {
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ViewModel>();
    isCheck = vm.selectedBags.contains(widget.bag);
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onLongPress: () => checkDelete(context),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          shadowColor: Colors.white70,
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          elevation: 120.0,
          child: Stack(children: [
            GridTile(
              child: Center(
                child: Text(
                  widget.bag.name,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            (widget.displayCondition == BagGridDisplayMode.ALL)
                ? Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Checkbox(
                      value: isCheck,
                      onChanged: (value) {
                        setState(() {
                          isCheck = value!;
                          final viewModel = context.read<ViewModel>();
                          viewModel.deleteAllBag();
                        });
                      },
                    ),
                  )
                : (widget.displayCondition == BagGridDisplayMode.CHOOSE)
                    ? Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: Checkbox(
                          value: isCheck,
                          onChanged: (value) {
                            setState(() {
                              isCheck = value!;
                              final vm = context.read<ViewModel>();
                              if (isCheck) {
                                vm.addValidBag(widget.bag);
                              } else {
                                vm.removeValidBag(widget.bag);
                              }
                              //viewModel.deleteSelectBag(validBag: widget.bag);
                            });
                          },
                        ),
                      )
                    : Container(),
          ]),
        ),
      ),
    );
  }

  void checkDelete(BuildContext context) {
    context.read<ViewModel>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //選択したバッグを消去しますか？
        title: Text(S.of(context).deleteSentence7),
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
              foregroundColor: Colors.black87,
            ),
            child: Text(S.of(context).ok),
            onPressed: () async {
              final vm = context.read<ViewModel>();
              await vm.deleteOneBag(widget.bag);
              Navigator.pop(context);
              // Navigator.pop(context);
              Fluttertoast.showToast(
                //選択消去しました
                msg: S.of(context).deleteSentence6,
                toastLength: Toast.LENGTH_LONG,
              );
            },
          ),
        ],
      ),
    );
  }
}
