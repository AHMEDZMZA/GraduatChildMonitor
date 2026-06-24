
// ==================== AUTH DTOs ====================
class AuthResponse {
  final String message;
  final String email;
  final String token;

  AuthResponse({
    required this.message,
    required this.email,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Support APIs that wrap the result in a 'data' object
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;
    
    return AuthResponse(
      message: json['message']?.toString() ?? data['message']?.toString() ?? '',
      email: json['email']?.toString() ?? data['email']?.toString() ?? '',
      token: json['token']?.toString() ?? 
             json['accessToken']?.toString() ?? 
             json['jwt']?.toString() ?? 
             json['access_token']?.toString() ?? 
             data['token']?.toString() ?? 
             data['accessToken']?.toString() ?? 
             data['jwt']?.toString() ?? 
             data['access_token']?.toString() ?? '',
    );
  }
}

class SignupRequest {
  final String monitorName;
  final String email;
  final String password;
  final String confirmPassword;

  SignupRequest({
    required this.monitorName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'monitorName': monitorName,
    'email': email,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RequestPasswordResetRequest {
  final String email;

  RequestPasswordResetRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

class ConfirmPasswordResetRequest {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  ConfirmPasswordResetRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp,
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  };
}

// ==================== SOCIAL AUTH DTOs ====================
class GoogleLoginRequest {
  final String idToken;

  GoogleLoginRequest({required this.idToken});

  Map<String, dynamic> toJson() => {'idToken': idToken};
}

class FacebookLoginRequest {
  final String accessToken;

  FacebookLoginRequest({required this.accessToken});

  Map<String, dynamic> toJson() => {'accessToken': accessToken};
}
