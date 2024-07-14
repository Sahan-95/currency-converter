import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:currency_converter/data/models/currency.dart';
import 'package:currency_converter/data/models/rates_model.dart';

abstract class RatesRepository {
  Future<RatesModel> fetchRates();
  Future<Map> fetchCurrencies();
  String convertToAnyCurrency(Map exchangeRate, String amount,
      String currencyBase, String currencyFinal);
}

class RatesServiceImpl implements RatesRepository {
  String apiKey = dotenv.env["APP_KEY"]!;
  
  @override
  Future<RatesModel> fetchRates() async {
    try {
      final res = await http.get(Uri.parse(
          'https://openexchangerates.org/api/latest.json?app_id=$apiKey'));

      final results = ratesModelFromJson(res.body);
      return results;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map> fetchCurrencies() async {
    try {
      final res = await http.get(Uri.parse(
          'https://openexchangerates.org/api/currencies.json?app_id=$apiKey'));
      final allCurrencies = allCurrenciesFromJson(res.body);
      return allCurrencies;
    } catch (e) {
      rethrow;
    }
  }

  @override
  String convertToAnyCurrency(Map exchangeRate, String amount,
      String currencyBase, String currencyFinal) {
    return ((double.parse(amount) / exchangeRate[currencyBase]) *
            exchangeRate[currencyFinal])
        .toStringAsFixed(2)
        .toString();
  }
}
