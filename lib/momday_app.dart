import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:momday_app/app_state_manager.dart';
import 'package:momday_app/backend_helpers/momday_backend.dart';
import 'package:momday_app/momday_localizations.dart';
import 'package:momday_app/screens/account_screen.dart';
import 'package:momday_app/screens/forgot_password_screen.dart';
import 'package:momday_app/screens/login_screen.dart';
import 'package:momday_app/screens/main_screen.dart';
import 'package:momday_app/screens/signup_screen.dart';
import 'package:momday_app/screens/splash_screen.dart';
import 'package:momday_app/styles/momday_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MomdayApp extends StatefulWidget {
  const MomdayApp();

  static void updateLocale(BuildContext context, Locale newLocale) {
    _MomdayAppState state = context.findAncestorStateOfType<_MomdayAppState>();

    state.updateLocale(newLocale);
  }

  @override
  _MomdayAppState createState() => _MomdayAppState();
}

class _MomdayAppState extends State<MomdayApp> {
  Locale _locale;
  Locale get locale {
    return this._locale;
  }

  set locale(Locale locale) {
    this._locale = locale;
    MomdayBackend().language = this._locale?.languageCode;
  }

  bool localeLoaded;

  @override
  void initState() {
    super.initState();
    this.localeLoaded = false;
    this._fetchLocale().then((locale) {
      setState(() {
        this.locale = locale;
        this.localeLoaded = true;
      });
    });
  }

  void updateLocale(newLocale) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('languageCode', newLocale.languageCode);
    });

    setState(() {
      this.locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    //if (!this.localeLoaded) {
    //  return SplashScreen();
    //}

    return MaterialApp(
      title: 'Momday',
      locale: this._locale,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'VAG',
          textTheme: TextTheme(
            display3: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w600,
                color: Colors.black),
            button: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
      builder: (context, navigator) {
        final language = Localizations.localeOf(context).languageCode;
        final parentTextTheme = Theme.of(context).textTheme;
        final localizedHeight = language == 'ar' ? 0.7 : 1.0;
        final textTheme = parentTextTheme.apply(
          fontSizeDelta: language == 'ar' ? -8.0 : 0.0,
        );

        return Theme(
            data: ThemeData(
              fontFamily: 'VAG',
              primaryColor: MomdayColors.MomdayGold,
              highlightColor: MomdayColors.MomdayHighlight,
              accentColor: MomdayColors.MomdayGold,
              textTheme: textTheme.copyWith(
                display3: textTheme.display3.copyWith(height: localizedHeight),
                subhead: textTheme.subhead.copyWith(height: localizedHeight),
                title: textTheme.title.copyWith(height: localizedHeight),
                button: textTheme.button.copyWith(height: localizedHeight),
                body1: textTheme.body1.copyWith(height: localizedHeight),
                body2: textTheme.body2.copyWith(height: localizedHeight),
                caption: textTheme.caption.copyWith(height: localizedHeight),
                display1: textTheme.display1.copyWith(height: localizedHeight),
                display2: textTheme.display2.copyWith(height: localizedHeight),
                display4: textTheme.display4.copyWith(height: localizedHeight),
                headline: textTheme.headline.copyWith(height: localizedHeight),
              ),
            ),
            child: AppStateManager(child: navigator));
      },
      routes: {
        '/': (context) => MainScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/my-account': (context) => AccountScreen()
      },
      localizationsDelegates: [
        const MomdayLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('ar', ''), // Arabic
      ],
    );
  }

  Future<Locale> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('languageCode') != null
        ? Locale(prefs.getString('languageCode'), '')
        : null;
  }
}
