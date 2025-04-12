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
export 'test_home_page_model.dart';

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
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      'Zacznijmy pracę!',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter Tight',
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.25,
                padding: EdgeInsets.all(12.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Column(
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
                    SizedBox(height: 8),
                    Image.asset(
                      'assets/images/coin_geckoAPI.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.1,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
                Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1 Tydz',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_drop_down_sharp,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 350.0,
                        height: 300.0,
                        // child: FlutterFlowLineChart(
                        //   data: [
                        //     FFLineChartData(
                        //       xData: functions.getChartData(),
                        //       yData: functions.getChartData(),
                        //       settings: LineChartBarData(
                        //         color: Color(0xFFEFD239),
                        //         barWidth: 3.0,
                        //         isCurved: true,
                        //         preventCurveOverShooting: true,
                        //         dotData: FlDotData(show: false),
                        //         belowBarData: BarAreaData(
                        //           show: true,
                        //           color: Color(0x4CEFD539),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        //   chartStylingInfo: ChartStylingInfo(
                        //     backgroundColor: Color(0xFF3A3A48),
                        //     showGrid: true,
                        //     borderColor:
                        //         FlutterFlowTheme.of(context).secondaryText,
                        //     borderWidth: 1.0,
                        //   ),
                        //   axisBounds: AxisBounds(),
                        //   xAxisLabelInfo: AxisLabelInfo(
                        //     reservedSize: 32.0,
                        //   ),
                        //   yAxisLabelInfo: AxisLabelInfo(
                        //     reservedSize: 40.0,
                        //   ),
                        // ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: MediaQuery.sizeOf(context).height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'BTC',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                      fontFamily: 'Inter Tight',
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Cena:',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Inter Tight',
                                letterSpacing: 0.0,
                              ),
                            ),
                            Text(
                              'Spadek/Wzrost:',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Inter Tight',
                                letterSpacing: 0.0,
                              ),
                            ),
                          ].divide(SizedBox(width: 15.0)),
                        ),
                      ),
                    ].divide(SizedBox(height: 10.0)),
                  ),
                ),
              ),

            ].divide(SizedBox(height: 30.0)),
          ),
        ),
      ),
    );
  }
}
