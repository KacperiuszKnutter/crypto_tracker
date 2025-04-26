import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workmanager/workmanager.dart';

import 'auth/custom_auth/auth_util.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import 'backend/api_request_handler.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'index.dart';
import 'notifications/notifications_manager.dart';

//to musi byc globalnie
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Workmanager jest niezbędny do robienia task scheduling w tle (wysyłanie powiadomień)
  Workmanager().executeTask((task, inputData) async {
    try {
      // Sprawdzamy, czy inputData zawiera niezbędne dane
      if (inputData == null) {
        print("Brak danych wejściowych.");
        return Future.value(true);
      }

      final cryptoId = inputData['cryptoId'];
      final targetPrice = double.tryParse(inputData['targetPrice']);
      final fiat = inputData['fiat'] ?? 'usd';

      // Sprawdzamy, czy wszystkie dane są poprawne
      if (cryptoId == null || targetPrice == null) {
        print("Brak wymaganych danych: cryptoId lub targetPrice.");
        return Future.value(false);
      }

      // Wykonujemy zadanie API
      final success = await apiTask(cryptoId, targetPrice, fiat);
      return Future.value(success);
    } catch (e) {
      print("Błąd w callbackDispatcher: $e");
      return Future.value(false);
    }
  });
}

Future<bool> apiTask(String cryptoId, double targetPrice, String fiat) async {
  try {
    // Pobieranie ceny z API
    final priceFetcher = ApiRequestHandler();
    final (FetchCryptoPriceResult result, double? currentPrice) = await priceFetcher.fetchCryptoPrice(
      cryptoId: cryptoId,
      fiatCurrency: fiat,
    );

    // Sprawdzamy, czy pobieranie ceny zakończyło się sukcesem
    if (result == FetchCryptoPriceResult.success) {
      if (currentPrice != null) {
        // Sprawdzamy, czy cena osiągnęła próg
        if (currentPrice >= targetPrice) {
          final notificationHandler = NotificationHandler();
          await notificationHandler.initializeNotification();
          await notificationHandler.configureLocalTimeZone();

          await notificationHandler.showSimpleNotification(
            title: '$cryptoId',
            body: 'Cena osiągnęła próg: $targetPrice $fiat (obecnie: $currentPrice)',
          );
          return true;
        } else {
          print("Cena $cryptoId: $currentPrice, nie osiągnęła progu $targetPrice.");
          return false;
        }
      } else {
        print("Cena jest nullem mimo sukcesu");
        return false;
      }
    } else {
      print("Błąd pobierania ceny dla $cryptoId: $result");
      return false;
    }
  } catch (e) {
    print("Błąd w apiTask: $e");
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  //odkomentować tylko gdy są błędy z bazą danych
  //final dbPath = await getDatabasesPath();
  //final path = join(dbPath, 'crypto_tracker.db');
  //await deleteDatabase(path);

  await FlutterFlowTheme.initialize();

  //authManager jako singleton, nie ruszac go juz
  await Future.wait([
    authManager.initialize(),
  ]);
  await dotenv.load();

  //zawsze musimy uzupełnić dane o użytkowniku bo nie nastapi init
  //pierwszego ekranu
  AppStateNotifier.instance.update(CryptoTrackerAuthUser(loggedIn: false, uid: null));
  //potem mozemy juz wylogowac sie zeby w AuthManager nie przechowyac nic o
  //obecnnym uztkowniku
  await authManager.signOut();


  //w main inicjalizujemy workManager jego callback zdefiniowany wyzej
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);


  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e as RouteMatch?))
          .toList();

  late Stream<CryptoTrackerAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = cryptoTrackerAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CryptoTracker',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
