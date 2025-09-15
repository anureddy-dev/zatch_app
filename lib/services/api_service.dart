import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:zatch_app/model/bit_response.dart';
import 'package:zatch_app/model/follow_response.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/model/register_req.dart';
import 'package:zatch_app/model/register_response_model.dart';
import 'package:zatch_app/model/login_request.dart';
import 'package:zatch_app/model/login_response.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/model/verify_otp_request.dart';
import 'package:zatch_app/model/verify_otp_response.dart';
import 'package:zatch_app/model/otp_req.dart';
import 'package:zatch_app/model/otp_response_model.dart';
import 'package:zatch_app/model/categories_response.dart';
import 'package:zatch_app/model/reels_video_model.dart';
import 'package:zatch_app/utils/local_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String baseUrl = "https://zatch-e9ye.onrender.com/api/v1";
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {"Content-Type": "application/json"},
  ));

  String? _token;

  /// Initialize service: load token from storage if available
  Future<void> init() async {
    final token = await LocalStorage.getSavedToken();
    if (token != null) {
      setToken(token);
    }
  }

  /// Save token and attach to headers
  void setToken(String token) {
    _token = token;
    _dio.options.headers["Authorization"] = "Bearer $token";
    LocalStorage.saveToken(token); // persist for next launch
  }

  /// REGISTER
  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    try {
      final response = await _dio.post("/user/register", data: request.toJson());
      final data = response.data is String
          ? jsonDecode(response.data.substring(response.data.indexOf('{')))
          : response.data;
      final registerResponse = RegisterResponse.fromJson(data);
      setToken(registerResponse.token);
      return registerResponse;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// LOGIN
  Future<LoginResponse> loginUser(LoginRequest request) async {
    try {
      final response = await _dio.post("/user/login", data: request.toJson());
      final loginResponse = LoginResponse.fromJson(response.data);
      setToken(loginResponse.token);
      return loginResponse;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// VERIFY OTP
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await _dio.post("/twilio-sms/verify-otp", data: request.toJson());
      final data = response.data is String
          ? jsonDecode(response.data.substring(response.data.indexOf('{')))
          : response.data;
      return VerifyOtpResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// SEND OTP
  Future<SendOtpResponse> sendOtp(SendOtpRequest request) async {
    try {
      final response = await _dio.post("/twilio-sms/send-otp", data: request.toJson());
      final data = response.data is String
          ? jsonDecode(response.data.substring(response.data.indexOf('{')))
          : response.data;
      return SendOtpResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// USER PROFILE
  Future<UserProfileResponse> getUserProfile() async {
    try {
      final response = await _dio.get("/user/profile");
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      return UserProfileResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// CATEGORIES
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get("/category");
      final data = response.data is String ? jsonDecode(response.data) : response.data;
      final categoriesResponse = CategoriesResponse.fromJson(data);
      return categoriesResponse.categories;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// LIVE SESSIONS
  Future<List<ReelsVideo>> getLiveSessions() async {
    try {
      final response = await _dio.get("/live/sessions");
      final List<dynamic> data = response.data["sessions"] ?? [];
      return data.map((e) => ReelsVideo.fromJson(e)).toList().cast<ReelsVideo>();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<FollowResponse> toggleFollowUser(String targetUserId) async {
    try {
      final response = await _dio.post("/user/$targetUserId/toggleFollow");
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      return FollowResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get("/product/products");
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      final productResponse = ProductResponse.fromJson(data);
      return productResponse.products;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<Bit>> getBits() async {

    try {
      final response = await _dio.get("/bits/list");
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      final bitsResponse = BitsResponse.fromJson(data);
      return bitsResponse.bits;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }
  /// Common error handler
  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data["message"] ?? "Something went wrong!";
    } else {
      return e.message ?? "Connection error!";
    }
  }
}
