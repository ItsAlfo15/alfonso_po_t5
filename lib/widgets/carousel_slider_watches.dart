import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // <── Importamos la librería

class CarouselSliderWatches extends StatelessWidget {
  const CarouselSliderWatches({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista con los nombres de tus imágenes
    final List<String> sliderImages = [
      'rolex.png',
      'richard_mille.png',
      'audemars_piguet.png',
      'patek_philippe.png',
      'cartier.png',
    ];

    const String sliderImagesRoute = 'assets/slider/';
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.015),
        Container(
          height: size.width >= 600 ? size.height * 0.5 : 250, // Ajusta la altura del slider al 25% de la pantalla
          width: size.width >= 600 ? size.width * 0.95 : size.width * 0.9, // Ajusta el ancho del slider al 100% de la pantalla
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CarouselSlider(
              // 1. Mapeamos la lista de imágenes para crear los widgets correspondientes
              items: sliderImages.map((imageName) {
                return Image.asset(
                  '$sliderImagesRoute$imageName',
                  fit: BoxFit.cover,
                  width: size.width >= 600 ? size.width * 0.2 : size.width * 0.6, // Forzamos el ancho para que llene el contenedor
                );
              }).toList(),
        
              options: CarouselOptions(
                height: size.width >= 600 ? size.height * 0.45 : size.height * 0.3, // Ajusta la altura del slider al 25% de la pantalla
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(seconds: 1), // Duracion de la transicion
                autoPlayCurve: Curves.easeInOutQuart, // Curva de la animacion
                viewportFraction: 1.0,
                enlargeCenterPage: false, // Desactivado para que no haga efecto de lupa al cambiar
              ),
            ),
          ),
        ),
      ],
    );
  }
}