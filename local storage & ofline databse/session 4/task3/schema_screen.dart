
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

  // Reset database and refresh screen
  Future<void> resetDatabase() async {
    try {
      await DatabaseHelper.instance.resetDatabase();

      if (!mounted) return;

      setState(() {
        schemaFuture = getDatabaseSchema();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database reset successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reset failed: $e'),
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
            tooltip: 'Reset database',
            icon: const Icon(Icons.restart_alt),
            onPressed: resetDatabase,
          ),
        ],
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
                      const SizedBox(height: 10),
                      Text(
                        'Rows: $rowCount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const Divider(height: 25),
                      ...columns.map((column) {
                        final columnName =
                            column['name'].toString();
                        final dataType =
                            column['type'].toString();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 7),
                              const SizedBox(width: 10),
                              Text('$columnName ($dataType)'),
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
