import 'package:waiter/enums/internet_connectivity_status.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:io';

class InternetMonitorService {
  StreamController<InternetConnectivityStatus> internetConnectionStatusController = StreamController<InternetConnectivityStatus>();
  InternetMonitorService(){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      internetConnectionStatusController.add(await _getStatusFromRetrievedResult(result));
    });
  }
}

Future<bool> checkOriginalInternetConnection() async {
  try {
    final List<InternetAddress> result = await InternetAddress.lookup("google.com");
    if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
      return true;
    } else {
      return false;
    }
  }catch (e){
    print(e.toString());
  }
  return false;
}


Future<InternetConnectivityStatus> _getStatusFromRetrievedResult(ConnectivityResult result) async {
  switch(result){
    case ConnectivityResult.mobile:
      return await checkOriginalInternetConnection() ? InternetConnectivityStatus.mobileData : InternetConnectivityStatus.offline;
    case ConnectivityResult.wifi:
      return await checkOriginalInternetConnection() ? InternetConnectivityStatus.wiFi : InternetConnectivityStatus.offline;
    case ConnectivityResult.none:
      return InternetConnectivityStatus.offline;
    default:
      return InternetConnectivityStatus.offline;
  }
}