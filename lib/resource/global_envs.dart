import 'package:template_flutter/config/global_config.dart';

enum GlobalEnvs {
  apiBaseUrl,
  endpointDemo,
  endpointDemoExpiration,
}

extension GlobalEnvNamesExtension on GlobalEnvs {
  String get value {
    return GlobalConfig.instance.get(name) ?? '';
  }

  String get name {
    return toString().replaceAll('GlobalEnvs.', '');
  }
}
