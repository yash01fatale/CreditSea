import 'api_service.dart';

class ProfileService {
  final _api = ApiService.instance;

  Future<Map<String, dynamic>> getProfile() async {
    return _api.get('/profile');
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return _api.put('/profile', body: data);
  }
}
