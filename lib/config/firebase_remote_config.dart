// coverage:ignore-file
import 'package:template_flutter/config/global_config.dart';
import 'package:template_flutter/resource/global_envs.dart';

class RemoteConfig {
  // final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  setup() async {
    // TODO: remove mockSetup when Firebase Remote Config is configured
    return mockSetup();

    // var settings = RemoteConfigSettings(
    //   fetchTimeout: const Duration(seconds: 30),
    //   minimumFetchInterval: const Duration(days: 15),
    // );
    //
    // await remoteConfig.setConfigSettings(settings);
    // await remoteConfig.fetchAndActivate();
    // remoteConfig.onConfigUpdated.listen((event) async {
    //   await remoteConfig.activate();
    //   loadRemoteConfigs();
    // });
    //
    // loadRemoteConfigs();
  }

  mockSetup() async {
    GlobalConfig globalConfig = GlobalConfig.instance;
    globalConfig.set(GlobalEnvs.apiBaseUrl.name, "https://freetestapi.com/");
    globalConfig.set(GlobalEnvs.endpointDemo.name, "api/v1/movies");
    globalConfig.set(GlobalEnvs.endpointDemoExpiration.name, "10000");
  }

// loadRemoteConfigs() {
//   Map<String, RemoteConfigValue> remoteConfigs = remoteConfig.getAll();
//   GlobalConfig globalConfig = GlobalConfig.instance;
//
//   for (var envField in GlobalEnvs.values) {
//     String remoteValue = (remoteConfigs[envField.name]?.asString() ?? "");
//     globalConfig.set(envField.name, remoteValue);
//   }
// }
}
