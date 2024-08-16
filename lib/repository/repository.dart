import 'package:template_flutter/config/global_config.dart';
import 'package:template_flutter/repository/http_request.dart';

abstract class BaseRepository {
  HttpRequests httpRequests = HttpRequests.instance;
  GlobalConfig globalConfig = GlobalConfig.instance;
}
