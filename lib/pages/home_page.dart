import 'package:alfonso_po_t5/providers/watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final watchProvider = Provider.of<WatchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Relojes de alta gama', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: watchProvider.watches.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(watchProvider.watches[index].modelo),
            subtitle: Text('Total de relojes: ${watchProvider.watches.length}'),
          );
        },

      ),
    );
  }
}