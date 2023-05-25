import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? prefs;

  static Future init() async => prefs = await SharedPreferences.getInstance();

  List<String> getCurrencies() {
    return prefs!.getStringList('currencies')!;
  }

  setCurrency(List<String> currencyList) async {
    prefs!.setStringList('currencies', currencyList);
  }

  setDefaultCurrencyValues() async {
    List<String> currencies = ["€", "\$", "£", "₣", "¥", "₽", "₹"];
    if (prefs!.getStringList('currencies') == null) {
      prefs!.setStringList('currencies', currencies);
    }
  }
}
