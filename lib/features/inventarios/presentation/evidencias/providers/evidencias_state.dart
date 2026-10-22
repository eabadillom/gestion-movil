import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';

class EvidenciasState 
{
  final List<FotoAdjunta> fotos;
  final int tamanoTotalBytes;
  final int tamanoEnvioEstimadoBytes;
  final int limiteEnvioBytes;
  final bool excedeLimite;
  final bool isLoading;
  final bool isEnviando;
  final String? errorMessage;
  final RespuestaResponse respuestaResponse;

  const EvidenciasState({
    this.fotos = const [],
    this.tamanoTotalBytes = 0,
    this.tamanoEnvioEstimadoBytes = 0,
    this.limiteEnvioBytes = 0,
    this.excedeLimite = false,
    this.isLoading = false,
    this.isEnviando = false,
    this.errorMessage,
    this.respuestaResponse = const RespuestaResponse(respuesta: '', exito: false),
  });

  EvidenciasState copyWith({
    List<FotoAdjunta>? fotos,
    int? tamanoTotalBytes,
    int? tamanoEnvioEstimadoBytes,
    int? limiteEnvioBytes,
    bool? excedeLimite,
    bool? isLoading,
    bool? isEnviando,
    String? errorMessage,
    bool limpiarError = false,
    RespuestaResponse? respuestaResponse,
  }) {
    return EvidenciasState(
      fotos: fotos ?? this.fotos,
      tamanoTotalBytes: tamanoTotalBytes ?? this.tamanoTotalBytes,
      tamanoEnvioEstimadoBytes: tamanoEnvioEstimadoBytes ?? this.tamanoEnvioEstimadoBytes,
      limiteEnvioBytes: limiteEnvioBytes ?? this.limiteEnvioBytes,
      excedeLimite: excedeLimite ?? this.excedeLimite,
      isLoading: isLoading ?? this.isLoading,
      isEnviando: isEnviando ?? this.isEnviando,
      errorMessage: limpiarError ? null : errorMessage ?? this.errorMessage,
      respuestaResponse: respuestaResponse ?? this.respuestaResponse,
    );
  }

}
