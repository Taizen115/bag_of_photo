import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/model/ad_manager.dart';
import 'package:untitled1/style/style.dart';
import 'package:untitled1/style/theme_provider.dart';
import 'package:untitled1/view/screens/bag_master_screen.dart';
import 'package:untitled1/vm/viewmodel.dart';
import 'db/database.dart';
import 'generated/l10n.dart';

//初期化
late MyDatabase database;
AdManager adManager = AdManager();

double screenWidth = 0.0;
double screenHeight = 0.0;
bool isPortrait = true;

void main() async {
  //広告の初期化
  //https://developers.google.com/admob/flutter/quick-start#initialize_the_mobile_ads_sdk
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();

  //起動時に前回の色を読み込む
  await themeProvider.loadTheme();

  await adManager.initAdmob();

  database = MyDatabase();

  //状態管理は、アプリの状態を記憶して、画面を更新する仕組みです。
  // ChangeNotifierProviderは、状態を保管しておくための箱のようなものです。
  // このコードでは、ViewModelという箱に状態を保管し、MyAppでその状態を使って画面を作っています。

  runApp(
    ///追加
    MultiProvider(
      providers: [
    ChangeNotifierProvider<ViewModel>(
      create: (context) => ViewModel(db: database),
      ///追加
    ),
      ChangeNotifierProvider<ThemeProvider>.value(
     value: themeProvider),
      ],
      child: DevicePreview(
          enabled: false,
          builder: (context) => MyApp(),
      )
    ),
  );
}


class MyApp extends StatelessWidget {
  final bag;

  const MyApp({Key? key, this.bag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   ///追加：ThemeProvider を取得
    final themeProvider = context.watch<ThemeProvider>();
    final baseTheme = themeProvider.themeData;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "バッグの中身",

     ///追加　テーマを ThemeProvider から取得して、フォントを上書き
      theme:  baseTheme.copyWith(
        // フォントだけ上書きしたい場合
        textTheme: baseTheme.textTheme.apply(
          fontFamily: MainFont,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: baseTheme.colorScheme.primary,
          foregroundColor: baseTheme.colorScheme.onPrimary,
          elevation: 0,
        ),
      ),
      // theme: ThemeData(
      // theme: ThemeData(fontFamily: MainFont, useMaterial3: false),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BagMasterScreen(bag: bag),
      builder: DevicePreview.appBuilder,      //追加
      locale: DevicePreview.locale(context),  //追加
    );
  }
}
