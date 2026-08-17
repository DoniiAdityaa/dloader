import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dloader/shared_widget/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'cubit/downloader_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();

  runApp(
    LiquidGlassWidgets.wrap(
      child: const MyApp(),
      adaptiveQuality: true,
      theme: GlassThemeData.simple(
        blur: 12,
        thickness: 32,
        quality: GlassQuality.premium,
        refractiveIndex: 1.4,
        chromaticAberration: 0.02,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DownloaderCubit(),
      child: MaterialApp(
        title: 'dloader Downloader',
        debugShowCheckedModeBanner: false,

        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'JetBrainsMono',
          scaffoldBackgroundColor: Colors.black,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Colors.white.withValues(alpha: 0.3),
            selectionHandleColor: Colors.white,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            surface: Color(0xFF111111),
          ),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}
