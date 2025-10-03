import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFGenerator {
  static Future<void> exportInvoicePdf(String filename, String customer, List<Map<String, dynamic>> items) async {
    final doc = pw.Document();
    final total = items.fold<double>(0, (s, i) => s + (i['qty'] as int) * (i['price'] as double));
    doc.addPage(
      pw.Page(build: (ctx) {
        return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text("Customer: $customer"),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            headers: ['Item', 'Qty', 'Price', 'Subtotal'],
            data: items.map((e) => [e['item'], e['qty'].toString(), e['price'].toStringAsFixed(0), ((e['qty'] as int) * (e['price'] as double)).toStringAsFixed(0)]).toList(),
          ),
          pw.SizedBox(height: 12),
          pw.Text("Total: Rp ${total.toStringAsFixed(0)}"),
        ]);
      }),
    );

    final bytes = await doc.save();
    await Printing.layoutPdf(onLayout: (format) => bytes);
  }
}
