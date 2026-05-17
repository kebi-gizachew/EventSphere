import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/events/events_bloc.dart';
import 'screens/home_screen.dart';
import 'themes/app_theme.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const EventSphereApp());
}

class EventSphereApp extends StatelessWidget {
  const EventSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventsBloc(),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
