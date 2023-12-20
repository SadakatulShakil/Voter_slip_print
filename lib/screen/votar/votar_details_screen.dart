import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart' as car;
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voter_finder/data/model/votar_model.dart';

import '../../utill/color_resources.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class VotarDetailsScreen extends StatefulWidget {
  VotarDataModel votarDataList;

  VotarDetailsScreen(this.votarDataList);

  @override
  _VotarDetailsScreenState createState() => _VotarDetailsScreenState();
}

class _VotarDetailsScreenState extends State<VotarDetailsScreen> {
  GlobalKey _globalKey = GlobalKey();

  Future<Uint8List> _capturePng() async {
    final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    return byteData.buffer.asUint8List();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double devicePixelRatio = mediaQuery.devicePixelRatio;
    return Scaffold(
        appBar: AppBar(
          title: Text('ভোটার তথ্য', style: TextStyle(fontSize: 25 / MediaQuery.textScaleFactorOf(context)/devicePixelRatio*2.8)),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () async{
                          // Add your button click logic here
                          Uint8List imageBytes = await _capturePng();
                          _createPdf(imageBytes);
                        },
                        style: ElevatedButton.styleFrom(
                          primary:
                              Colors.redAccent, // Set the background color here
                        ),
                        child: Text('Print', style: TextStyle(
                            fontSize: 16 / MediaQuery.textScaleFactorOf(context)/devicePixelRatio*2.8)),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () async{
                          // Add your button click logic here
                          Uint8List imageBytes = await _capturePng();
                          _sharePdf(imageBytes);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: accent, // Set the background color here
                        ),
                        child: Text('Share', style: TextStyle(
                            fontSize: 16 / MediaQuery.textScaleFactorOf(context)/devicePixelRatio*2.8)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Image.asset('assets/images/print_banner1.png'),
              SizedBox(
                height: 5,
              ),
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('কেন্দ্রঃ ' + widget.votarDataList.center_name,
                        style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 24 / MediaQuery.textScaleFactorOf(context)/devicePixelRatio*2.8,)),
                        Text(widget.votarDataList.info.replaceAll('<br>', '\n'),
                            style: TextStyle(
                                fontSize: 24 / MediaQuery.textScaleFactorOf(context)/devicePixelRatio*2.8, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  /// create PDF & print it
  void _createPdf(Uint8List imageBytes) async {
    final height = MediaQuery.of(context).size.height;
    final doc = pw.Document();
    final ttf = await rootBundle.load('assets/fonts/mina.ttf');
    final font = pw.Font.ttf(ttf);
    /// for using an image from assets
    final image = await imageFromAssetBundle('assets/images/print_banner.png');
    // Create PdfImage from bytes
    final image1 = pw.MemoryImage(imageBytes);

    doc.addPage(
      pw.Page(
        textDirection: pw.TextDirection.ltr,
        pageFormat: PdfPageFormat.a3,
        build: (pw.Context context) {
          return pw.Container(
            height: height-130,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1.0),
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(10.0)),
            ),
            child: pw.Column(
              children: [
                pw.SizedBox(height: 10),
                pw.Container(
                  width: 500,
                  child: pw.Image(image, width: 300),
                ),
            pw.SizedBox(height: 50),
            pw.Transform.rotate(
              angle: -1.5 * 3.1415926535 / 3,
              child: pw.Image(image1, width: 300, height: 500)
              ),
              ],
            ),

          );
        },
      ),
    ); // Page

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    /// share the document to other applications:
    //await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

    /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
    /// save PDF with Flutter library "path_provider":
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());
  }

  /// share PDF
  void _sharePdf(Uint8List imageBytes) async {
    final height = MediaQuery.of(context).size.height;
    final doc = pw.Document();
    final ttf = await rootBundle.load('assets/fonts/kalpurush.ttf');
    final font = pw.Font.ttf(ttf);
    /// for using an image from assets
    final image = await imageFromAssetBundle('assets/images/print_banner.png');
    // Create PdfImage from bytes
    final imagePath = await saveImage(imageBytes);
    final image1 = pw.MemoryImage(imageBytes);

    doc.addPage(
      pw.Page(
        textDirection: pw.TextDirection.ltr,
        pageFormat: PdfPageFormat.a3,
        build: (pw.Context context) {
          return pw.Container(
            height: height+200,
            width: 350,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 0.0),
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(10.0)),
            ),
            child: pw.Column(
              children: [
                pw.SizedBox(height: 10),
                pw.Container(
                  width: 500,
                  child: pw.Image(image, width: 300),
                ),
                pw.SizedBox(height: 50),
                pw.Transform.rotate(
                    angle: -1.5 * 3.1415926535 / 3,
                    child: pw.Image(image1, width: 300, height: 300)
                ),
              ],
            ),

          );
        },
      ),
    ); // Page

    // /// print the document using the iOS or Android print service:
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => doc.save());

    /// share the document to other applications:
    await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

    /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
    /// save PDF with Flutter library "path_provider":
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());
  }


  Future<String> saveImage(Uint8List imageBytes) async {
    final Directory tempDir = await getTemporaryDirectory();
    final File tempFile = File('${tempDir.path}/data_image.png');
    await tempFile.writeAsBytes(imageBytes);
    return tempFile.path;
  }



}
