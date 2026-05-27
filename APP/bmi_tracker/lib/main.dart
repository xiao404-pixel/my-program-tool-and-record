// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chart_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('zh', null);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const BmiTrackerApp());
}

class BmiTrackerApp extends StatelessWidget {
  const BmiTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI 健康追蹤',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  void _refreshOtherScreens() {
    // Force rebuild history and chart tabs when new record saved
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(onRecordSaved: _refreshOtherScreens),
      HistoryScreen(key: ValueKey(_tab == 1 ? 'h${DateTime.now()}' : 'h')),
      ChartScreen(key: ValueKey(_tab == 2 ? 'c${DateTime.now()}' : 'c')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.highlight.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.favorite_outline,
                  color: AppTheme.highlight, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('BMI 健康追蹤'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _tab,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: '計算',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: '記錄',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: '趨勢',
          ),
        ],
      ),
    );
  }
}
