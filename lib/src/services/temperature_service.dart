import 'dart:async';
import 'dart:isolate';
import 'dart:math';

class TemperatureService {
  final _rand = Random();

  Future<double> buscarTemperaturaInicial() async {
    await Future.delayed(const Duration(seconds: 2));
    return 15 + _rand.nextDouble() * 15;
  }

  Stream<double> gerarTemperaturas() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      yield 15 + _rand.nextDouble() * 15;
    }
  }

  static Future<double> calcularMedia(List<double> valores) async {
    final porta = ReceivePort();
    await Isolate.spawn(_execMedia, [porta.sendPort, valores]);
    return await porta.first as double;
  }

  static void _execMedia(List<dynamic> args) {
    SendPort send = args[0];
    List<double> dados = args[1];
    double media = dados.reduce((a, b) => a + b) / dados.length;
    send.send(media);
  }
}