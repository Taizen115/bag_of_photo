import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/view/parts/item_grid_part.dart';
import 'package:untitled1/view/screens/item_add_screen.dart';
import 'package:untitled1/vm/viewmodel.dart';

import '../../generated/l10n.dart';

class ItemSelectScreen extends StatefulWidget {
  @override
  State<ItemSelectScreen> createState() => _ItemSelectScreenState();
}

class _ItemSelectScreenState extends State<ItemSelectScreen> {
  @override
  void initState() {
    super.initState();
    adManager.initBannerAd();
    adManager.loadBannerAd();
    _getAllItems();
  }

  @override
  void dispose() {
    adManager.disposeBannerAd();
    super.dispose();
  }

  Future<void> _getAllItems() async {
    final viewModel = context.read<ViewModel>();
    await viewModel.getAllItem();
  }

  @override
  Widget build(BuildContext context) {
    // final vm = context.read<ViewModel>();
    // vm.getAllItemsNormal();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          //もちもの選択
          S.of(context)!.selectItem,
          style: TextStyle(fontSize: 25.0, color: Colors.white70),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.white70,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: FaIcon(FontAwesomeIcons.arrowLeft),
        ),
        actions: [
          TextButton(
            onPressed: () => _goItemAddScreen(context),
            //新規追加
            child: Text(S.of(context)!.addNew,
                style: TextStyle(fontSize: 20.0, color: Colors.white70)),
          ),
        ],
      ),
      body: Consumer<ViewModel>(
        builder: (BuildContext context, vm, child) {
          return Column(
            children: [
              Expanded(
                child: ItemGridPart(
                  displayMode: ItemGridDisplayMode.SELECT,
                ),
              ),
              Container(
                width: adManager.bannerAd.size.width.toDouble(),
                height: adManager.bannerAd.size.height.toDouble(),
                child: AdWidget(
                  ad: adManager.bannerAd,
                ),
              ),
              Gap(kToolbarHeight + 2.0)
            ],
          );
        },
      ),
    );
  }

  _goItemAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemAddScreen(),
      ),
    );
  }
}
