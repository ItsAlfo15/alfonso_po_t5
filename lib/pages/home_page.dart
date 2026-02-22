import 'dart:math';

import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:alfonso_po_t5/providers/watch_provider.dart';
import 'package:alfonso_po_t5/widgets/background_widget.dart';
import 'package:alfonso_po_t5/widgets/main_watch_widget.dart';
import 'package:alfonso_po_t5/widgets/watch_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginFormProvider>(context);

    if (loginProvider.currentUser == null) {
      loginProvider.loadUserFromStorage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Luxury Collection',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37),
          ),
        ),
        backgroundColor: const Color(0xFF111111),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.black),
                accountName: Text(
                  loginProvider.currentUser?['name'] ?? 'Usuario',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  loginProvider.currentUser?['email'] ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.amber,
                  foregroundImage: NetworkImage(
                    loginProvider.currentUser?['image'] ??
                        'https://ui-avatars.com/api/?name=User&background=FFC107&color=000',
                  ),
                ),
              ),
              const Spacer(),

              ListTile(
                leading: const Icon(Icons.logout_outlined, color: Colors.red),
                title: Text('Cerrar sesión'),
                onTap: () async {
                  await loginProvider.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      'login',
                      (_) => false,
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Luxury Watch Catalog v1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: const [
          SizedBox(height: 30),
          MainWatch(),
          SizedBox(height: 40),
          Expanded(child: WatchBrands()),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
