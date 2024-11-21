import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { deviceInfo } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';

/** FkUserAgentPlugin **/
export default class FkUserAgentPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
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
      this.getProperties(call, result);
    } else {
      result.notImplemented()
    }
  }

  async getProperties(call: MethodCall, result: MethodResult) {
    if (this.properties.size > 0) {
      result.success(this.properties)
      return;
    }

    this.properties.set("systemName", "OpenHarmony");
    this.properties.set("systemVersion", deviceInfo.displayVersion);
    this.properties.set("packageName", await this.getBundleName());
    this.properties.set("shortPackageName", await this.getBundleName());
    this.properties.set("applicationName", await this.getBundleName());
    this.properties.set("applicationVersion", await this.getVersionName());
    this.properties.set("applicationBuildNumber", await this.getVersionCode());
    let packageUserAgent =
      `${await this.getBundleName()}/${await this.getVersionName()}.(${await this.getVersionCode()}`;
    this.properties.set("packageUserAgent", packageUserAgent);
    this.properties.set("userAgent", "");
    let webViewUserAgent = `Mozilla/5.0 (Phone; OpenHarmony ${deviceInfo.displayVersion}) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.96 Mobile Safari/537.36 ArkWeb/4.1.6.1`;
    this.properties.set("webViewUserAgent", webViewUserAgent);
    result.success(this.properties)
  }

  /**
   * 获取当前应用的BundleInfo
   * @returns 返回一个Promise，该Promise解析为当前应用的BundleInfo对象
   */
  async getBundleInfo(): Promise<bundleManager.BundleInfo> {
    // 调用bundleManager的getBundleInfoForSelf方法，传入参数以获取包含应用信息的BundleInfo
    return await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
  }

  async getBundleName(): Promise<string> {
    // 获取BundleInfo对象，并从中提取应用包的名称
    return (await this.getBundleInfo()).name;
  }

  async getVersionCode(): Promise<number> {
    // 获取BundleInfo对象，并从中提取应用的版本号
    return (await this.getBundleInfo()).versionCode;
  }

  async getVersionName(): Promise<string> {
    // 获取BundleInfo对象，并从中提取应用的版本名
    return (await this.getBundleInfo()).versionName;
  }
}