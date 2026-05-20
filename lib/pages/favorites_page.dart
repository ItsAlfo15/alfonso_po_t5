import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:alfonso_po_t5/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final favorites = favProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              tooltip: 'Borrar todos',
              icon: const Icon(Icons.delete_sweep_outlined,
                  color: Colors.redAccent),
              onPressed: () => _confirmClear(context, favProvider),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? _EmptyFavorites()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return _FavoriteCard(reloj: favorites[index]);
              },
            ),
    );
  }

  void _confirmClear(BuildContext context, FavoritesProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text('¿Borrar favoritos?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Se eliminarán todos los relojes guardados.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            child: const Text('Borrar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

// En caso de no tener favoritos
class _EmptyFavorites extends StatefulWidget {
  @override
  State<_EmptyFavorites> createState() => _EmptyFavoritesState();
}

class _EmptyFavoritesState extends State<_EmptyFavorites>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1C1C1C),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Icon(
                  Icons.favorite_border,
                  size: 52,
                  color: Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sin favoritos todavía',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Toca el corazón en un reloj\npara guardarlo aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tarjeta de reloj favorito
class _FavoriteCard extends StatelessWidget {
  final Reloj reloj;
  const _FavoriteCard({required this.reloj});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.read<FavoritesProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, 'watch_detail', arguments: reloj),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              // Imagen con Hero
              Hero(
                tag: 'watch_image_${reloj.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(16)),
                  child: SizedBox(
                    width: 100,
                    child: reloj.imagenes.isNotEmpty
                        ? Image.network(
                            reloj.imagenes[0],
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.watch,
                              color: Color(0xFFD4AF37),
                            ),
                          )
                        : const Icon(
                            Icons.watch,
                            color: Color(0xFFD4AF37),
                          ),
                  ),
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        reloj.marca.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        reloj.modelo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${reloj.precio}€ · ${reloj.anioFabricacion}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              // Quitar favorito
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _HeartButton(
                  isFav: true,
                  onTap: () => favProvider.toggleFavorite(reloj),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Boton para favoritos
class _HeartButton extends StatefulWidget {
  final bool isFav;
  final VoidCallback onTap;
  const _HeartButton({required this.isFav, required this.onTap});

  @override
  State<_HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<_HeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.75,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _animate() async {
    await _ctrl.reverse();
    await _ctrl.forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animate,
      child: ScaleTransition(
        scale: _scale,
        child: Icon(
          widget.isFav ? Icons.favorite : Icons.favorite_border,
          color: widget.isFav ? Colors.redAccent : Colors.white38,
          size: 26,
        ),
      ),
    );
  }
}
