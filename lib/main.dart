import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order/settings/theme.dart';
import 'package:order/views/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return runApp(ChangeNotifierProvider<ThemeProvider>(
    child: const MyApp(),
    create: (context) => ThemeProvider(isDark: sharedPreferences.getBool("isDark") ?? true),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.getTheme,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
  }
}
