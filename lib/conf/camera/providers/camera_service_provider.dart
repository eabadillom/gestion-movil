import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_movil/conf/config.dart';

final cameraServiceProvider = Provider<CameraService>((ref) 
{
  return CameraService();
});