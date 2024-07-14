import 'package:currency_converter/data/models/rates_model.dart';
import 'package:currency_converter/data/repositories/rates_repository.dart';

class Rates {
  final RatesRepository rateRepository;

  Rates({required this.rateRepository});

  Future<RatesModel> fetchRatesExecution() {
    return rateRepository.fetchRates();
  }

  Future<Map> fetchCurrenciesExecution() {
    return rateRepository.fetchCurrencies();
  }

  String convertExecution(Map exchangeRate, String amount, String currencyBase,
      String currencyFinal) {
    return rateRepository.convertToAnyCurrency(
        exchangeRate, amount, currencyBase, currencyFinal);
  }
}
