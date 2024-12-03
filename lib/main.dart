import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(NutriScoreApp());
}

class NutriScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriScore App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Arial',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _scanResult = "Scan a product to get its Nutri-Grade!";
  String _nutriGrade = "";
  bool _isLoading = false;

  Future<void> scanBarcode() async {
    try {
      // Start barcode scanning
      var result = await BarcodeScanner.scan();

      setState(() {
        _scanResult = result.rawContent.isNotEmpty
            ? "Product Code: ${result.rawContent}"
            : "No barcode found!";
      });

      if (result.rawContent.isNotEmpty) {
        // Fetch Nutri-Grade via API
        fetchNutriGrade(result.rawContent);
      } else {
        setState(() {
          _nutriGrade = "";
        });
      }
    } catch (e) {
      setState(() {
        _scanResult = "Error occurred while scanning!";
        _nutriGrade = "";
      });
    }
  }

  Future<void> fetchNutriGrade(String barcode) async {
    setState(() {
      _isLoading = true;
      _nutriGrade = ""; // Clear the previous grade
    });

    try {
      // Replace with your API endpoint
      final url =
          Uri.parse('https://example.com/api/nutri-grade?barcode=$barcode');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nutriGrade = data['nutriGrade'] ?? "Unknown";
        });
      } else {
        setState(() {
          _nutriGrade = "Failed to fetch Nutri-Grade.";
        });
      }
    } catch (e) {
      setState(() {
        _nutriGrade = "Error fetching Nutri-Grade.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NutriScore App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _scanResult,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_nutriGrade.isNotEmpty)
              Text(
                "Nutri-Grade: $_nutriGrade",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: scanBarcode,
              icon: Icon(Icons.camera_alt),
              label: Text("Scan Barcode"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
