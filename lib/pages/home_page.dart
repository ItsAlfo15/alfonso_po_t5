import 'package:alfonso_po_t5/providers/favorites_provider.dart';
import 'package:alfonso_po_t5/providers/login_form_provider.dart';
import 'package:alfonso_po_t5/widgets/carousel_slider_watches.dart';
import 'package:alfonso_po_t5/widgets/watch_brands.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginFormProvider>(context);
    final favProvider = context.watch<FavoritesProvider>();

    if (loginProvider.currentUser == null) {
      loginProvider.loadUserFromStorage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Luxury Collection'),
        backgroundColor: const Color(0xFF111111),
        centerTitle: true,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Favoritos',
                icon: const Icon(Icons.favorite_border,
                    color: Color(0xFFD4AF37)),
                onPressed: () => Navigator.pushNamed(context, 'favorites'),
              ),
              if (favProvider.favorites.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${favProvider.favorites.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: _AppDrawer(
        loginProvider: loginProvider,
        favCount: favProvider.favorites.length,
      ),

      // LayoutBuilder para saber el ancho disponible y elegir layout
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 600;

          // En web el scroll es de toda la pagina
          if (isDesktop) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CarouselSliderWatches(),
                  const SizedBox(height: 24),
                  const Text(
                    'Nuestras marcas disponibles',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Divider(
                    color: Color(0xFFD4AF37),
                    thickness: 1,
                    indent: 40,
                    endIndent: 40,
                  ),
                  const SizedBox(height: 8),
                  // shrinkWrap=true, el grid mide su contenido
                  // y delega el scroll al SingleChildScrollView
                  const WatchBrands(shrinkWrap: true),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          // En movil es el grid el que scrollea, no toda la pagina
          return Column(
            children: [
              const SizedBox(height: 20),
              const CarouselSliderWatches(),
              const SizedBox(height: 24),
              const Text(
                'Nuestras marcas disponibles',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Divider(
                color: Color(0xFFD4AF37),
                thickness: 1,
                indent: 40,
                endIndent: 40,
              ),
              const Expanded(child: WatchBrands()),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final LoginFormProvider loginProvider;
  final int favCount;

  const _AppDrawer({required this.loginProvider, required this.favCount});

  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFD4AF37), width: 1),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.015),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      foregroundImage: NetworkImage(
                        loginProvider.currentUser?['avatar'] ??
                            'https://www.gravatar.com/avatar/placeholder?d=mp&s=200',
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      loginProvider.currentUser?['name'] ?? 'Usuario',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        loginProvider.currentUser?['email'] ?? '',
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.watch_outlined,
                  color: Color(0xFFD4AF37)),
              title: const Text('Catálogo',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Badge(
                isLabelVisible: favCount > 0,
                label: Text('$favCount'),
                backgroundColor: Colors.redAccent,
                child: const Icon(Icons.favorite_outline,
                    color: Color(0xFFD4AF37)),
              ),
              title: const Text('Favoritos',
                  style: TextStyle(color: Colors.white)),
              trailing: favCount > 0
                  ? Text(
                      '$favCount guardado${favCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 11),
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'favorites');
              },
            ),
            const Divider(color: Colors.white12),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout_outlined,
                  color: Colors.redAccent),
              title: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                await loginProvider.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'login', (_) => false);
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'LuxWatch © 2026',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
