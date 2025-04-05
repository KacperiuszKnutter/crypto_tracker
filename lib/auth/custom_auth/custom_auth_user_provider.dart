import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class CryptoTrackerAuthUser {
  CryptoTrackerAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<CryptoTrackerAuthUser> cryptoTrackerAuthUserSubject =
    BehaviorSubject.seeded(CryptoTrackerAuthUser(loggedIn: false));
Stream<CryptoTrackerAuthUser> cryptoTrackerAuthUserStream() =>
    cryptoTrackerAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
