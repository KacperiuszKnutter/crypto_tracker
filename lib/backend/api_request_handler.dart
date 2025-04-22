import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRequestHandler {
  final String baseUrl = 'https://api.coingecko.com/api/v3/simple/price';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  //Najprostrsza metoda (get_simple_price) do ustawiania alertów cenowych
  Future<double?> fetchCryptoPrice({
    required String cryptoId,
    required String fiatCurrency,
  }) async {
    // Tworzenie pełnego URL zapytania
    cryptoId = cryptoId.toLowerCase();
    fiatCurrency = fiatCurrency.toLowerCase();
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=$cryptoId&vs_currencies=$fiatCurrency&x_cg_demo_api_key=$apiKey',
    );

    print('Wysyłam zapytanie do API: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Odpowiedź API: $data'); // Logowanie odpowiedzi z API

        // Sprawdzenie, czy w odpowiedzi znajduje się cena
        if (data[cryptoId] != null && data[cryptoId][fiatCurrency] != null) {
          return data[cryptoId][fiatCurrency].toDouble();
        } else {
          print('Błąd: Brak ceny w odpowiedzi API dla $cryptoId w $fiatCurrency');
          return null;
        }
      } else {
        print('Błąd API: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Wyjątek podczas pobierania ceny: $e');
      return null;
    }
  }

}
