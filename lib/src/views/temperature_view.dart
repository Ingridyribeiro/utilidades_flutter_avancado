import 'package:flutter/material.dart';
import 'package:utilidades/src/controllers/temperature_controller.dart';
import 'package:utilidades/src/models/temperature_model.dart';

class TemperatureView extends StatelessWidget {
  const TemperatureView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TemperatureController();
    final mediaNotifier = ValueNotifier<double?>(null);
    final historico = <TemperatureModel>[];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<TemperatureModel>(
          future: controller.carregarInicial(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return StreamBuilder(
              stream: controller.atualizarClima(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  final atual = asyncSnapshot.data!;
                  historico.insert(0, atual);
                  if (historico.length > 10) {
                    historico.removeLast();
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Temperatura em tempo real:",
                      style: TextStyle(fontSize: 18),
                    ),
                       if (asyncSnapshot.hasData)
                      Text(
                        "${asyncSnapshot.data!.temperatura.toStringAsFixed(1)}°C",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 3, 3, 3),
                        ),
                      ),
                    if (!asyncSnapshot.hasData)
                      CircularProgressIndicator(
                        padding: const EdgeInsets.all(5),
                      ),
                    Divider(height: 32),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              historico.length < 10
                                  ? Colors.grey[300]
                                  : Colors.amber,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                        ),
                        onPressed: () async {
                          if (historico.length < 10) return;
                          final media = await controller.calcularMedia(
                            historico.take(10).toList(),
                          );
                          mediaNotifier.value = media;
                        },
                        child: Text(
                          "Calcular Média (últimos 10)",
                          style: TextStyle(
                            color:
                                historico.length < 10
                                    ? Colors.grey
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ValueListenableBuilder<double?>(
                        valueListenable: mediaNotifier,
                        builder: (context, valor, _) {
                          if (valor == null) return SizedBox();
                          return Text(
                            "- média: ${valor.toStringAsFixed(2)}°C -",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(221, 82, 82, 82),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}