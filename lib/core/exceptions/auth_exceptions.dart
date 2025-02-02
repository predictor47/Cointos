class AuthException implements Exception {
  final String message;
  final String recoverySuggestion;

  AuthException(this.message, [this.recoverySuggestion = '']);
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException()
      : super('Invalid email or password',
            'Please check your credentials and try again');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException()
      : super('Email already registered',
            'Try logging in or use a different email');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException()
      : super('Password too weak',
            'Use at least 8 characters with numbers and symbols');
}

class AccountLockedException extends AuthException {
  AccountLockedException()
      : super('Account temporarily locked',
            'Try again in 15 minutes or reset your password');
}

class PasswordResetRequiredException extends AuthException {
  PasswordResetRequiredException()
      : super('Password reset required',
            'Check your email for reset instructions');
}
