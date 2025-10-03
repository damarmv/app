import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/invoice.dart';
import '../widgets/pdf_generator.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});
  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final _cust = TextEditingController();
  final _item = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Invoice>('invoiceBox');
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice & Surat Jalan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(child: TextField(controller: _cust, decoration: const InputDecoration(labelText: 'Nama Customer', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _item, decoration: const InputDecoration(labelText: 'Item', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            SizedBox(width: 100, child: TextField(controller: _qty, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Qty', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            SizedBox(width: 120, child: TextField(controller: _price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              final c = _cust.text.trim();
              final it = _item.text.trim();
              final q = int.tryParse(_qty.text) ?? 0;
              final p = double.tryParse(_price.text) ?? 0;
              if (c.isEmpty || it.isEmpty || q <= 0 || p <= 0) return;
              box.add(Invoice(customer: c, item: it, qty: q, price: p, status: 'pending', date: DateTime.now()));
              _cust.clear();
              _item.clear();
              _qty.clear();
              _price.clear();
            }, child: const Text('Tambah')),
          ]),
          const SizedBox(height: 12),
          Expanded(child: ValueListenableBuilder(valueListenable: box.listenable(), builder: (context, Box<Invoice> b, _) {
            if (b.isEmpty) return const Center(child: Text('Belum ada invoice'));
            return ListView.builder(itemCount: b.length, itemBuilder: (_, i) {
              final inv = b.getAt(i)!;
              final subtotal = inv.qty * inv.price;
              return ListTile(
                title: Text('${inv.customer} - Rp ${subtotal.toStringAsFixed(0)}'),
                subtitle: Text('${inv.item} x${inv.qty} • ${inv.date.toIso8601String()}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.download, color: Colors.blue), onPressed: () {
                    final items = [{'item': inv.item, 'qty': inv.qty, 'price': inv.price}];
                    PDFGenerator.exportInvoicePdf('invoice_${i+1}.pdf', inv.customer, items);
                  }),
                  IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () {
                    inv.status = 'paid';
                    inv.save();
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
