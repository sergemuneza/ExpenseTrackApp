// // // import 'dart:io';
// // // import 'package:intl/intl.dart';
// // // import 'package:path_provider/path_provider.dart';
// // // import 'package:pdf/widgets.dart' as pw;
// // // import '../models/transaction.dart';

// // // class PDFService {
// // //   static Future<File> generateTransactionReport(List<Transaction> transactions) async {
// // //     final pdf = pw.Document();
// // //     final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // ✅ Ensure proper date formatting

// // //     pdf.addPage(
// // //       pw.Page(
// // //         build: (pw.Context context) => pw.Column(
// // //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// // //           children: [
// // //             pw.Text(
// // //               "Financial Transactions Report",
// // //               style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
// // //             ),
// // //             pw.SizedBox(height: 10),
// // //             pw.Table.fromTextArray(
// // //               headers: ["Date", "Category", "Type", "Amount", "Description"],
// // //               data: transactions.map((t) {
// // //                 return [
// // //                   dateFormat.format(t.date), // ✅ Correct date formatting
// // //                   t.category,
// // //                   t.type.toUpperCase(),
// // //                   "\$${t.amount.toStringAsFixed(2)}",
// // //                   t.description
// // //                 ];
// // //               }).toList(),
// // //               border: pw.TableBorder.all(),
// // //               headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
// // //               cellPadding: pw.EdgeInsets.all(5),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );

// // //     final output = await getApplicationDocumentsDirectory();
// // //     final file = File("${output.path}/transaction_report.pdf");

// // //     await file.writeAsBytes(await pdf.save());
// // //     return file;
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:intl/intl.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import '../models/transaction.dart';

// // class PDFService {
// //   static Future<File> generateTransactionReport(
// //       List<Transaction> transactions) async {
// //     final pdf = pw.Document();
// //     final dateFormat = DateFormat('yyyy-MM-dd');

// //     // Sort transactions by date
// //     transactions.sort((a, b) => a.date.compareTo(b.date));

// //     pdf.addPage(
// //       pw.Page(
// //         margin: const pw.EdgeInsets.all(24),
// //         build: (pw.Context context) => pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Text(
// //               "Financial Transactions Report",
// //               style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
// //             ),
// //             pw.SizedBox(height: 8),
// //             pw.Text(
// //               "Generated by CungaCash on: ${dateFormat.format(DateTime.now())}",
// //               style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
// //             ),
// //             pw.Divider(),
// //             pw.SizedBox(height: 10),
// //             pw.Table.fromTextArray(
// //               headers: [
// //                 "Date",
// //                 "Category",
// //                 "Type",
// //                 "Amount (Frw)",
// //                 "Description"
// //               ],
// //               data: transactions
// //                   .map((t) => [
// //                         dateFormat.format(t.date),
// //                         t.category,
// //                         t.type.toUpperCase(),
// //                         "${t.amount.toStringAsFixed(2)}",
// //                         t.description
// //                       ])
// //                   .toList(),
// //               border: pw.TableBorder.all(width: 0.5),
// //               headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
// //               cellPadding: const pw.EdgeInsets.all(6),
// //               headerDecoration:
// //                   const pw.BoxDecoration(color: PdfColors.grey300),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );

// //     final output = await getApplicationDocumentsDirectory();
// //     final file = File("${output.path}/transaction_report.pdf");
// //     await file.writeAsBytes(await pdf.save());
// //     return file;
// //   }
// // }
// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import '../models/transaction.dart';

// class PDFService {
//   static Future<File> generateTransactionReport(
//       List<Transaction> transactions) async {
//     final pdf = pw.Document();
//     final dateFormat = DateFormat('yyyy-MM-dd');

//     // Sort transactions by date
//     transactions.sort((a, b) => a.date.compareTo(b.date));

//     pdf.addPage(
//       pw.MultiPage(
//         margin: const pw.EdgeInsets.all(24),
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) => [
//           pw.Text(
//             "Financial Transactions Report",
//             style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
//           ),
//           pw.SizedBox(height: 8),
//           pw.Text(
//             "Generated by CungaCash on: ${dateFormat.format(DateTime.now())}",
//             style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
//           ),
//           pw.Divider(),
//           pw.SizedBox(height: 10),
//           pw.Table.fromTextArray(
//             headers: [
//               "Date",
//               "Category",
//               "Type",
//               "Amount (Frw)",
//               "Description"
//             ],
//             data: transactions
//                 .map((t) => [
//                       dateFormat.format(t.date),
//                       t.category,
//                       t.type.toUpperCase(),
//                       "${t.amount.toStringAsFixed(2)}",
//                       t.description
//                     ])
//                 .toList(),
//             border: pw.TableBorder.all(width: 0.5),
//             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             cellPadding: const pw.EdgeInsets.all(6),
//             headerDecoration:
//                 const pw.BoxDecoration(color: PdfColors.grey300),
//             cellAlignments: {
//               0: pw.Alignment.centerLeft,
//               1: pw.Alignment.centerLeft,
//               2: pw.Alignment.center,
//               3: pw.Alignment.centerRight,
//               4: pw.Alignment.centerLeft,
//             },
//           ),
//         ],
//       ),
//     );

//     final output = await getApplicationDocumentsDirectory();
//     final file = File("${output.path}/transaction_report.pdf");
//     await file.writeAsBytes(await pdf.save());
//     return file;
//   }
// }
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/transaction.dart';

class PDFService {
  static Future<File> generateTransactionReport(
      List<Transaction> transactions) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Sort transactions by date
    transactions.sort((a, b) => a.date.compareTo(b.date));

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Text(
            "Financial Transactions Report",
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            "Generated by CungaCash on: ${dateFormat.format(DateTime.now())}",
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: [
              "Date",
              "Category",
              "Type",
              "Amount (Frw)",
              "Description"
            ],
            data: transactions
                .map((t) => [
                      dateFormat.format(t.date),
                      t.category,
                      t.type.toUpperCase(),
                      "${t.amount.toStringAsFixed(2)}",
                      t.description
                    ])
                .toList(),
            border: pw.TableBorder.all(width: 0.5),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellPadding: const pw.EdgeInsets.all(6),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerLeft,
            },
          ),
        ],
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 16),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("CungaCash — Smart Personal Finance Manager",
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ],
          ),
        ),
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/transaction_report.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
