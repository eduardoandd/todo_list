import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/splash_screen/splash_screen_page.dart';
import 'package:todo_list/services/dark_mode_service.dart';
import 'package:todo_list/themes/dark_theme.dart';
import 'package:todo_list/themes/light_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkModeService>(
          create: (_) => DarkModeService(),
        ),
      ],
      child: Consumer<DarkModeService>(
        builder: (_, darkModeService, widget) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: darkModeService.darkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
