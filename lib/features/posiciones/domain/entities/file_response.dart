class FileResponse 
{
  final String fileName;
  final String base64Content;
  final String contentType;

  FileResponse({
    required this.fileName, 
    required this.base64Content,
    required this.contentType
  });
  
}