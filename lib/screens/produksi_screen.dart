import 'package:flutter/material.dart';
import '../models/produksi.dart';
import '../services/db_helper.dart';

class ProduksiScreen extends StatefulWidget {
  @override
  _ProduksiScreenState createState() => _ProduksiScreenState();
}

class _ProduksiScreenState extends State<ProduksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();
  final _telurBagusController = TextEditingController();
  final _telurRusakController = TextEditingController();
  final _pakanController = TextEditingController();
  final _kematianController = TextEditingController();
  final _catatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Input Produksi Telur")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(labelText: "Tanggal (YYYY-MM-DD)"),
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),
              TextFormField(
                controller: _telurBagusController,
                decoration: InputDecoration(labelText: "Telur Bagus"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _telurRusakController,
                decoration: InputDecoration(labelText: "Telur Rusak"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _pakanController,
                decoration: InputDecoration(labelText: "Pakan Dipakai (kg)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _kematianController,
                decoration: InputDecoration(labelText: "Kematian Ayam"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _catatanController,
                decoration: InputDecoration(labelText: "Catatan"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Produksi produksi = Produksi(
                      tanggal: _tanggalController.text,
                      telurBagus: int.parse(_telurBagusController.text),
                      telurRusak: int.parse(_telurRusakController.text),
                      pakanDipakai: double.parse(_pakanController.text),
                      kematian: int.parse(_kematianController.text),
                      catatan: _catatanController.text,
                    );
                    await DBHelper.insertProduksi(produksi);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Data tersimpan")),
                    );
                    _tanggalController.clear();
                    _telurBagusController.clear();
                    _telurRusakController.clear();
                    _pakanController.clear();
                    _kematianController.clear();
                    _catatanController.clear();
                  }
                },
                child: Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
