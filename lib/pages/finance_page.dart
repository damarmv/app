import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/finance.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _type = 'Pemasukan';

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Finance>('financeBox');
    return Scaffold(
      appBar: AppBar(title: const Text('Keuangan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              Row(children: [
                Expanded(child: TextFormField(controller: _amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah (Rp)', border: OutlineInputBorder()), validator: (v) {
                  if (v == null || v.isEmpty) return 'Masukkan jumlah';
                  if (double.tryParse(v) == null) return 'Harus angka';
                  return null;
                })),
                const SizedBox(width: 8),
                DropdownButton<String>(value: _type, items: ['Pemasukan', 'Pengeluaran'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _type = v!)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final amt = double.parse(_amountCtrl.text) * (_type == 'Pemasukan' ? 1 : -1);
                  box.add(Finance(date: DateTime.now(), amount: amt, note: _noteCtrl.text));
                  _amountCtrl.clear();
                  _noteCtrl.clear();
                }, child: const Text('Simpan')),
              ]),
              const SizedBox(height: 8),
              TextFormField(controller: _noteCtrl, decoration: const InputDecoration(labelText: 'Keterangan', border: OutlineInputBorder())),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(child: ValueListenableBuilder(valueListenable: box.listenable(), builder: (context, Box<Finance> b, _) {
            if (b.isEmpty) return const Center(child: Text('Belum ada transaksi'));
            final saldo = b.values.fold<double>(0, (s, f) => s + f.amount);
            return Column(children: [
              Text('Saldo: Rp ${saldo.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(child: ListView.builder(itemCount: b.length, itemBuilder: (_, i) {
                final f = b.getAt(i)!;
                return ListTile(
                  title: Text("${f.amount >= 0 ? '+' : '-'} Rp ${f.amount.abs().toStringAsFixed(0)}"),
                  subtitle: Text("${f.note} • ${f.date.toIso8601String()}"),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => b.deleteAt(i)),
                );
              })),
            ]);
          })),
        ]),
      ),
    );
  }
}
