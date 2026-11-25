
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database/database_helper.dart';

class SchemaScreen extends StatefulWidget {
  const SchemaScreen({super.key});

  @override
  State<SchemaScreen> createState() => _SchemaScreenState();
}

class _SchemaScreenState extends State<SchemaScreen> {
  late Future<List<Map<String, dynamic>>> schemaFuture;

  @override
  void initState() {
    super.initState();
    schemaFuture = getDatabaseSchema();
  }

  Future<List<Map<String, dynamic>>> getDatabaseSchema() async {
    final db = await DatabaseHelper.instance.database;

    final tables = await db.rawQuery('''
      SELECT name
      FROM sqlite_master
      WHERE type = 'table'
      AND name NOT LIKE 'sqlite_%'
      ORDER BY name
    ''');

    List<Map<String, dynamic>> schema = [];

    for (final table in tables) {
      final String tableName = table['name'] as String;

      final columns = await db.rawQuery(
        'PRAGMA table_info("$tableName")',
      );

      final rowCount = Sqflite.firstIntValue(
            await db.rawQuery(
              'SELECT COUNT(*) FROM "$tableName"',
            ),
          ) ??
          0;

      schema.add({
        'tableName': tableName,
        'columns': columns,
        'rowCount': rowCount,
      });
    }

    return schema;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Schema'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: schemaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final tables = snapshot.data ?? [];

          if (tables.isEmpty) {
            return const Center(
              child: Text('No tables found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final table = tables[index];

              final String tableName = table['tableName'];
              final List columns = table['columns'];
              final int rowCount = table['rowCount'];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tableName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Rows: $rowCount'),
                      const Divider(),
                      ...columns.map((column) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Text(
                            '${column['name']} (${column['type']})',
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
