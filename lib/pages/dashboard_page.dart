import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/production.dart';
import '../models/finance.dart';
import '../models/stock.dart';
import '../models/invoice.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prodBox = Hive.box<Production>('productionBox');
    final finBox = Hive.box<Finance>('financeBox');
    final stockBox = Hive.box<Stock>('stockBox');
    final invBox = Hive.box<Invoice>('invoiceBox');

    return ValueListenableBuilder(
      valueListenable: Listenable.merge([prodBox.listenable(), finBox.listenable(), stockBox.listenable(), invBox.listenable()]),
      builder: (context, _, __) {
        final latestProd = prodBox.isNotEmpty ? prodBox.getAt(prodBox.length - 1)!.eggs : 0;
        final weekly = prodBox.values.toList().cast<Production>();
        final weeklyLast7 = weekly.skip(weekly.length - (weekly.length < 7 ? weekly.length : 7)).toList();
        final sumWeek = weeklyLast7.fold<int>(0, (s, p) => s + p.eggs);
        final saldo = finBox.values.fold<double>(0, (s, f) => s + f.amount);
        final totalStockItems = stockBox.values.fold<int>(0, (s, st) => s + st.quantity);
        final pendingInv = invBox.values.where((i) => i.status == 'pending').length;

        return Scaffold(
          appBar: AppBar(title: const Text('Dashboard Interaktif')),
          body: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            children: [
              _card("Produksi Hari Ini", "$latestProd butir", Icons.egg, Colors.orange),
              _card("Total Mingguan", "$sumWeek butir", Icons.date_range, Colors.green),
              _card("Saldo", "Rp ${saldo.toStringAsFixed(0)}", Icons.attach_money, Colors.teal),
              _card("Stok Total", "$totalStockItems unit", Icons.inventory, Colors.blue),
              _card("Invoice Pending", "$pendingInv", Icons.receipt_long, Colors.purple),
              _chartCard(weeklyLast7),
            ],
          ),
        );
      },
    );
  }

  Widget _card(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _chartCard(List<Production> data) {
    final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.eggs.toDouble())).toList();
    if (spots.isEmpty) spots.add(const FlSpot(0, 0));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          const Text("Produksi Mingguan", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: spots, isCurved: true, dotData: FlDotData(show: true))]))),
        ]),
      ),
    );
  }
}
