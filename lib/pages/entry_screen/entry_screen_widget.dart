import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'entry_screen_model.dart';
export 'entry_screen_model.dart';
import 'package:auto_size_text/auto_size_text.dart';


class EntryScreenWidget extends StatefulWidget {
  const EntryScreenWidget({super.key});

  static String routeName = 'EntryScreen';
  static String routePath = '/entryScreen';

  @override
  State<EntryScreenWidget> createState() => _EntryScreenWidgetState();
}

class _EntryScreenWidgetState extends State<EntryScreenWidget> {
  late EntryScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EntryScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3A48),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Nagłówek
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      AutoSizeText(
                        'Crypto Tracker',
                        style: FlutterFlowTheme.of(context).headlineLarge.override(
                          fontFamily: 'Inter Tight',
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        maxLines: 1,
                        minFontSize: 20,
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        'Bądź zawsze na bieżąco ze światem krypto.',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Inter Tight',
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        minFontSize: 16,
                      ),
                    ],
                  ),
                ),

                // Obrazek – elastyczny rozmiar
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(
                      'assets/images/image-removebg-preview.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Przycisk i tekst
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FFButtonWidget(
                        onPressed:() async {
                          if(Navigator.of(context).canPop()){
                            context.pop();
                          }
                          context.pushNamed(
                            LoginScreenWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                              ),
                            }
                          );
                        },
                        text: 'Zaloguj się',
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
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            'Nie masz jeszcze konta?',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if(Navigator.of(context).canPop()){
                                context.pop();
                              }
                              context.pushNamed(
                                  CreateAccScreenWidget.routeName,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 500),
                                    ),
                                  }
                              );
                            },
                            child: Text(
                              'Zarejestruj się',
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Inter Tight',
                                color: const Color(0xFFF1BE4A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
