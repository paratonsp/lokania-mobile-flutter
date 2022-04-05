import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lokania/src/blocs/language.bloc.dart';
import 'package:lokania/src/blocs/theme.bloc.dart';
import 'package:lokania/src/helpers/localization.dart';
import 'package:lokania/src/utils/themes.dart';
import 'package:lokania/src/screens/splashscreen/SplashscreenUI.dart';

void main() => runApp(MultiBlocProvider(providers: [
      BlocProvider<ThemeBloc>(
        create: (BuildContext context) => ThemeBloc()..add(ThemeLoadStarted()),
      ),
      BlocProvider<LanguageBloc>(
        create: (BuildContext context) =>
            LanguageBloc()..add(LanguageLoadStarted()),
      ),
    ], child: HotelApp()));

class HotelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: languageState.locale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: [
              // Locale('en', 'US'),
              Locale('id', 'ID'),
            ],
            title: 'Lokania',
            themeMode: themeState.themeMode,
            theme: buildThemeLight(context),
            darkTheme: buildThemeDark(context),
            home: SplashscreenUI(),
          );
        });
      },
    );
  }
}
