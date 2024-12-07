import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Widgets/AllBarWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  const url = 'https://uimrlipemschuvujgljw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpbXJsaXBlbXNjaHV2dWpnbGp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNDczMDIsImV4cCI6MjA0NjcyMzMwMn0.jmMk92qtlmJnOemnSkO77bxHv2DVyrDJGXQiUjxnMKg';
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );

}

final supabase = Supabase.instance.client;

class Formpage extends StatelessWidget {
  Formpage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = File(image.name);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _quantityController.clear();
    _pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Allbarwidget(),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  ),
                  if (_pickedImage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Image.file(
                        _pickedImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final name = _nameController.text;
                      final description = _descriptionController.text;
                      final price = _priceController.text;
                      final quantity =
                          double.tryParse(_quantityController.text);

                      if (name.isEmpty ||
                          description.isEmpty ||
                          price.isEmpty ||
                          quantity == null ||
                          _pickedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields correctly.'),
                          ),
                        );
                        return;
                      }

                      await supabase.from('Food').insert({
                        'food_name': name,
                        'food_price': price,
                        'food_quantity': quantity,
                        'food_image': _pickedImage!.path,
                        'food_description': description,
                      });

                      // Clear the form after submission
                      _clearForm();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form submitted successfully!'),
                        ),
                      );
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
