import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PlantDiseaseDetector(),
  ));
}

class PlantDiseaseDetector extends StatefulWidget {
  const PlantDiseaseDetector({super.key});

  @override
  State<PlantDiseaseDetector> createState() => _PlantDiseaseDetectorState();
}

class _PlantDiseaseDetectorState extends State<PlantDiseaseDetector> {
  File? _image;
  List? _results;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  // LOAD THE MODEL
  Future loadModel() async {
    Tflite.close(); // Close any previous instances
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  // RUN PREDICTION
  Future classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,      // Show top 2 results
      threshold: 0.5,     // Minimum confidence
      imageMean: 127.5,   // Standard for Teachable Machine
      imageStd: 127.5,
    );
    setState(() {
      _results = output;
      _image = image;
    });
  }

  // PICK FROM GALLERY OR CAMERA
  Future pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;
    classifyImage(File(image.path));
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Disease Detector"),
        backgroundColor: Colors.green[700],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Image Display Area
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: _image == null
                  ? const Center(child: Text("No image selected"))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            // Results Area
            if (_results != null)
              Column(
                children: _results!.map((res) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: ListTile(
                      leading: const Icon(Icons.info, color: Colors.green),
                      title: Text(
                        "${res['label']}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Text(
                        "${(res['confidence'] * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              const Text("Upload an image of a leaf to identify the disease"),
          ],
        ),
      ),
      // Action Buttons
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Camera"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
            ),
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text("Gallery"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
            ),
          ],
        ),
      ),
    );
  }
}