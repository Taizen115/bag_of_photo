import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/view/parts/bag_card.dart';
import 'package:untitled1/view/screens/bag_detail_screen.dart';
import 'package:untitled1/vm/viewmodel.dart';

/*
* TODO[20250701]enumで状況に分けてパーツの表示を分ける
*   （BagMasterScreen）
*   ・All：バッグ一覧画面から全てバッグを消去する場合（チェック無し）
* 　・CHOOSE：バッグの一覧からバッグを選択する場合（チェック有り）
*   ・NORMAL : バックを消去しない場合(チェック無し)
* */
enum BagGridDisplayMode {
  ALL,
  CHOOSE,
  NORMAL,
}

class BagGridPart extends StatelessWidget {
  final BagGridDisplayMode displayCondition;

  const BagGridPart({required this.displayCondition});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 8,
      child: Consumer<ViewModel>(
        builder: (context, vm, child) {
          final validBags = vm.validBags;
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 100),
              childAnimationBuilder: (widget) => FadeInAnimation(child: widget),
              children: List<Widget>.generate(
                validBags.length,
                (index) {
                  final bag = validBags[index];
                  return AnimationConfiguration.synchronized(
                    duration: Duration(milliseconds: 100),
                    child: BagCard(
                        bag: bag,
                        onTap: () {
                          _goBagDetailScreen(
                            context,
                            openMode: BagDetailOpenMode.EDIT,
                            bagId: bag.id,
                          );
                        }, displayCondition: displayCondition,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _goBagDetailScreen(BuildContext context,
      {required BagDetailOpenMode openMode, required bagId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BagDetailScreen(openMode: openMode, bagId: bagId),
      ),
    );
  }
}
