/// An exception thrown by Stripe.
class StripeApiException implements Exception {
  /// Creates a new instance of [StripeApiException].
  const StripeApiException({
    required this.message,
    this.originalException,
  });

  /// The message associated with the exception.
  final String message;

  /// The original exception that caused this exception.
  final Object? originalException;

  @override
  String toString() => 'StripeApiException: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StripeApiException &&
        other.message == message &&
        other.originalException == originalException;
  }

  @override
  int get hashCode => Object.hash(message, originalException);
}
