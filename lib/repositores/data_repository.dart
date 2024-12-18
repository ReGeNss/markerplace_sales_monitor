import 'package:http/http.dart' as http;

class DataRepository{
  static const _authority = 'container-function.grayplant-56db7559.westeurope.azurecontainerapps.io';
  static const _unencodetPath = '/api/httpGetScrapedData';

  Future<String> getData() async {
    final client = http.Client(); 
    try {
      final requestUrl = Uri.https(_authority, _unencodetPath);
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
