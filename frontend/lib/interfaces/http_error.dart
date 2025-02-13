class HttpError {
  final String message;

  final Map<String, dynamic> errors;

  HttpError({
    this.message,
    this.errors,
  });

  factory HttpError.fromJson(Map<String, dynamic> json) => HttpError(
        message: json['message'],
        errors: json['errors'],
      );
}
