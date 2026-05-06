import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme/app_theme.dart';
import 'screens/spend_summary_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:            Colors.transparent,
    statusBarIconBrightness:   Brightness.light,
    statusBarBrightness:       Brightness.dark,
  ));

  // Allow only portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(child: SpendApp()),
  );
}

class SpendApp extends StatelessWidget {
  const SpendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:        const Size(390, 844),
      minTextAdapt:      true,   // text never gets smaller than design
      splitScreenMode:   true,   // handles split-screen / foldables
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp(
        title:            'Spend Summary',
        debugShowCheckedModeBanner: false,
        theme:            buildAppTheme(),
        home:             child,
      ),
      child: const SpendSummaryScreen(),
    );
  }
}
