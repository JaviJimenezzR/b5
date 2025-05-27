import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SumadorDeCuentas(),
    );
  }
}

class SumadorDeCuentas extends StatefulWidget {
  @override
  _SumadorDeCuentasState createState() => _SumadorDeCuentasState();
}

class _SumadorDeCuentasState extends State<SumadorDeCuentas> {
  final ImagePicker _picker = ImagePicker();
  double totalSum = 0;

  Future<void> pickImagesAndSum() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images == null || images.isEmpty) return;

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    double sum = 0;

    for (var image in images) {
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await textRecognizer.processImage(inputImage);

      // Solo números que terminan en €
      final regex = RegExp(r'(\d+[\.,]?\d*)\s*€');
      final matches = regex.allMatches(recognizedText.text);

      for (var match in matches) {
        String numberStr = match.group(1)!.replaceAll(',', '.');
        sum += double.tryParse(numberStr) ?? 0;
      }
    }

    await textRecognizer.close();

    setState(() {
      totalSum = sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suma de cuentas'),
      ),
      body: Center(
        child: totalSum > 0
            ? Text(
          'Total: €${totalSum.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        )
            : Text(
          'Selecciona imágenes para sumar las cuentas',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImagesAndSum,
        child: Icon(Icons.photo_library),
      ),
    );
  }
}

