import 'app_failure.dart';

/// Converts failures to safe UI content without serializing exception details.
final class FailurePresenter {
  const FailurePresenter._();

  static String messageFor(Object error) => switch (error) {
        AppFailure failure => failure.safeMessage,
        _ => 'Something unexpected occurred. Please try again.',
      };
}
