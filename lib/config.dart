import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

Future<void> main() async {
  const url = 'https://uimrlipemschuvujgljw.supabase.co';
  const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpbXJsaXBlbXNjaHV2dWpnbGp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNDczMDIsImV4cCI6MjA0NjcyMzMwMn0.jmMk92qtlmJnOemnSkO77bxHv2DVyrDJGXQiUjxnMKg';
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

  Future<List<dynamic>> fetchFood() async {
    final List<Map<String, dynamic>> response =
        await supabase.from('Food').select('*');
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Belajar Supabase",
      theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Belajar Supabase Flutter'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        body: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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
                      'name': name,
                      'description': description,
                      'price': price,
                      'quantity': quantity,
                      'image': _pickedImage!.path,
                    });

                    setState(() {
                      _nameController.clear();
                      _descriptionController.clear();
                      _priceController.clear();
                      _quantityController.clear();
                      _pickedImage = null;
                    });
                  },
                  child: const Text('Submit'),
                ),
                FutureBuilder<List<dynamic>>(
                  future: fetchFood(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No data found');
                    } else {
                      final data = snapshot.data!;
                      return DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Quantity')),
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: data.map((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text(item['name'] ?? '')),
                              DataCell(Text(item['description'] ?? '')),
                              DataCell(Text(item['price'].toString())),
                              DataCell(Text(item['quantity'].toString())),
                              DataCell(
                                IconButton(
                                  onPressed: () async {
                                    if (await confirm(context)) {
                                      await supabase .from('Food') .delete() .eq('id', item['id']);
                                      setState(() {});
                                    }
                                    return print('pressedCancel');
                                  },
                                  icon: const Icon(Icons.delete)
                                )
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}