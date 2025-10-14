
import 'package:flutter/cupertino.dart';

class LanguageChangeController with ChangeNotifier{
  Locale? _appLocale;
  LanguageChangeController(this._appLocale);
  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type)async{
    _appLocale = type;
    notifyListeners();
  }
}