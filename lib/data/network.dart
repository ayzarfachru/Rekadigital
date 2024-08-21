import 'package:get/get.dart';

class ApiService extends GetConnect {
  final String baseUrl = 'https://data.bmkg.go.id';

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  Future<Response> fetchData(String endpoint) async {
    final response = await get(
      endpoint,
    );

    return response;
  }
}
