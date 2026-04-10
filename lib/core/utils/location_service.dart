import 'package:dio/dio.dart';

class SignupLocationService {
  SignupLocationService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Map<String, String>> getSignupLocation() async {
    final ipRes = await _dio.get('https://api.ipify.org?format=json');
    final ip = ipRes.data['ip'] as String;
    final locRes = await _dio.get('http://ip-api.com/json/$ip');
    return {
      'ip': ip,
      'city': (locRes.data['city'] ?? '').toString(),
      'region': (locRes.data['regionName'] ?? '').toString(),
      'country': (locRes.data['country'] ?? '').toString(),
    };
  }
}
