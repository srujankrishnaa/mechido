class AppConfig {
  // API Configuration
  static const String supabaseUrl = 'https://vygkofpomhykmlpmyjzq.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5Z2tvZnBvbWh5a21scG15anpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NTk5OTEsImV4cCI6MjA2MzEzNTk5MX0.SXb-MT4vuR23saHehPAavVtJsHSQhtsFLWNEZ7-VU8s';

  // Google Maps Configuration
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // Razorpay Configuration
  static const String razorpayKeyId = 'YOUR_RAZORPAY_KEY_ID';

  // App Configuration
  static const String appName = 'Mechido';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'YOUR_API_BASE_URL';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Cache Configuration
  static const int cacheDuration = 7; // days

  // Pagination
  static const int pageSize = 10;

  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
}
