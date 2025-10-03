import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/production.dart';
import '../widgets/debug_panel.dart';

class ProductionPage extends StatefulWidget {
  final GlobalKey<DebugPanelState> debugPanelKey;
  const ProductionPage({super.key, required this.debugPanelKey});

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final _formKey = GlobalKey<FormState>();
  final _eggsCtrl = TextEditingController();

  @override
  void dispose() {
    _eggsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Production>('productionBox');
    return Scaffold(
      appBar: AppBar(title: const Text('Produksi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _eggsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Jumlah telur (butir)', border: OutlineInputBorder()),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Masukkan jumlah';
                    if (int.tryParse(v) == null) return 'Harus angka';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final eggs = int.parse(_eggsCtrl.text);
                  box.add(Production(date: DateTime.now(), eggs: eggs));
                  widget.debugPanelKey.currentState?.addLog('Tambah produksi: $eggs');
                  _eggsCtrl.clear();
                },
                child: const Text('Simpan'),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<Production> b, _) {
                if (b.isEmpty) return const Center(child: Text('Belum ada data'));
                return ListView.builder(
                  itemCount: b.length,
                  itemBuilder: (_, i) {
                    final p = b.getAt(i)!;
                    return ListTile(
                      title: Text("${p.eggs} butir"),
                      subtitle: Text(p.date.toIso8601String()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          b.deleteAt(i);
                          widget.debugPanelKey.currentState?.addLog('Hapus produksi index $i');
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
