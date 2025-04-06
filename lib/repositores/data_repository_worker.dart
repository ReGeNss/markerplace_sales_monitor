import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:markerplace_sales_monitor/entities.dart';
import 'package:markerplace_sales_monitor/repositores/data_repository.dart';
import 'package:markerplace_sales_monitor/utils/worker.dart';
import 'package:markerplace_sales_monitor/utils/worker_entities.dart';

class ProxyDataRepository extends Worker implements IDataRepository {
  factory ProxyDataRepository() => _instance;
  ProxyDataRepository._() : super(
    _dataWorker, 
    DataRepoWorkerStartUpData(
      null,
      dotenv.env['API_URL']!, 
      RootIsolateToken.instance!,
    ),
  );
  
  static final ProxyDataRepository _instance = ProxyDataRepository._();

  @override
  Future<MarketplacesData> getData(String category) async {
    final requestBody = WorkerMarketplacesDataRequest(category);
    return doRequest(requestBody);
  }

  @override
  Future<List<Category>> getCatigoriesData() async {
    final body = WorkerRequestBody<DataRepositoryRequests>(
      DataRepositoryRequests.getCatigories,
    );
    return await doRequest(body);
  }

  @override
  Future<bool?> getThemeData() async {
    final body = WorkerRequestBody<DataRepositoryRequests>(
      DataRepositoryRequests.getTheme,
    );
    return await doRequest(body);
  }

  @override
  Future<void> setThemeData(bool value) async {
    final request = WorkerRequestBody<DataRepositoryRequests>(
      DataRepositoryRequests.setTheme,
    );
    await doRequest(request);
  }
}

Future<void> _dataWorker(IWorkerStartUpData startUpData) async {
  final typedStartUpData = startUpData as DataRepoWorkerStartUpData;
  BackgroundIsolateBinaryMessenger.ensureInitialized(
    typedStartUpData.rootIsolateToken,
  );
  final sendPort = typedStartUpData.sendPort!;
  final dataRepository = DataRepository(typedStartUpData.apiUrl);
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  void send<T>(T data, int id) {
    final response = WorkerResponse<T>(data, id);
    sendPort.send(response);
  }

  receivePort.listen((message) async {
    if (message is WorkerRequest<DataRepositoryRequests>) {
      final request = message.requestBody.request;
      switch (request) {
        case DataRepositoryRequests.getMarketplacesData:
          try {  
            final data = await dataRepository.getData(
              (message.requestBody as WorkerMarketplacesDataRequest).category,
            );  
            send(data, message.id);
          }catch(e){
            final error = WorkerResponseError(e.toString(), message.id);
            sendPort.send(error);
          }
          break;
        case DataRepositoryRequests.getCatigories:
          try{
            final data = await dataRepository.getCatigoriesData();
            send(data, message.id);
          }catch(e){
            final error = WorkerResponseError(e.toString(), message.id);
            sendPort.send(error);
          }
          break;
        case DataRepositoryRequests.getTheme:
          try{
            final data = await dataRepository.getThemeData();
            send(data, message.id);
          }catch(e){
            final error = WorkerResponseError(e.toString(), message.id);
            sendPort.send(error);
          }
          break;
        case DataRepositoryRequests.setTheme:
          try{
            await dataRepository.setThemeData(message.requestBody.request.toString() as bool);
            sendPort.send(null);
          }catch(e){
            sendPort.send(WorkerResponseError(e.toString(), message.id));
          }
          break;
      }
    }
  });
}

class WorkerMarketplacesDataRequest 
  implements WorkerRequestBody<DataRepositoryRequests>{
  WorkerMarketplacesDataRequest(this.category);

  @override
  final DataRepositoryRequests request =
      DataRepositoryRequests.getMarketplacesData;
  final String category;
}

class DataRepoWorkerStartUpData implements IWorkerStartUpData {
  DataRepoWorkerStartUpData(this.sendPort, this.apiUrl, this.rootIsolateToken); 

  @override
  SendPort? sendPort;
  final String apiUrl; 
  final RootIsolateToken rootIsolateToken;
}
