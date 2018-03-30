#import "CDVNetStatus.h"
#import "AFNetworking.h"

@interface CDVNetStatus()

@end

@implementation CDVNetStatus




- (void)getNetStatusFormAFN:(CDVInvokedUrlCommand*)command
{
    
    //检测网络状态
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        CDVPluginResult* pluginResult = nil;

        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"未知网络"];
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
              pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"断网"];
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"蜂窝网络"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"AFN网络：wifi");
                 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"WIFI"];
                break;
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    
}


- (void)getNetStatusFormStatebar:(CDVInvokedUrlCommand *)command{
    
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    CDVPluginResult* pluginResult = nil;

    NSString *stateString = @"";
    
    switch (type) {
        case 0:
            stateString = @"notReachable";
            break;
            
        case 1:
            stateString = @"2G";
            break;
            
        case 2:
            stateString = @"3G";
            break;
            
        case 3:
            stateString = @"4G";
            break;
            
        case 4:
            stateString = @"LTE";
            break;
            
        case 5:
            stateString = @"wifi";
            break;
            
        default:
            break;
    }
        //正确返回北京市
      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:stateString];
    
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}





@end
