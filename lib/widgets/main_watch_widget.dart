import 'package:flutter/material.dart';

class MainWatch extends StatelessWidget {
  const MainWatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 220,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/images/home_page_watch.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}