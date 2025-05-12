import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'model/recurring_transaction.dart';
import 'providers/theme_provider.dart';
import 'routes.dart';
import 'utils/app_theme.dart';
import 'utils/notifications_service.dart';

late SharedPreferences _sharedPreferences;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(child: const ProviderScope(child: AppInitializer())));
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    NotificationService().requestNotificationPermissions();
    NotificationService().initializeNotifications();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    _sharedPreferences = await SharedPreferences.getInstance();

    final isFirstLoginCachedValue =
        _sharedPreferences.getBool('is_first_login');
    final isOnBoardingCompletedKeyNotSaved =
        _sharedPreferences.getBool('onboarding_completed') == null;

    if (isFirstLoginCachedValue != null && isOnBoardingCompletedKeyNotSaved) {
      await _sharedPreferences.setBool(
        'onboarding_completed',
        !isFirstLoginCachedValue,
      );
    }

    final lastCheck = _sharedPreferences.getString('last_recurring_transactions_check');
    final lastRecurringTransactionsCheck =
        lastCheck != null ? DateTime.parse(lastCheck) : null;

    if (lastRecurringTransactionsCheck == null ||
        DateTime.now().difference(lastRecurringTransactionsCheck).inDays >= 1) {
      RecurringTransactionMethods().checkRecurringTransactions();
      await _sharedPreferences.setString(
        'last_recurring_transactions_check',
        DateTime.now().toIso8601String(),
      );
    }

    await initializeDateFormatting('it_IT', null);

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return const Launcher();
  }
}

class Launcher extends ConsumerWidget {
  const Launcher({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    return MaterialApp(
      title: 'Ibis Transport',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          appThemeState.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: makeRoute,
      initialRoute: '/login',
    );
  }
}
