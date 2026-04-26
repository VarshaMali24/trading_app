import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/watchlist_repository.dart';
import 'features/watchlist/bloc/watchlist_bloc.dart';
import 'features/watchlist/screens/watchlist_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const TradeTask());
}

class TradeTask extends StatelessWidget {
  const TradeTask({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<WatchlistRepository>(
      create: (_) => WatchlistRepositoryImpl(),
      child: BlocProvider(
        create: (context) => WatchlistBloc(
          repository: context.read<WatchlistRepository>(),
        )..add(const WatchlistInitialized()),
        child: MaterialApp(
          title: '021 Trade',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const WatchlistScreen(),
        ),
      ),
    );
  }
}
