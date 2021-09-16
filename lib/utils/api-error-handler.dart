Exception apiErrorHandler(String title, dynamic message) {
  String error;
  try {
    // pick the first error message if it is an array
    List<dynamic> errors = message as List<dynamic>;
    error = errors[0];
  } catch (e) {
    // not an array
    error = message as String;
  }

  return Exception("$title. $error");
}
