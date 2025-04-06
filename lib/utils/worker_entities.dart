import 'dart:isolate';

class WorkerRequest<T>{
  WorkerRequest(this.id, this.requestBody);

  final int id; 
  final WorkerRequestBody<T> requestBody;
}

class WorkerRequestBody<T>{
  WorkerRequestBody(this.request);
  final T request;
}

class WorkerResponse<T>{
  WorkerResponse(this.responseBody, this.id);

  final int id; 
  final T responseBody;
}

class WorkerResponseError{
  WorkerResponseError(this.error, this.id);
  final int id;
  final String error; 
}

class IWorkerStartUpData{
  IWorkerStartUpData();
  SendPort? sendPort;  
}

class WorkerCloseRequest{}
