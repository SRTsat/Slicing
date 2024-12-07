import 'package:flutter/material.dart';
import 'package:food_app/Pages/FormPage.dart';
import 'package:food_app/Widgets/AllBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<List<dynamic>> fetchFood() async {
  final List<Map<String, dynamic>> response = await supabase.from('Food').select('*');
  return response as List<dynamic>;
}

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Allbarwidget(),
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Formpage()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Data',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchFood(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found'));
                } else {
                  final data = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Foto')),
                        DataColumn(label: Text('Nama Produk')),
                        DataColumn(label: Text('Harga')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: data.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(
                             item['food_image'] != null
                              ? Image.asset(
                                'assets/${item['food_image']}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                            DataCell(Text(item['food_name'] ?? '')),
                            DataCell(Text('Rp.${item['food_price']}')),
                            DataCell(
                              IconButton(
                                icon: const Icon(CupertinoIcons.trash, color: Colors.red),
                                onPressed: () async {
                                  final confirmDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text('Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text('Delete'),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmDelete == true) {
                                    await supabase.from('Food').delete().eq('id', item['id']);
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}