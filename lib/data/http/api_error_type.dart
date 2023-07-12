enum ApiErrorType {
  incorrectPassword(21),
  notFound(103),
  missingParams("E_MISSING_OR_INVALID_PARAMS"),
  tokenExpired(403),
  unknown("unknown");

  final dynamic code;

  const ApiErrorType(this.code);

  static ApiErrorType getByCode(final String code) {
    return ApiErrorType.values.firstWhere((element) => element.code == code,
        orElse: () => ApiErrorType.unknown);
  }
}
