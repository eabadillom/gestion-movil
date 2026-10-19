import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/inventarios/domain/domain.dart';
import 'package:gestion_movil/features/inventarios/presentation/evidencias/providers/evidencias_repository_provider.dart';
import 'package:gestion_movil/features/inventarios/presentation/evidencias/providers/evidencias_state.dart';
import 'package:gestion_movil/features/inventarios/services/evidencias_services.dart';

typedef EvidenciasParams = ({TipoConstancia tipo, int id, String numEmpleado});

final evidenciasProvider = StateNotifierProvider.autoDispose.family<EvidenciasNotifier, EvidenciasState, EvidenciasParams>((ref, params) 
{
  ref.keepAlive();
  final fotosRepository = ref.watch(evidenciasRepositoryProvider);

  return EvidenciasNotifier(CameraService(), FotoCompressor(), fotosRepository, params);
});

class EvidenciasNotifier extends StateNotifier<EvidenciasState>
{
  final LoggerSingleton log = LoggerSingleton.getInstance('EvidenciasNotifier');
  final CameraService _cameraService;
  final FotoCompressor _fotoCompressor;
  final ConstanciaRepository _evidenciasDatasource;
  final EvidenciasParams params;
  bool _enviando = false;
  int incremento = 1;

  static const FotosConfig _config = FotosConfig(maxWidth: 1920, maxHeight: 1080, calidad: 80);
  static const int _limiteCorreoBytes = 25 * 1024 * 1024;
  static const double _porcentajeSeguro = 0.80;
  static final int _limiteEnvioBytes = (_limiteCorreoBytes * _porcentajeSeguro).round();

  EvidenciasNotifier(this._cameraService, this._fotoCompressor, this._evidenciasDatasource, this.params) : super(EvidenciasState(limiteEnvioBytes: _limiteEnvioBytes));

  Future<void> tomarFoto(String folio) async 
  {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try{
    final File? archivo = await _cameraService.tomarFoto(folio, incremento);

    incremento++;

    if (archivo == null) {
      return;
    }

    _agregarFoto(archivo);
    }catch (e, stackTrace) {
      log.logger.severe('Error al tomar la fotografía', e, stackTrace);

      state = state.copyWith(
        errorMessage: 'No fue posible tomar la fotografía.',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> seleccionarDeGaleria() async 
  {
    final File? archivo = await _cameraService.seleccionarDeGaleria();

    if (archivo == null) {
      return;
    }

    _agregarFoto(archivo);
  }

  Future<void> _agregarFoto(File archivo) async 
  {
    final FotoAdjunta foto = FotoAdjuntaFactory.crear(archivo);

    final List<FotoAdjunta> fotos = [
      ...state.fotos,
      foto,
    ];

    state = state.copyWith(
      fotos: [
        ...state.fotos,
        foto,
      ],
      errorMessage: null,
    );


    await _actualizarTamano(fotos);
  }

  Future<void> eliminarFoto(int index) async 
  {
    if (index < 0 || index >= state.fotos.length) {
      return;
    }

    final fotos = [...state.fotos];

    fotos.removeAt(index);

    state = state.copyWith(
      fotos: fotos,
      errorMessage: null,
    );


    await _actualizarTamano(fotos);
  }

  Future<void> renombrarFoto(int index, String nuevoNombre) async 
  {
    if (index < 0 || index >= state.fotos.length) {
      return;
    }

    final nombre = nuevoNombre.trim();

    if (nombre.isEmpty) {
      return;
    }

    final fotos = [...state.fotos];

    fotos[index] = fotos[index].copyWith(
      nombre: nombre,
    );

    state = state.copyWith(
      fotos: fotos,
      errorMessage: null,
    );
  }

  Future<void> comprimirFoto(int index) async 
  {
    log.setupLoggin();

    if (index < 0 || index >= state.fotos.length) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final FotoAdjunta foto = state.fotos[index];

      final FotoAdjunta? fotoComprimida = await _fotoCompressor.comprimir(foto, _config);

      if (fotoComprimida == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No fue posible comprimir la fotografía.',
        );
        return;
      }

      final List<FotoAdjunta> fotos = [
        ...state.fotos,
      ];

      fotos[index] = fotoComprimida;

      state = state.copyWith(
        fotos: fotos,
        isLoading: false,
        errorMessage: null,
      );

      await _actualizarTamano(fotos);
    } catch (e) {
      log.logger.severe('Error al comprimir fotografía', e);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No fue posible comprimir la fotografía.',
      );
    }
  }

  Future<void> comprimirFotos() async 
  {
    if (state.fotos.isEmpty) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final List<FotoAdjunta> fotosComprimidas = await _fotoCompressor.comprimirTodas(fotos: state.fotos, config: _config);

      state = state.copyWith(
        fotos: fotosComprimidas,
        isLoading: false,
        errorMessage: null,
      );

      await _actualizarTamano(fotosComprimidas);
    } catch (e) {
      log.setupLoggin();
      log.logger.severe('Error al comprimir fotografías', e);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No fue posible comprimir las fotografías.',
      );
    }
  }

  Future<List<FotoEnvio>> prepararFotosParaCorreo() async 
  {
    if (state.fotos.isEmpty) {
      state = state.copyWith(
        errorMessage: 'No hay fotografías para preparar.',
      );

      return [];
    }

    if (state.excedeLimite) {
      state = state.copyWith(
        errorMessage: 'El tamaño estimado del envío excede el límite permitido.',
      );

      return [];
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      log.logger.info('Preparando ${state.fotos.length} fotografías');

      final resultado = await EvidenciasServices(fotoCompressor: _fotoCompressor).prepararFotosParaCorreo(state.fotos);

      state = state.copyWith(
        isLoading: false,
      );

      return resultado;
    } catch (e) {
      log.setupLoggin();

      log.logger.severe('Error al preparar fotografías', e);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No fue posible preparar las fotografías.',
      );

      return [];
    }
  }

  Future<void> _actualizarTamano(List<FotoAdjunta> fotos) async 
  {
    int totalBytes = 0;

    for (final FotoAdjunta foto in fotos) {
      if (await foto.archivo.exists()) {
        totalBytes += await foto.archivo.length();
      }
    }

    final int tamanoEnvio = _estimarTamanoBase64(totalBytes);

    state = state.copyWith(
      tamanoTotalBytes: totalBytes,
      tamanoEnvioEstimadoBytes: tamanoEnvio,
      excedeLimite: tamanoEnvio > state.limiteEnvioBytes,
    );
  }
  
  int _estimarTamanoBase64(int bytes) 
  {
    return ((bytes * 4) / 3).ceil();
  }

  void limpiarFotos() 
  {
    state = EvidenciasState(
      limiteEnvioBytes: _limiteEnvioBytes,
    );
  }

  bool existeNombreFoto(String nombre, {int? excluirIndex}) 
  {
    final nombreNormalizado = nombre.trim().toLowerCase();

    return state.fotos.asMap().entries.any((entry) 
    {
      if (entry.key == excluirIndex) {
        return false;
      }

      final nombreExistente = entry.value.nombre.trim().toLowerCase();

      return nombreExistente == nombreNormalizado;
    });
  }

  Future<void> enviarFotos() async 
  {
    if (_enviando || state.isLoading || state.respuestaResponse.exito) {
      return;
    }


    if (state.fotos.isEmpty) {
      state = state.copyWith(
        errorMessage: 'No hay fotografías para enviar.',
      );
      
      return;
    }

    if (state.excedeLimite) {
      state = state.copyWith(
        errorMessage: 'El tamaño de las fotografías excede el límite permitido.',
      );

      return;
    }

    _enviando = true;

    state = state.copyWith(
      isEnviando: true,
      isLoading: true,
      limpiarError: true,
    );

    try 
    {
      final fotosEnvio = await prepararFotosParaCorreo();

      if (fotosEnvio.isEmpty) {
        return;
      }

      final respuesta = await _evidenciasDatasource.enviarEvidencia(params.tipo, params.id, fotosEnvio, params.numEmpleado);

      switch(respuesta) 
      {
        case Success():
          state = state.copyWith(isLoading: false, respuestaResponse: respuesta.data, limpiarError: respuesta.data.exito,  errorMessage: respuesta.data.exito ? null : respuesta.data.respuesta);
        case Error():
          log.logger.warning(respuesta.customError.message);
          state = state.copyWith(isLoading: false, errorMessage: respuesta.customError.message);
      }
    } catch (e, stackTrace) 
    {
      log.logger.severe('Error al enviar fotografías', e, stackTrace);

      state = state.copyWith(
        errorMessage: 'Ocurrió un error al enviar las fotografías.',
      );
    } finally {
      _enviando = false;

      state = state.copyWith(
        isEnviando: false,
        isLoading: false
      );
    }

  }

}
