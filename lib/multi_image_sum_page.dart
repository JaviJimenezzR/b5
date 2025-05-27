import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MultiImageSumPage extends StatefulWidget {
  @override
  _MultiImageSumPageState createState() => _MultiImageSumPageState();
}

class _MultiImageSumPageState extends State<MultiImageSumPage> {
  final ImagePicker _picker = ImagePicker();
  double _total = 0.0;
  String _resultText = '';

  Future<void> _processImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images == null || images.isEmpty) return;

    double grandTotal = 0.0;
    String allText = '';

    for (XFile image in images) {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String scannedText = recognizedText.text;
      allText += '\n\n' + scannedText;

      RegExp regExp = RegExp(r'(\d+(?:[\.,]\d{1,2})?)\s*€');
      Iterable<RegExpMatch> matches = regExp.allMatches(scannedText);

      for (final match in matches) {
        String numberStr = match.group(1)!.replaceAll(',', '.');
        double? value = double.tryParse(numberStr);
        if (value != null) grandTotal += value;
      }

      await textRecognizer.close();
    }

    setState(() {
      _total = grandTotal;
      _resultText = allText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sumador de € en imágenes")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _processImages,
              child: Text("Seleccionar imágenes"),
            ),
            SizedBox(height: 20),
            Text("Total detectado: $_total €", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_resultText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
