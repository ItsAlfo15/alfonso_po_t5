import 'package:flutter/material.dart';

class WatchBrands extends StatefulWidget {
  /// Si [shrinkWrap] es true el grid delega el scroll al ancestro (desktop).
  final bool shrinkWrap;

  const WatchBrands({super.key, this.shrinkWrap = false});

  @override
  State<WatchBrands> createState() => _WatchBrandsState();
}

class _WatchBrandsState extends State<WatchBrands>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, String>> brands = const [
    {'name': 'Rolex', 'image': 'assets/images/portada_rolex.png'},
    {'name': 'Richard Mille', 'image': 'assets/images/portada_richard_mille.png'},
    {'name': 'Audemars Piguet', 'image': 'assets/images/portada_audemars_piguet.png'},
    {'name': 'Patek Philippe', 'image': 'assets/images/portada_patek_philippe.png'},
    {'name': 'Cartier', 'image': 'assets/images/portada_cartier.png'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // En desktop el grid se muestra dentro de un SingleChildScrollView, asi que
  // el grid no gestiona su propio scroll (shrinkWrap=true) y el scroll lo
  // gestiona el SingleChildScrollView del padre. En movil el grid si gestiona
  int _crossAxisCount(double width) {
    if (width >= 600) return 3;
    return 2;
  }

  /// En pantallas anchas limitamos el ancho máximo del grid para que
  /// las tarjetas no queden gigantes aunque haya mucho espacio.
  double _maxGridWidth(double width) {
    if (width >= 1200) return 900;
    if (width >= 900) return 800;
    return double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = _crossAxisCount(width);
        final maxWidth = _maxGridWidth(width);

        // shrinkWrap=true → el grid mide lo que necesita y el scroll
        // lo gestiona el SingleChildScrollView del padre (desktop).
        // shrinkWrap=false → comportamiento normal con Expanded (móvil).
        final grid = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: GridView.builder(
              shrinkWrap: widget.shrinkWrap,
              physics: widget.shrinkWrap
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              itemCount: brands.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                final delay = index * 0.12;
                final animation = CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    delay.clamp(0.0, 1.0),
                    (delay + 0.5).clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                );
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: _BrandCard(brand: brands[index]),
                  ),
                );
              },
            ),
          ),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
              ),
              widget.shrinkWrap ? grid : Expanded(child: grid),
            ],
          ),
        );
      },
    );
  }
}

class _BrandCard extends StatefulWidget {
  final Map<String, String> brand;
  const _BrandCard({required this.brand});

  @override
  State<_BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<_BrandCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.reverse(),
      onTapUp: (_) {
        _pressController.forward();
        Navigator.pushNamed(
          context,
          'brand_watches',
          arguments: widget.brand['name'],
        );
      },
      onTapCancel: () => _pressController.forward(),
      child: ScaleTransition(
        scale: _pressController,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4AF37),
                        borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(
                          widget.brand['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.watch,
                            color: Colors.black54,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.brand['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
