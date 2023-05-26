import 'package:shared_preferences/shared_preferences.dart';

class LocalDBHelper {
  static SharedPreferences? prefs;

  static Future init() async => prefs = await SharedPreferences.getInstance();

  List<String> getCurrencies() {
    if (prefs!.getStringList('currencies') == null) {
      setDefaultCurrencyValues();
    }
    return prefs!.getStringList('currencies')!;
  }

  setCurrency(List<String> currencyList) async {
    prefs!.setStringList('currencies', currencyList);
  }

  List<String> getDefaultCurrencies(){
    return ["€", "\$", "£", "₣", "¥", "₽", "₹"];
  }

  setDefaultCurrencyValues() async {
    List<String> currencies = ["€", "\$", "£", "₣", "¥", "₽", "₹"];
    if (prefs!.getStringList('currencies') == null) {
      prefs!.setStringList('currencies', currencies);
    }
  }

  setCurrentCurrency(String currency) {
    prefs!.setString('currentCurrency', currency);
  }

  String getCurrentCurrency() {
    if (prefs!.getString('currentCurrency') != null) {
      return prefs!.getString('currentCurrency')!;
    } else {
      return "€";
    }
  }

  reset() {
    prefs!.clear();
  }
}
