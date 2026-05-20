import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:alfonso_po_t5/providers/favorites_provider.dart';
import 'package:alfonso_po_t5/providers/watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class BrandWatchesPage extends StatefulWidget {
  const BrandWatchesPage({super.key});

  @override
  State<BrandWatchesPage> createState() => _BrandWatchesPageState();
}

class _BrandWatchesPageState extends State<BrandWatchesPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final watchProvider = context.watch<WatchProvider>();
    final String marca = ModalRoute.of(context)!.settings.arguments as String;

    final List<Reloj> relojesMarca = watchProvider.relojesPorMarca(marca).where(
      (r) {
        if (_search.isEmpty) return true;
        final q = _search.toLowerCase();
        return r.modelo.toLowerCase().contains(q) ||
            r.referencia.toLowerCase().contains(q) ||
            r.estado.tipo.toLowerCase().contains(q);
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(marca)),
      body: Column(
        children: [
          // Seacrch bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar modelo, referencia...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white38),
                        onPressed: () => setState(() => _search = ''),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1C1C1C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          if (_search.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 22, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${relojesMarca.length} resultado(s)',
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          // Listado de relojes
          Expanded(
            child: relojesMarca.isEmpty
                ? _EmptyList(isEmpty: _search.isEmpty)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: relojesMarca.length,
                    itemBuilder: (context, index) =>
                        _WatchCard(reloj: relojesMarca[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

// En caso de estar vacio
class _EmptyList extends StatelessWidget {
  final bool isEmpty;
  const _EmptyList({required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.watch_off, size: 60, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            isEmpty
                ? 'No hay relojes disponibles'
                : 'Sin resultados para esa búsqueda',
            style: const TextStyle(color: Colors.white54, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// Card para cada reloj en la lista
class _WatchCard extends StatelessWidget {
  final Reloj reloj;
  const _WatchCard({required this.reloj});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(reloj.id);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, 'watch_detail', arguments: reloj),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isFav
                  ? Colors.redAccent.withValues(alpha: 0.5)
                  : Colors.white10,
            ),
          ),
          child: Row(
            children: [
              // Imagen con Hero
              Hero(
                tag: 'watch_image_${reloj.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: 130,
                    child: reloj.imagenes.isNotEmpty
                        ? Image.network(
                            reloj.imagenes[0],
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.watch,
                              color: Color(0xFFD4AF37),
                              size: 48,
                            ),
                          )
                        : const Icon(
                            Icons.watch,
                            color: Color(0xFFD4AF37),
                            size: 48,
                          ),
                  ),
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        reloj.modelo,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      _Row(Icons.info_outline, reloj.estado.tipo),
                      _Row(Icons.euro, '${reloj.precio}€'),
                      _Row(
                        Icons.calendar_today_outlined,
                        reloj.anioFabricacion.toString(),
                      ),
                      RatingBarIndicator(
                        rating: reloj.valoracion,
                        itemBuilder: (_, __) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 16,
                        unratedColor: Colors.white24,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _HeartButton(
                      isFav: isFav,
                      onTap: () {
                        favProvider.toggleFavorite(reloj);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  isFav
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isFav
                                      ? 'Eliminado de favoritos'
                                      : 'Reloj guardado en favoritos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: isFav
                                ? Colors.grey[800]
                                : Colors.green[400],
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFD4AF37),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Row(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.white38),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Corazon animado para favoritos
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

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.7,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _ctrl.reverse();
    await _ctrl.forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _ctrl,
        child: Icon(
          widget.isFav ? Icons.favorite : Icons.favorite_border,
          color: widget.isFav ? Colors.redAccent : Colors.white38,
          size: 24,
        ),
      ),
    );
  }
}
