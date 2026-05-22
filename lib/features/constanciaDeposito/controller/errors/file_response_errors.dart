class FileResponseErrors implements Exception 
{
  final String message;

  // final int errorCode;
  FileResponseErrors(this.message);
}