
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SchemaScreen extends StatefulWidget {
  final Database database;

  const SchemaScreen({
    super.key,
    required this.database,
  });

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
    // Get all user-created table names
    final tables = await widget.database.rawQuery('''
      SELECT name
      FROM sqlite_master
      WHERE type = 'table'
      AND name NOT LIKE 'sqlite_%'
      ORDER BY name
    ''');

    List<Map<String, dynamic>> schema = [];

    // Get columns for every table
    for (final table in tables) {
      final String tableName = table['name'] as String;

      // Get table columns dynamically
      final columns = await widget.database.rawQuery(
        'PRAGMA table_info("$tableName")',
      );

      schema.add({
        'tableName': tableName,
        'columns': columns,
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

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,

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

                          Text(
                            tableName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 25),

                      // Display columns dynamically
                      ...columns.map((column) {
                        final String columnName =
                            column['name'].toString();

                        final String dataType =
                            column['type'].toString();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 7,
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  '$columnName ($dataType)',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
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
