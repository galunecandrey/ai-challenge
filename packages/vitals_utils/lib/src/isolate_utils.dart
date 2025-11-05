import 'dart:isolate';
import 'dart:ui';

class IsolateUtils {
  static void listen<T>({required String portName, required void Function(T) onData}) {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;
    IsolateNameServer.registerPortWithName(sendPort, portName);

    receivePort.listen((dynamic message) {
      onData(message as T);
    });
  }

  static bool send<T>({required String portName, required T message}) {
    final port = IsolateNameServer.lookupPortByName(portName);
    if (port == null) {
      return false;
    }
    port.send(message);
    return true;
  }
}
