import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:alfonso_po_t5/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchDetailPage extends StatefulWidget {
  const WatchDetailPage({super.key});

  @override
  State<WatchDetailPage> createState() => _WatchDetailPageState();
}

class _WatchDetailPageState extends State<WatchDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _shareWhatsApp(Reloj reloj) async {
    setState(() => _isSharing = true);
    try {
      final text = '=== ${reloj.marca} ${reloj.modelo} ===\n'
          '\nAño de fabricación: ${reloj.anioFabricacion}\n'
          'Precio: ${reloj.precio}€\n'
          'Valoración: ${reloj.valoracion}/5\n'
          'Número de referencia: ${reloj.referencia}\n\n'
          'Descripción: ${reloj.descripcionResumida}\n\n'
          '=== Compartido desde LuxWatch Catalog ===';

      final whatsappUri =
          Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        await SharePlus.instance.share(
            ShareParams(text: text, subject: '${reloj.marca} ${reloj.modelo}'));
      }
    } catch (_) {
      await SharePlus.instance.share(
          ShareParams(text: '${reloj.marca} ${reloj.modelo} - ${reloj.precio}€'));
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reloj = ModalRoute.of(context)!.settings.arguments as Reloj;
    final favProvider = context.watch<FavoritesProvider>();
    final isFav = favProvider.isFavorite(reloj.id);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: CustomScrollView(
        slivers: [
          // App bar con Hero
          SliverAppBar(
            expandedHeight: size.height * 0.40,
            pinned: true,
            backgroundColor: const Color(0xFF111111),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Color(0xFFD4AF37)),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                tooltip: 'Compartir por WhatsApp',
                icon: _isSharing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFD4AF37),
                        ),
                      )
                    : const Icon(Icons.share_outlined,
                        color: Color(0xFFD4AF37)),
                onPressed: _isSharing ? null : () => _shareWhatsApp(reloj),
              ),
              _AnimatedFavButton(
                isFav: isFav,
                onTap: () {
                  favProvider.toggleFavorite(reloj);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(children: [
                        Icon(
                          isFav
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(isFav
                            ? 'Eliminado de favoritos'
                            : 'Reloj guardado en favoritos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
                      ]),
                      backgroundColor: isFav
                          ? Colors.grey[800]
                          : Colors.green[400],
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'watch_image_${reloj.id}',
                child: Container(
                  color: const Color(0xFF1A1A1A),
                  child: reloj.imagenes.isNotEmpty
                      ? Image.network(
                          reloj.imagenes[0],
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.watch,
                            size: 80,
                            color: Color(0xFFD4AF37),
                          ),
                        )
                      : const Icon(Icons.watch,
                          size: 80, color: Color(0xFFD4AF37)),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Marca y modelo
                      Text(
                        reloj.marca.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reloj.modelo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ref. ${reloj.referencia}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12),
                      ),
                      const SizedBox(height: 20),

                      // Precio y estrellas
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${reloj.precio}€',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < reloj.valoracion
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: Colors.amber,
                                size: 22,
                              );
                            }),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            reloj.valoracion.toStringAsFixed(1),
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 13),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 28),

                      _SectionTitle('Descripción'),
                      
                      const SizedBox(height: 10),
                      Text(
                        reloj.descripcion,
                        style: const TextStyle(
                            color: Colors.white70, height: 1.65, fontSize: 14),
                      ),
                      const SizedBox(height: 28),

                      _SectionTitle('Información General'),
                      const SizedBox(height: 14),
                      _InfoGrid([
                        _IC('Estado', reloj.estado.tipo),
                        _IC('Año', reloj.anioFabricacion.toString()),
                        _IC('Categoría', reloj.informacionGeneral.categoria),
                        _IC('Género', reloj.informacionGeneral.genero),
                        _IC('Con caja', reloj.tieneCaja ? 'Sí' : 'No'),
                        _IC('Papeles', reloj.tienePapeles ? 'Sí' : 'No'),
                        _IC('Disponible', reloj.disponibilidad ? 'Sí' : 'No'),
                      ]),
                      const SizedBox(height: 28),

                      _SectionTitle('Caja'),
                      const SizedBox(height: 14),
                      _InfoGrid([
                        _IC('Material', reloj.caja.material),
                        _IC('Diámetro', '${reloj.caja.diametro}mm'),
                        _IC('Bisel', reloj.caja.materialBisel),
                        _IC('Cristal', reloj.caja.cristal),
                        _IC('Esfera', reloj.caja.esfera),
                        _IC('Agua', reloj.caja.resistenciaAgua ?? '-'),
                      ]),
                      const SizedBox(height: 28),

                      _SectionTitle('Calibre'),
                      const SizedBox(height: 14),
                      _InfoGrid([
                        _IC('Tipo', reloj.calibre.tipoCalibre),
                        _IC('Código', reloj.calibre.codCalibre ?? '-'),
                        _IC('Reserva', '${reloj.calibre.reservaMarcha}h'),
                      ]),
                      const SizedBox(height: 28),

                      _SectionTitle('Pulsera'),
                      const SizedBox(height: 14),
                      _InfoGrid([
                        _IC('Material', reloj.pulsera.materialPulsera),
                        _IC('Color', reloj.pulsera.color),
                        _IC('Cierre', reloj.pulsera.cierre),
                        _IC('Mat. cierre', reloj.pulsera.materialCierre),
                      ]),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Favoritos
class _AnimatedFavButton extends StatefulWidget {
  final bool isFav;
  final VoidCallback onTap;
  const _AnimatedFavButton({required this.isFav, required this.onTap});

  @override
  State<_AnimatedFavButton> createState() => _AnimatedFavButtonState();
}

class _AnimatedFavButtonState extends State<_AnimatedFavButton>
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: ScaleTransition(
          scale: _ctrl,
          child: Icon(
            widget.isFav ? Icons.favorite : Icons.favorite_border,
            color:
                widget.isFav ? Colors.redAccent : const Color(0xFFD4AF37),
            size: 26,
          ),
        ),
      ),
    );
  }
}

// Widgets
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _IC {
  final String label;
  final String value;
  const _IC(this.label, this.value);
}

class _InfoGrid extends StatelessWidget {
  final List<_IC> items;
  const _InfoGrid(this.items);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items
          .map((item) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.label,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        )),
                    const SizedBox(height: 3),
                    Text(item.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
