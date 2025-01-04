class ErrorMessages {
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String invalidEmail = 'Invalid email address';
  static const String invalidPassword = 'Invalid password';
  static const String userNotFound = 'User not found';
  static const String emailAlreadyInUse = 'Email is already in use';
  static const String weakPassword = 'Password is too weak';
  static const String unauthorized = 'Unauthorized access';
  static const String invalidInput = 'Invalid input';
  
  // Auth specific errors
  static const String invalidCredentials = 'Invalid email or password';
  static const String accountDisabled = 'This account has been disabled';
  static const String sessionExpired = 'Session expired, please login again';
  
  // Portfolio specific errors
  static const String invalidAmount = 'Please enter a valid amount';
  static const String insufficientBalance = 'Insufficient balance';
  static const String invalidCoin = 'Invalid cryptocurrency selected';
  
  // API specific errors
  static const String apiError = 'Error fetching data from server';
  static const String rateLimitExceeded = 'Too many requests, please try again later';
  static const String maintenanceMode = 'Service is under maintenance';
} 