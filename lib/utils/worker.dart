import 'dart:async';
import 'dart:isolate';
import 'package:markerplace_sales_monitor/utils/worker_entities.dart';

abstract class Worker{
  Worker(void Function(IWorkerStartUpData) workerFunction, IWorkerStartUpData workerStartUpData) {
    _init(workerFunction, workerStartUpData);
  }

  late final Isolate _isolate;
  final _receivePort = ReceivePort();
  SendPort? _sendPort; 
  final Map<int, Completer> pendingRequests = {};

  final Completer<void> _readyCompleter = Completer<void>();
  Future<void> get ready => _readyCompleter.future;

  final StreamController<WorkerResponse> _streamController = StreamController.broadcast();
  late final Stream<WorkerResponse> workerOutput = _streamController.stream;

  void sendRequest<T>(WorkerRequest<T> request) {
    if (_sendPort != null) {
      _sendPort!.send(request);
    } else {
      throw Exception('SendPort is not initialized yet.');
    }
  }

  Future<void> _init(Function(IWorkerStartUpData) workerFunction, IWorkerStartUpData startData) async{
    startData.sendPort = _receivePort.sendPort;
    _isolate = await Isolate.spawn(workerFunction, startData, errorsAreFatal: false);  
    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        _readyCompleter.complete();
      }else if(message is WorkerResponse) {
        _streamController.add(message);
        pendingRequests[message.id]?.complete(message.responseBody);
        pendingRequests.remove(message.id);
      }else if(message is WorkerResponseError) {
        pendingRequests[message.id]?.completeError(message.error);
        pendingRequests.remove(message.id);
      }
    });
  }

  Future<T> doRequest<T,K>(WorkerRequestBody<K> requestBody) async{
    final completer = Completer<T>();
    final requestId = pendingRequests.length + 1; 
    pendingRequests[requestId] = completer;
    final request = WorkerRequest<K>(requestId, requestBody);
    sendRequest(request);
    return completer.future; 
  }

  void dispose() {
    _isolate.kill(priority: Isolate.immediate);
    _receivePort.close();
    _streamController.close();
  }
}
