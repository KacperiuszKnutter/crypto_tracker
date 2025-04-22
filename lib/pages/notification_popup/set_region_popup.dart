import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../lazy_globals.dart';

class SetRegionPopup extends StatefulWidget {
  const SetRegionPopup({super.key});

  @override
  State<SetRegionPopup> createState() => _SetRegionPopup();
}

class _SetRegionPopup extends State<SetRegionPopup> {
  String selectedRegion = 'USA';
  final TextEditingController _priceController = TextEditingController();
  String selectedRegionCurrency = 'USD';


  //getter do kontrolera API z requestami
  String get currentRegionCurrency => selectedRegionCurrency;

  @override
  void initState() {
    super.initState();
    _loadSelectedRegion();
  }

  void _loadSelectedRegion() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRegion = prefs.getString('selected_region');

    if (savedRegion != null) {
      setState(() {
        selectedRegion = savedRegion;
      });
    }
  }

  Future<void> _saveSelectedRegion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_region', selectedRegion);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black54,
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
                  'Wybierz swój region!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedRegion,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRegion = newValue!;
                    });
                  },
                  items: <String>[
                    'USA',
                    'Polska',
                    'Zjednoczone Królestwo',
                    'Niemcy',
                    'Francja',
                    'Hiszpania',
                    'Rosja',
                    'Szwajcaria',
                    'Dania'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _saveSelectedRegion();
                    setCurrentCurrency();
                  },
                  child: const Text('Zapisz Region'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setCurrentCurrency() {
    switch (selectedRegion) {
      case 'Polska':
        selectedRegionCurrency = 'PLN';
        break;
      case 'USA':
        selectedRegionCurrency = 'USD';
        break;
      case 'Niemcy':
        selectedRegionCurrency = 'EUR';
        break;
      case 'Zjednoczone Królestwo':
        selectedRegionCurrency = 'GBP';
        break;
      case 'Francja':
        selectedRegionCurrency = 'EUR';
        break;
      case 'Hiszpania':
        selectedRegionCurrency = 'EUR';
        break;
      case 'Rosja':
        selectedRegionCurrency = 'RUB';
        break;
      case 'Szwajcaria':
        selectedRegionCurrency = 'CHF';
        break;
      case 'Dania':
        selectedRegionCurrency = 'DKK';
        break;
      default:
        selectedRegionCurrency = 'USD';
        break;
    }
    // Zaktualizuj preferowana walute w AuthManagerze
    selectedRegionCurrencyNotifier.value = selectedRegionCurrency;

    Fluttertoast.showToast(msg: 'Region zapisany: $selectedRegionCurrency');
    Navigator.of(context).pop();
  }
}
