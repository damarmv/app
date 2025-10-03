import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/stock.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final _itemCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Stock>('stockBox');
    return Scaffold(
      appBar: AppBar(title: const Text('Stok')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(child: TextField(controller: _itemCtrl, decoration: const InputDecoration(labelText: 'Nama item', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            SizedBox(width: 120, child: TextField(controller: _qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Qty', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              final name = _itemCtrl.text.trim();
              final q = int.tryParse(_qtyCtrl.text) ?? 0;
              if (name.isEmpty || q <= 0) return;
              box.add(Stock(item: name, quantity: q));
              _itemCtrl.clear();
              _qtyCtrl.clear();
            }, child: const Text('Tambah')),
          ]),
          const SizedBox(height: 12),
          Expanded(child: ValueListenableBuilder(valueListenable: box.listenable(), builder: (context, Box<Stock> b, _) {
            if (b.isEmpty) return const Center(child: Text('Belum ada stok'));
            return ListView.builder(itemCount: b.length, itemBuilder: (_, i) {
              final s = b.getAt(i)!;
              return ListTile(
                title: Text(s.item),
                subtitle: Text('Qty: ${s.quantity}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {
                    final newQty = s.quantity - 1;
                    s.quantity = newQty < 0 ? 0 : newQty;
                    s.save();
                  }),
                  IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {
                    s.quantity += 1;
                    s.save();
                  }),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => b.deleteAt(i)),
                ]),
              );
            });
          })),
        ]),
      ),
    );
  }
}
