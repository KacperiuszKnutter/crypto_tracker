import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// do metody do pobierania SimplePrice
enum FetchCryptoPriceResult {
  success,
  noPriceData,
  httpError,
  exception,
}

//Do metody do pobierania danych historycznych

enum FetchHistoricalDataRes{
  success,
  noData,
  httpError,
  exception,
}

//z tej klasy bedziemy korzystac podczas faktycznego budowania wykresu w
// glownym widoku aplikacji
class HistoricalData {
  final List<List<double>> prices;
  final List<List<double>> marketCaps;
  final List<List<double>> totalVolumes;

  HistoricalData({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });
}

class ApiRequestHandler {
  final String baseUrl = 'api.coingecko.com';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  Future<(FetchCryptoPriceResult, double?)> fetchCryptoPrice({
    required String cryptoId,
    required String fiatCurrency,
  }) async {
    cryptoId = cryptoId.toLowerCase();
    fiatCurrency = fiatCurrency.toLowerCase();

    final url = Uri.https(
        baseUrl,
        '/api/v3/simple/price', {
      'ids': cryptoId,
      'vs_currencies': fiatCurrency
    });

    print('Wysyłam zapytanie do API: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'x_cg_demo_api_key': apiKey, // Add API key as a header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Odpowiedź API: $data');

        // Check if cryptoId exists and is a Map
        if (data[cryptoId] is Map) {
          final cryptoData = data[cryptoId] as Map<String, dynamic>;
          // Check if fiatCurrency exists in the cryptoData
          if (cryptoData.containsKey(fiatCurrency)) {
            final price = cryptoData[fiatCurrency];
            if (price is num) {
              return (FetchCryptoPriceResult.success, price.toDouble());
            } else {
              print('Błąd: Cena dla $cryptoId w $fiatCurrency nie jest liczbą');
              return (FetchCryptoPriceResult.noPriceData, null);
            }
          } else {
            print('Błąd: Brak ceny w odpowiedzi API dla $cryptoId w $fiatCurrency');
            return (FetchCryptoPriceResult.noPriceData, null);
          }
        } else {
          print('Błąd: Brak danych dla $cryptoId w odpowiedzi API');
          return (FetchCryptoPriceResult.noPriceData, null);
        }
      } else {
        print('Błąd API: ${response.statusCode}');
        return (FetchCryptoPriceResult.httpError, null);
      }
    } catch (e) {
      print('Wyjątek podczas pobierania ceny: $e');
      return (FetchCryptoPriceResult.exception, null);
    }
  }
  Future <(FetchHistoricalDataRes, HistoricalData?)> fetchHistoricalData({
    required String cryptoId,
    required String fiatCurrency,
    required String days,
  }) async {
    cryptoId = cryptoId.toLowerCase();
    fiatCurrency = fiatCurrency.toLowerCase();
    days = days.toLowerCase();
    final url = Uri.https(
      baseUrl,
      '/api/v3/coins/$cryptoId/market_chart',
      {
        'vs_currency': fiatCurrency,
        'days': days,
      },
    );
    print('Wysyłam zapytanie do API: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'x_cg_demo_api_key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Odpowiedź API (historyczne dane): $data');
        final List<List<double>> prices =
        (data['prices'] as List).map((item) => List<double>.from(item.map((e) => (e is int ? e.toDouble() : e as double)))).toList();
        final List<List<double>> marketCaps =
        (data['market_caps'] as List).map((item) => List<double>.from(item.map((e) => (e is int ? e.toDouble() : e as double)))).toList();
        final List<List<double>> totalVolumes =
        (data['total_volumes'] as List).map((item) => List<double>.from(item.map((e) => (e is int ? e.toDouble() : e as double)))).toList();
        return (
        FetchHistoricalDataRes.success,
        HistoricalData(
          prices: prices,
          marketCaps: marketCaps,
          totalVolumes: totalVolumes,
        )
        );
      } else {
        print('Błąd API (historyczne dane): ${response.statusCode}');
        return (FetchHistoricalDataRes.httpError, null);
      }
    }
    catch (e) {
      print('Wyjątek podczas pobierania historycznych danych: $e');
      return (FetchHistoricalDataRes.exception, null);
    }
  }
  }


