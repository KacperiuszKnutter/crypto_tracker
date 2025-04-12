// simple_popup_widget.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../notifications/notifications_manager.dart';

class SimplePopupWidget extends StatefulWidget {
  const SimplePopupWidget({super.key});

  @override
  State<SimplePopupWidget> createState() => _SimplePopupWidgetState();
}

class _SimplePopupWidgetState extends State<SimplePopupWidget> {
  String selectedCurrency = 'Bitcoin';
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _submitAlert() async {
    final priceText = _priceController.text.trim();

    if (priceText.isEmpty || double.tryParse(priceText) == null) {
      Fluttertoast.showToast(
        msg: 'Wpisz poprawną wartość liczbową.',
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final enteredPrice = double.parse(priceText);
    final selectedCrypto = selectedCurrency; // Zmienna z dropdowna np. 'Bitcoin'

    // Inicjalizacja handlera powiadomień
    final notificationHandler = new NotificationHandler();
    await notificationHandler.initializeNotification();

    // opcjonalnie, tylko raz na aplikację
    await notificationHandler.configureLocalTimeZone();

    // Wywołanie testowego powiadomienia natychmiast
    await notificationHandler.showSimpleNotification(
      title: '$selectedCrypto',
      body: 'Osiągnęła oczekiwaną kwotę: $enteredPrice USD',
    );

    Fluttertoast.showToast(
      msg: 'Powiadomienie testowe wysłane!',
      gravity: ToastGravity.BOTTOM,
    );

    Navigator.of(context).pop(); // zamyka popup
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black54, // Przyciemnione tło
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ustaw alert cenowy',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCurrency = newValue!;
                    });
                  },
                  items: <String>['Bitcoin', 'DodgeCoin', 'Etherum', 'XRP', 'Solana']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Cena docelowa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitAlert,
                  child: const Text('Zapisz alert'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
