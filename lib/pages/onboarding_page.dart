import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  final List<_OnboardingData> _slides = const [
    _OnboardingData(
      logo: 'assets/images/logo.png',
      title: 'Bienvenido a LuxWatch',
      subtitle:
          'Tu catálogo de referencia para los relojes de lujo más exclusivos del mundo.',
      gradient: [Color(0xFF1C1C1C), Color(0xFF0F0F0F)],
    ),
    _OnboardingData(
      icon: Icons.diamond_outlined,
      title: 'Marcas Premium',
      subtitle:
          'Explora colecciones de Rolex, Patek Philippe, Audemars Piguet, Cartier y Richard Mille.',
      gradient: [Color(0xFF1A1500), Color(0xFF0F0F0F)],
    ),
    _OnboardingData(
      icon: Icons.share_outlined,
      title: 'Comparte lo que Amas',
      subtitle:
          'Guarda tus relojes favoritos, compártelos por WhatsApp y descubre tu próxima pieza.',
      gradient: [Color(0xFF001A0A), Color(0xFF0F0F0F)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );
    _iconController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _iconController.reset();
    _iconController.forward();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (mounted) Navigator.pushReplacementNamed(context, 'login');
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            // Botón omitir
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Omitir',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _OnboardingSlide(
                    data: _slides[index],
                    iconAnimation: _iconAnimation,
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),

            // Indicadores (dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == i ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? const Color(0xFFD4AF37)
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botón siguiente / empezar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? '¡Empezar!'
                        : 'Siguiente',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String? logo;
  final IconData? icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _OnboardingData({
    this.logo,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingData data;
  final Animation<double> iconAnimation;
  final bool isActive;

  const _OnboardingSlide({
    required this.data,
    required this.iconAnimation,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono con animacion de escala
          ScaleTransition(
            scale: iconAnimation,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD4AF37).withAlpha(38),
                    const Color(0xFFD4AF37).withAlpha(13),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withAlpha(0x66),
                  width: 2,
                ),
              ),
              child: Center(
                child: data.logo == null
                  ? Icon(data.icon, color: const Color(0xFFD4AF37), size: 64)
                  : Image.asset(data.logo!, width: 130, height: 130),
              )
            ),
          ),

          const SizedBox(height: 48),

          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white60,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}