import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_care/subscription/domain/entities/plan_type.dart';
import 'package:plant_care/subscription/domain/entities/subscription.dart';
import 'package:plant_care/subscription/infrastructure/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final String baseUrl;

  SubscriptionRepositoryImpl({required this.baseUrl});

  // 🧩 Obtiene el token dinámicamente del almacenamiento local
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  void _debugResponse(http.Response response, String endpoint) {
    print('--- [DEBUG SubscriptionRepo] $endpoint ---');
    print('Status: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    print('-----------------------------------------');
  }

  @override
  Future<Subscription?> getUserSubscription(String userId) async {
    final headers = await _getHeaders();
    final url = '$baseUrl/subscriptions/$userId';
    print('➡️ GET $url');

    final response = await http.get(Uri.parse(url), headers: headers);
    _debugResponse(response, 'GET /subscriptions/$userId');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _fromJson(data);
    } else if (response.statusCode == 404) {
      print('ℹ️ No subscription found for $userId');
      return null;
    } else {
      throw Exception('❌ Error fetching subscription: ${response.body}');
    }
  }

  @override
  Future<Subscription> changePlan(String userId, PlanType planType) async {
    final headers = await _getHeaders();
    final url = '$baseUrl/subscriptions';
    print('➡️ POST $url with planType=${planType.name}');

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'userId': userId, 'planType': planType.name}),
    );
    _debugResponse(response, 'POST /subscriptions');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return _fromJson(data);
    } else {
      throw Exception('❌ Error changing plan: ${response.body}');
    }
  }

  @override
  Future<Subscription> cancelSubscription(String userId) async {
    final headers = await _getHeaders();
    final url = '$baseUrl/subscriptions/$userId/cancelled';
    print('➡️ POST $url');

    final response = await http.post(Uri.parse(url), headers: headers);
    _debugResponse(response, 'POST /subscriptions/$userId/cancelled');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _fromJson(data);
    } else {
      throw Exception('❌ Error cancelling subscription: ${response.body}');
    }
  }

  @override
  Future<Subscription> activateSubscription(String userId) async {
    final headers = await _getHeaders();
    final url = '$baseUrl/subscriptions/$userId/active';
    print('➡️ POST $url');

    final response = await http.post(Uri.parse(url), headers: headers);
    _debugResponse(response, 'POST /subscriptions/$userId/active');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _fromJson(data);
    } else {
      throw Exception('❌ Error activating subscription: ${response.body}');
    }
  }

  Subscription _fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      planType: PlanType.fromString(json['planName'] ?? 'NONE'),
      status: json['status'] ?? 'INACTIVE',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      nextBillingDate: json['nextBillingDate'] != null
          ? DateTime.parse(json['nextBillingDate'])
          : null,
    );
  }
}