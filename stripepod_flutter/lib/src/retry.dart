import 'dart:async';

// Retry a function and return the result in case of success or max attempts
// exceeded.
Future<T> simpleRetry<T>({
  required Future<T> Function() action,
  bool Function(T result)? retryWhen,
  int maxAttempts = 5,
  Duration delay = const Duration(seconds: 2),
  Future<void> Function(Duration duration)? delayFn,
}) async {
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      // Execute action
      final result = await action();

      // Check if the result matches the condition to retry
      if (retryWhen != null && retryWhen(result)) {
        // If we reached max attempts, we must accept the result as is
        if (attempt == maxAttempts) return result;

        // Otherwise, wait and continue to next loop iteration
        if (delayFn != null) {
          await delayFn(delay);
        } else {
          await Future<void>.delayed(delay);
        }
        continue;
      }

      // If condition is false (or not provided), return success immediately
      return result;
    } catch (e) {
      // Standard error retry logic
      if (attempt == maxAttempts) rethrow;
      if (delayFn != null) {
        await delayFn(delay);
      } else {
        await Future<void>.delayed(delay);
      }
    }
  }
  throw Exception('Unreachable');
}
