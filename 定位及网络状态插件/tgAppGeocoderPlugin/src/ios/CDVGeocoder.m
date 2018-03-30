#import "CDVGeocoder.h"
#import <CoreLocation/CoreLocation.h>

@implementation CDVGeocoder



#pragma mark "API"

-(void)pluginInitialize{
}




-(NSDictionary *)checkArgs:(CDVInvokedUrlCommand *) command{
    // check arguments
    NSDictionary *params = [command.arguments objectAtIndex:0];
    if (!params)
    {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数错误"] callbackId:command.callbackId];
        
        [self endForExec];
        return nil;
    }
    return params;
}



-(void) endForExec{
    self.currentCallbackId = nil;
}


- (void)test:(CDVInvokedUrlCommand*)command
{
    //CDVPluginResult* pluginResult = nil;
    
    //pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hello"];
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"你好世界！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    
    [alertview show];
    
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}


- (void)getPlaceName:(CDVInvokedUrlCommand *)command{
    
    NSDictionary *locationDict = [self checkArgs:command];
    NSString *latitude = locationDict[@"latitude"];
    NSString *longitude = locationDict[@"longitude"];
    double la = [latitude doubleValue];
    double lo = [longitude doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:la longitude:lo];
    // 1.创建地理编码 -->CLGeocoder管理地理编码和反地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 2.2调用方法  -->向苹果请求数据
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 2.3防错处理
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        // 2.4赋值 -->获取地标
        CLPlacemark *placemark = placemarks[0];
        NSString *locality = placemark.locality;
        
        
        //正确返回北京市
        CDVPluginResult* pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:locality];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}





@end
