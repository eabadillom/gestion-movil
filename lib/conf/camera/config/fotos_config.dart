class FotosConfig 
{
  final int maxWidth;
  final int maxHeight;
  final int calidad;
  final int? maxBytes;

  const FotosConfig({
    this.maxWidth = 1920,
    this.maxHeight = 1080,
    this.calidad = 80,
    this.maxBytes,
  });
  
}
