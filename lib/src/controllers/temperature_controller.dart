import 'package:utilidades/src/models/temperature_model.dart';
import 'package:utilidades/src/services/temperature_service.dart';

class TemperatureController {
  final _servico = TemperatureService();

  Future<TemperatureModel> carregarInicial() async {
    final valor = await _servico.buscarTemperaturaInicial();
    return TemperatureModel(valor);
  }

  Stream<TemperatureModel> atualizarClima() {
    return _servico.gerarTemperaturas().map((t) => TemperatureModel(t));
  }

  Future<double> calcularMedia(List<TemperatureModel> dados) async {
    final temp = dados.map((e) => e.temperatura).toList();
    return await TemperatureService.calcularMedia(temp);
  }
}