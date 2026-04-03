// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Items`
  String get item {
    return Intl.message(
      'Items',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Bag List`
  String get bagList {
    return Intl.message(
      'Bag List',
      name: 'bagList',
      desc: '',
      args: [],
    );
  }

  /// `Make My Bag`
  String get makeBag {
    return Intl.message(
      'Make My Bag',
      name: 'makeBag',
      desc: '',
      args: [],
    );
  }

  /// `Delete Selected`
  String get deleteSelected {
    return Intl.message(
      'Delete Selected',
      name: 'deleteSelected',
      desc: '',
      args: [],
    );
  }

  /// `Delete All`
  String get deleteAll {
    return Intl.message(
      'Delete All',
      name: 'deleteAll',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Do you delete the selected items?`
  String get deleteSentence1 {
    return Intl.message(
      'Do you delete the selected items?',
      name: 'deleteSentence1',
      desc: '',
      args: [],
    );
  }

  /// `Do you delete all items？`
  String get deleteSentence2 {
    return Intl.message(
      'Do you delete all items？',
      name: 'deleteSentence2',
      desc: '',
      args: [],
    );
  }

  /// `Do you delete the selected bags?`
  String get deleteSentence3 {
    return Intl.message(
      'Do you delete the selected bags?',
      name: 'deleteSentence3',
      desc: '',
      args: [],
    );
  }

  /// `Do you delete all bags?`
  String get deleteSentence4 {
    return Intl.message(
      'Do you delete all bags?',
      name: 'deleteSentence4',
      desc: '',
      args: [],
    );
  }

  /// `All Deleted`
  String get deleteSentence5 {
    return Intl.message(
      'All Deleted',
      name: 'deleteSentence5',
      desc: '',
      args: [],
    );
  }

  /// `Selection Deleted`
  String get deleteSentence6 {
    return Intl.message(
      'Selection Deleted',
      name: 'deleteSentence6',
      desc: '',
      args: [],
    );
  }

  /// `Do you delete the selected bags?`
  String get deleteSentence7 {
    return Intl.message(
      'Do you delete the selected bags?',
      name: 'deleteSentence7',
      desc: '',
      args: [],
    );
  }

  /// `A bag name and items are required. If you go back now, this bag won’t be saved. Continue?`
  String get checkSentence1 {
    return Intl.message(
      'A bag name and items are required. If you go back now, this bag won’t be saved. Continue?',
      name: 'checkSentence1',
      desc: '',
      args: [],
    );
  }

  /// `The bag name or items were removed. If you go back now, this bag will be deleted. Continue?`
  String get checkSentence2 {
    return Intl.message(
      'The bag name or items were removed. If you go back now, this bag will be deleted. Continue?',
      name: 'checkSentence2',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get checkSentence3 {
    return Intl.message(
      'Continue',
      name: 'checkSentence3',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get checkSentence4 {
    return Intl.message(
      'Continue',
      name: 'checkSentence4',
      desc: '',
      args: [],
    );
  }

  /// `Go Back`
  String get checkSentence5 {
    return Intl.message(
      'Go Back',
      name: 'checkSentence5',
      desc: '',
      args: [],
    );
  }

  /// `←Register`
  String get register {
    return Intl.message(
      '←Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Enter bag name.`
  String get bagNameInput {
    return Intl.message(
      'Enter bag name.',
      name: 'bagNameInput',
      desc: '',
      args: [],
    );
  }

  /// `Prepared Items`
  String get preparedItem {
    return Intl.message(
      'Prepared Items',
      name: 'preparedItem',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `No Items`
  String get noItem {
    return Intl.message(
      'No Items',
      name: 'noItem',
      desc: '',
      args: [],
    );
  }

  /// `Unprepared Items`
  String get unpreparedItem {
    return Intl.message(
      'Unprepared Items',
      name: 'unpreparedItem',
      desc: '',
      args: [],
    );
  }

  /// `Selection`
  String get selection {
    return Intl.message(
      'Selection',
      name: 'selection',
      desc: '',
      args: [],
    );
  }

  /// `Do you reset items？`
  String get resetSentence1 {
    return Intl.message(
      'Do you reset items？',
      name: 'resetSentence1',
      desc: '',
      args: [],
    );
  }

  /// `Do you reset prepared items \n to unprepared items？`
  String get resetSentence2 {
    return Intl.message(
      'Do you reset prepared items \n to unprepared items？',
      name: 'resetSentence2',
      desc: '',
      args: [],
    );
  }

  /// `Reset Items`
  String get resetSentence3 {
    return Intl.message(
      'Reset Items',
      name: 'resetSentence3',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warming {
    return Intl.message(
      'Warning',
      name: 'warming',
      desc: '',
      args: [],
    );
  }

  /// `All items except pinned ones are treated as unprepared.`
  String get warmingSentence {
    return Intl.message(
      'All items except pinned ones are treated as unprepared.',
      name: 'warmingSentence',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selectItem {
    return Intl.message(
      'Selected',
      name: 'selectItem',
      desc: '',
      args: [],
    );
  }

  /// `Add Items`
  String get addNew {
    return Intl.message(
      'Add Items',
      name: 'addNew',
      desc: '',
      args: [],
    );
  }

  /// `Items List`
  String get itemList {
    return Intl.message(
      'Items List',
      name: 'itemList',
      desc: '',
      args: [],
    );
  }

  /// `Add Items`
  String get addNewItem {
    return Intl.message(
      'Add Items',
      name: 'addNewItem',
      desc: '',
      args: [],
    );
  }

  /// `Add Items`
  String get itemAdd {
    return Intl.message(
      'Add Items',
      name: 'itemAdd',
      desc: '',
      args: [],
    );
  }

  /// `Select Images`
  String get selectImage {
    return Intl.message(
      'Select Images',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Name of Items`
  String get itemName {
    return Intl.message(
      'Name of Items',
      name: 'itemName',
      desc: '',
      args: [],
    );
  }

  /// `Maximum 10 characters.`
  String get tenWord {
    return Intl.message(
      'Maximum 10 characters.',
      name: 'tenWord',
      desc: '',
      args: [],
    );
  }

  /// `Add items to list`
  String get addItemToList {
    return Intl.message(
      'Add items to list',
      name: 'addItemToList',
      desc: '',
      args: [],
    );
  }

  /// `Your registration is complete.`
  String get finishAdd {
    return Intl.message(
      'Your registration is complete.',
      name: 'finishAdd',
      desc: '',
      args: [],
    );
  }

  /// `Edit Items`
  String get itemEdit {
    return Intl.message(
      'Edit Items',
      name: 'itemEdit',
      desc: '',
      args: [],
    );
  }

  /// `Change Items`
  String get itemChange {
    return Intl.message(
      'Change Items',
      name: 'itemChange',
      desc: '',
      args: [],
    );
  }

  /// `Delete Items`
  String get itemDelete0 {
    return Intl.message(
      'Delete Items',
      name: 'itemDelete0',
      desc: '',
      args: [],
    );
  }

  /// `Do you delete Items?`
  String get itemDelete1 {
    return Intl.message(
      'Do you delete Items?',
      name: 'itemDelete1',
      desc: '',
      args: [],
    );
  }

  /// `Items are deleted.`
  String get itemDelete2 {
    return Intl.message(
      'Items are deleted.',
      name: 'itemDelete2',
      desc: '',
      args: [],
    );
  }

  /// `Select Theme Color`
  String get selectColor {
    return Intl.message(
      'Select Theme Color',
      name: 'selectColor',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
