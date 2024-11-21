import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

/** FkUserAgentPlugin **/
export default class FkUserAgentPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private receiver: ConnectivityBroadcastReceiver | null = null;
  private pluginBing: FlutterPluginBinding | null = null;
  private properties: Map<string, ESObject> = new Map<string, ESObject>();

  constructor() {
  }

  getUniqueClassName(): string {
    return "FkUserAgentPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "fk_user_agent");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getProperties") {

    } else {
      result.notImplemented()
    }
  }

  async getProperties(call: MethodCall, result: MethodResult) {
    if (this.properties.size > 0) {
      result.success(this.properties)
      return;
    }
    constants.put("systemName", "OpenHarmony");
    constants.put("systemVersion", Build.VERSION.RELEASE);
    constants.put("packageName", packageName);
    constants.put("shortPackageName", shortPackageName);
    constants.put("applicationName", applicationName);
    constants.put("applicationVersion", applicationVersion);
    constants.put("applicationBuildNumber", buildNumber);
    constants.put("packageUserAgent", packageUserAgent);
    constants.put("userAgent", userAgent);
    constants.put("webViewUserAgent", getWebViewUserAgent());
    result.success(this.properties)
  }
}