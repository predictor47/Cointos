import 'package:get_it/get_it.dart';
import 'package:kointos/data/repositories/crypto_repository.dart';
import 'package:kointos/models/crypto_model.dart';
import 'package:kointos/data/models/chart_data.dart';

class CryptoService {
  final CryptoRepository _repository;

  CryptoService({CryptoRepository? repository})
      : _repository = repository ?? GetIt.I<CryptoRepository>();

  Future<List<Crypto>> getTopCoins({int limit = 100}) async {
    return _repository.getTopCoins(limit: limit);
  }

  Future<List<ChartData>> getCoinChart(String coinId, String days) async {
    return _repository.getCoinChart(coinId, days);
  }

  Future<List<double>> fetchHistoricalData(String coinId, int days) async {
    final chartData = await getCoinChart(coinId, days.toString());
    return chartData.map((data) => data.value).toList();
  }

  Stream<Map<String, double>> getPriceStream(List<String> coinIds) {
    return _repository.getPriceStream(coinIds);
  }

  Future<double> getCurrentPrice(String coinId) async {
    final coin = await _repository.getCoinDetails(coinId);
    return coin.currentPrice;
  }
}
