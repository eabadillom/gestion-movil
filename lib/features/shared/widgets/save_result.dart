class SaveResult 
{
  final bool success;
  final String? path;
  final String? error;

  const SaveResult({
    required this.success,
    this.path,
    this.error,
  });

  factory SaveResult.ok(String path) {
    return SaveResult(
      success: true,
      path: path,
    );
  }

  factory SaveResult.fail(String error) {
    return SaveResult(
      success: false,
      error: error,
    );
  }
}
