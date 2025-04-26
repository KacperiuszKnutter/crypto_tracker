import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'test_home_page_model.dart';
import 'package:crypto_tracker/backend/api_request_handler.dart';
import 'package:crypto_tracker/lazy_globals.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
export 'test_home_page_model.dart';

class ChartData {
  final DateTime x; // Timestamp
  final double y; // Price

  ChartData(this.x, this.y);
}

class TestHomePageWidget extends StatefulWidget {
  const TestHomePageWidget({super.key});

  static String routeName = 'TestHomePage';
  static String routePath = '/testHomePage';

  @override
  State<TestHomePageWidget> createState() => _TestHomePageWidgetState();
}

class _TestHomePageWidgetState extends State<TestHomePageWidget>
    with TickerProviderStateMixin {
  late TestHomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  String selectedTimePeriod = 'Miesiąc';
  String selectedCrypto = 'Bitcoin';
  HistoricalData? historicalData;
  bool isLoading = false;
  bool isPlotBuilt = false;
  String fiatCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestHomePageModel());

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(-40.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> generatePlot() async {
    setState(() {
      isLoading = true;
      historicalData = null;
      isPlotBuilt = false;
    });
    print("Plot generated!");

    final apiRequestHandler = ApiRequestHandler();
    fiatCurrency = selectedRegionCurrencyNotifier.value.isEmpty ?
    'USD' : selectedRegionCurrencyNotifier.value;
    int days = _mapTimeToDays(selectedTimePeriod);

    final (result, data) = await apiRequestHandler.fetchHistoricalData(
      cryptoId: selectedCrypto.toLowerCase(),
      fiatCurrency: fiatCurrency.toLowerCase(),
      days: days.toString(),
    );
    setState(() {
      isLoading = true;
      if(result == FetchHistoricalDataRes.success && data != null){
        historicalData = data;
        isLoading = false;
      }
      else{
        historicalData = null;
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Nie mogłem pobrać danych z API.'),
        ));
      }
    });
  }

  //mapujemy czas w jakim chcemy wyświetlać wykres.
  int _mapTimeToDays(String timePeriod) {
    switch (timePeriod) {
      case 'Tydzień':
        return 7;
      case 'Rok':
        return 365;
      case 'Miesiąc':
        return 30;
      case 'Dzień':
        return 1;
      default:
        return 7; // Default to a week if the value is invalid
    }
  }
  UniqueKey _chartKey = UniqueKey();
  Widget _buildChart() {
    if (!isPlotBuilt && historicalData == null) {
      return const Center(child: Text('',
        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),),
      );
    }
    if (historicalData == null) {
      return const Center(child: Text('Brak dostępnych danych!',
      style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),),
      );
    }
    if (historicalData!.prices.isEmpty) {
      return const Center(child: Text('Dane są puste!',
        style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),),
      );
    }

    // Mapowanie osi X na datę
    final List<ChartData> chartData = historicalData!.prices
        .map((item) => ChartData(DateTime.fromMillisecondsSinceEpoch(item[0].toInt()), item[1]))
        .toList();
    isPlotBuilt = true;
    return SfCartesianChart(
      // Tytuł wykresu oraz klucz zeby wykresy sie nie overlapowaly
      key: _chartKey,
      title: ChartTitle(text: 'Cena $selectedCrypto w $fiatCurrency'
      , textStyle: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
      tooltipBehavior: TooltipBehavior(enable: true),
      // Init pierwszej osi
      primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelStyle: const TextStyle(color: Colors.white)),
      // Init drugiej osi
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          labelStyle: const TextStyle(color: Colors.white)),
      series: <LineSeries<ChartData, DateTime>>[ // CORRECTED LINE
        // Initialize line series
        LineSeries<ChartData, DateTime>(
            name: 'Price',
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(isVisible: false),
            enableTooltip: true)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF3A3A48),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxHeight;

              return Column(
                children: [
                  /// HEADER (15%)
                  SizedBox(
                    height: height * 0.15,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      child: Row(
                        children: [
                          FlutterFlowIconButton(
                            borderColor: Colors.white,
                            borderRadius: 40.0,
                            buttonSize: 60.0,
                            fillColor: Colors.white,
                            icon: Icon(
                              Icons.manage_accounts_rounded,
                              color: Color(0xFFEDD15C),
                              size: 24.0,
                            ),
                            onPressed: () {
                              context.pushNamed(MyAccPageWidget.routeName);
                            },
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Wybierz kryptowalutę',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// COINGECKO (25%)
                  SizedBox(
                    height: height * 0.25,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Price data provided by:',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter Tight',
                              fontSize: 20.0,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await launchUrl(Uri.parse('https://www.coingecko.com'));
                            },
                            child: Text(
                              'CoinGecko',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter Tight',
                                fontSize: 20.0,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Image.asset(
                            'assets/images/coin_geckoAPI.png',
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: height * 0.1,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// DROPDOWN MENU (15%)
                  SizedBox(
                    height: height * 0.15,
                    child: Center(
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Time period dropdown
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: SizedBox(),
                                value: selectedTimePeriod,
                                onChanged: (String? newValue) {
                                  setState(() => selectedTimePeriod = newValue!);
                                  //za kazdym razem gdy zmieniamy ustawienia,
                                  //trzeba wygenerować wykres ponownie
                                  if(isPlotBuilt){
                                    generatePlot();
                                  }
                                },
                                items: ['Tydzień', 'Miesiąc', 'Dzień','Rok']
                                    .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                                    .toList(),
                              ),
                            ),

                            // Space between dropdowns
                            const SizedBox(width: 20),

                            // Cryptocurrency dropdown
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: SizedBox(),
                                value: selectedCrypto,
                                onChanged: (String? newValue) {
                                  setState(() => selectedCrypto = newValue!);
                                  //za kazdym razem gdy zmieniamy ustawienia,
                                  //trzeba wygenerować wykres ponownie
                                  if(isPlotBuilt){
                                    generatePlot();
                                  }
                                },
                                items: ['Bitcoin', 'Ethereum', 'Solana', 'DogeCoin','XRP','Tether','BNB','USDC','Cardano','Pepe']
                                    .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// WYKRES (30%)
                  SizedBox(
                    height: height * 0.35,
                    child: Container(
                        width: 350.0,
                        height: 300.0,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _buildChart()),
                  ),

                  /// BTC INFO (15%)
                  SizedBox(
                    height: height * 0.1,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      alignment: Alignment.center,
                      child: FFButtonWidget(
                        onPressed:() async {
                          generatePlot();
                        },
                        text: 'Generuj Wykres',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: const Color(0xFFF1BE4A),
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter Tight',
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
              ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
