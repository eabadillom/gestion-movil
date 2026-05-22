import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/constanciaDeposito/domain/domain.dart';
import 'package:gestion_movil/features/constanciaDeposito/presentation/providers/providers.dart';

final kardexPdfResponseProvider = StateNotifierProvider.autoDispose<KardexResponseNotifier, KardexResponseState>((ref) 
{
  final repository = ref.watch(kardexPdfProvider);
  
  return KardexResponseNotifier(repository);
});

class KardexResponseNotifier extends StateNotifier<KardexResponseState>
{
  final PdfRepository repository;
  final LoggerSingleton log = LoggerSingleton.getInstance('KardexResponseNotifier');

  KardexResponseNotifier(this.repository) : super(KardexResponseState.initial());

  Future<void> generarReportePDF(String folioCliente) async 
  {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final fileResponse = await repository.getKardexPDF(folioCliente);

      state = state.copyWith(isLoading: false, fileResponse: fileResponse);
    } catch (e) {
      log.logger.warning(e.toString());
      
      state = state.copyWith(isLoading: false, errorMessage: 'Hubo un problema al cargar el archivo');
    }
  }
}

class KardexResponseState 
{
  final bool isLoading;
  final FileResponse? fileResponse;
  final String? errorMessage;

  KardexResponseState({
    this.isLoading = false,
    this.fileResponse,
    this.errorMessage,
  });

  factory KardexResponseState.initial() => KardexResponseState();

  KardexResponseState copyWith({
    bool? isLoading,
    FileResponse? fileResponse,
    String? errorMessage,
  }) => KardexResponseState(
    isLoading: isLoading ?? this.isLoading,
    fileResponse: fileResponse ?? this.fileResponse,
    errorMessage: errorMessage ?? this.errorMessage,
  );
  
}
