import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/production.dart';
import 'models/finance.dart';
import 'models/stock.dart';
import 'models/invoice.dart';
import 'pages/dashboard_page.dart';
import 'pages/production_page.dart';
import 'pages/finance_page.dart';
import 'pages/stock_page.dart';
import 'pages/invoice_page.dart';
import 'widgets/debug_panel.dart';
import 'widgets/responsive_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ProductionAdapter());
  Hive.registerAdapter(FinanceAdapter());
  Hive.registerAdapter(StockAdapter());
  Hive.registerAdapter(InvoiceAdapter());

  await Hive.openBox<Production>('productionBox');
  await Hive.openBox<Finance>('financeBox');
  await Hive.openBox<Stock>('stockBox');
  await Hive.openBox<Invoice>('invoiceBox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _tab = 0;
  final String OPENAI_API_KEY = ""; // <-- isi jika mau ChatGPT
  final GlobalKey<DebugPanelState> debugKey = GlobalKey<DebugPanelState>();

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const DashboardPage(),
      ProductionPage(debugPanelKey: debugKey),
      const FinancePage(),
      const StockPage(),
      const InvoicePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poultry App (Final)',
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          ResponsiveScaffold(body: pages[_tab], currentIndex: _tab, onTap: (i) => setState(() => _tab = i)),
          DebugPanel(key: debugKey, apiKey: OPENAI_API_KEY),
        ],
      ),
    );
  }
}
