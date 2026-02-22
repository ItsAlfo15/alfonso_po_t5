import 'package:flutter/material.dart';

class WatchBrands extends StatelessWidget {
  const WatchBrands({super.key});

  @override
  Widget build(BuildContext context) {

    final brands = [
      {
        "name": "Rolex",
        "image": "assets/images/portada_rolex.png"
      },
      {
        "name": "Richard Mille",
        "image": "assets/images/portada_richard_mille.png"
      },
      {
        "name": "Audemars Piguet",
        "image": "assets/images/portada_audemars_piguet.png"
      },
      {
        "name": "Patek Philippe",
        "image": "assets/images/portada_patek_philippe.png"
      },
      {
        "name": "Cartier",
        "image": "assets/images/portada_cartier.png"
      }
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(), // Scroll suave
        itemCount: brands.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columnas
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.80,
        ),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'brand_watches',
                arguments: brand["name"],
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 54, 54, 54),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.asset(
                        brand["image"]!,
                        fit: BoxFit.cover,
                        width: double.infinity ,
                      ),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                          brand["name"]!,
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
          );
        },
      ),
    );
  }
}