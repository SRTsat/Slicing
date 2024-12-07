import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  const url = 'https://uimrlipemschuvujgljw.supabase.co';
  const anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpbXJsaXBlbXNjaHV2dWpnbGp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNDczMDIsImV4cCI6MjA0NjcyMzMwMn0.jmMk92qtlmJnOemnSkO77bxHv2DVyrDJGXQiUjxnMKg';
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyApp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final fileName = imageFile.path.split('/').last;

    try {
      // Upload gambar ke Supabase Storage
      await supabase.storage.from('food_images').upload(fileName, imageFile);

      // Dapatkan URL publik
      final publicUrl =
          supabase.storage.from('food_images').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitData() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    final quantity = double.tryParse(_quantityController.text.trim());

    if (name.isEmpty ||
        description.isEmpty ||
        price == null ||
        quantity == null ||
        _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    // Upload gambar ke Supabase
    final imageUrl = await _uploadImage(_pickedImage!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image.')),
      );
      return;
    }

    try {
      // Kirim data ke tabel 'Food'
      await supabase.from('Food').insert({
        'food_name': name,
        'food_price': price,
        'food_quantity': quantity,
        'food_image': imageUrl,
        'food_description': description,
      });

      // Bersihkan form setelah sukses
      setState(() {
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _quantityController.clear();
        _pickedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food added successfully!')),
      );
    } catch (e) {
      print('Error submitting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Food'),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Food Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _pickedImage != null
                    ? Image.file(
                        _pickedImage!,
                        height: 150,
                      )
                    : const Text('No image selected.'),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
