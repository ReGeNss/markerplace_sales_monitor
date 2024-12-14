import 'package:http/http.dart' as http;

class InternetConnectionHandler{
  Future<String> getData(String url, String unencodetPath) async {
    final client = http.Client(); 
    try {
      final requestUrl = Uri.https(url,unencodetPath);
      final response = await client.get(requestUrl);
      if( response.statusCode != 200){
        throw Exception('Failed to load data: ${response.statusCode}'); 
      }
      client.close();
      return response.body;
    } catch (e) {
      throw Exception('Failed to load data: $e'); 
    }
  }
}
