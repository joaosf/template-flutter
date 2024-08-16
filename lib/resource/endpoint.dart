
import 'package:template_flutter/resource/global_envs.dart';

enum EndpointList {
  demo
}

extension EndpointListExtension on EndpointList {
  GlobalEnvs get name {
    switch (this) {
      case EndpointList.demo:
        return GlobalEnvs.endpointDemo;
    }
  }

  GlobalEnvs get expiration {
    switch (this) {
      case EndpointList.demo:
        return GlobalEnvs.endpointDemoExpiration;
    }
  }

  bool get checkChanges {
    switch (this) {
      case EndpointList.demo:
        return true;
      default:
        return false;
    }
  }

  bool get responseExpiredOffline {
    switch (this) {
      case EndpointList.demo:
        return true;
      default:
        return false;
    }
  }
}
