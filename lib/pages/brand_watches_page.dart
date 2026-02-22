import 'package:alfonso_po_t5/models/watch_model_response.dart';
import 'package:alfonso_po_t5/providers/watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandWatchesPage extends StatelessWidget {
  const BrandWatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final watchProvider = Provider.of<WatchProvider>(context);

    // Recibimos la marca seleccionada
    final String marca = ModalRoute.of(context)!.settings.arguments as String;

    // Filtramos relojes en memoria
    final List<Reloj> relojesPorMarca = watchProvider.relojesPorMarca(marca);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          marca,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF111111),
        centerTitle: true,
      ),
      body: relojesPorMarca.isEmpty
          ? const Center(
              child: Text(
                'No hay relojes disponibles',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: relojesPorMarca.length,
              itemBuilder: (context, index) {
                final reloj = relojesPorMarca[index];
                return Card(
                  color: const Color(0xFF1C1C1C),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        reloj.imagenes[0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      reloj.modelo,
                      style: const TextStyle(
                          color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Año: ${reloj.anioFabricacion}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      // Aquí puedes navegar al detalle del reloj
                    },
                  ),
                );
              },
            ),
    );
  }
}