import 'package:alfonso_po_t5/providers/watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final watchProvider = Provider.of<WatchProvider>(context);



    return Text('${watchProvider.watches}');
  }
}