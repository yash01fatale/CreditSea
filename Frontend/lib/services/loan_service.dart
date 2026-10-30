import 'api_service.dart';

class LoanService {
  final _api = ApiService.instance;

  Future<Map<String, dynamic>> calculateEMI(double amount, int tenure) async {
    return _api.post('/loan/calculate', body: {
      'amount': amount,
      'tenure': tenure,
    });
  }

  Future<Map<String, dynamic>> applyLoan({
    required double amount,
    required int tenure,
    required String purpose,
  }) async {
    return _api.post('/loan/apply', body: {
      'amount': amount,
      'tenure': tenure,
      'purpose': purpose,
    });
  }

  Future<Map<String, dynamic>> getLoans() async {
    return _api.get('/loan/applications');
  }

  Future<Map<String, dynamic>> getLoanById(String id) async {
    return _api.get('/loan/$id');
  }

  Future<Map<String, dynamic>> getCreditScore() async {
    return _api.get('/loan/credit-score');
  }
}
