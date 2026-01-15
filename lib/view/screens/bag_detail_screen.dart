import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:untitled1/main.dart';

import '../parts/bag_detail_part.dart';

enum BagDetailOpenMode { NEW, EDIT }

class BagDetailScreen extends StatefulWidget {
  final BagDetailOpenMode openMode;
  final int? bagId;

  BagDetailScreen({required this.openMode, this.bagId});

  @override
  State<BagDetailScreen> createState() => _BagDetailScreenState();
}

class _BagDetailScreenState extends State<BagDetailScreen> {
  @override
  void initState() {
    print(
        "BagDetailScreen initState() openMode:${widget.openMode} / bagId:${widget.bagId}");

    super.initState();
    adManager.initBannerAd();
    adManager.loadBannerAd();
  }

  @override
  void dispose() {
    adManager.disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: BagDetailPart(
                  openMode: widget.openMode,
                  bagId: widget.bagId,
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
        ),
      ),
    );
  }
}
