
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'database/database_helper.dart';

class SchemaScreen extends StatefulWidget {
  const SchemaScreen({super.key});

  @override
  State<SchemaScreen> createState() => _SchemaScreenState();
}

class _SchemaScreenState extends State<SchemaScreen> {
  bool isLoading = true;

  List<Map<String, dynamic>> tables = [];

  @override
  void initState() {
    super.initState();
    loadSchema();
  }

  Future<void> loadSchema() async {
    setState(() {
      isLoading = true;
    });

    try {
      final db = await DatabaseHelper.instance.database;

      final tableResult = await db.rawQuery('''
        SELECT name
        FROM sqlite_master
        WHERE type = 'table'
        AND name NOT LIKE 'sqlite_%'
        ORDER BY name
      ''');

      List<Map<String, dynamic>> tableList = [];

      for (int i = 0; i < tableResult.length; i++) {
        String tableName = tableResult[i]['name'] as String;

        final columns = await db.rawQuery(
          'PRAGMA table_info("$tableName")',
        );

        final countResult = await db.rawQuery(
          'SELECT COUNT(*) FROM "$tableName"',
        );

        final rowCount = Sqflite.firstIntValue(countResult) ?? 0;

        tableList.add({
          'name': tableName,
          'columns': columns,
          'count': rowCount,
        });
      }

      if (!mounted) return;

      setState(() {
        tables = tableList;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading schema: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Schema'),
        actions: [
          IconButton(
            onPressed: loadSchema,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Schema',
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tables.isEmpty
              ? const Center(
                  child: Text('No tables found'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    final table = tables[index];

                    final String tableName = table['name'];
                    final List columns = table['columns'];
                    final int rowCount = table['count'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.table_chart,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    tableName,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Rows: $rowCount',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 25),

                            const Text(
                              'Columns',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            for (final column in columns)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        column['name'].toString(),
                                      ),
                                    ),
                                    Text(
                                      column['type'].toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
