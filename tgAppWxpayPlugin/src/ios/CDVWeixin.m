//
//  CDVAlipay.h
//
//  Created by juxin on 17/9/30.
//
//
#import "CDVWeixin.h"
#import "WXHttpUtil.h"

@implementation CDVWeixin



#pragma mark "API"

-(void)pluginInitialize{
}


-(void) prepareForExec:(CDVInvokedUrlCommand *)command{
    [WXApi registerApp:self.app_id];
    self.currentCallbackId = command.callbackId;
    if (![WXApi isWXAppInstalled])
    {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"未安装微信"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        [self endForExec];
        return;
    }
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
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"Hello World！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    
    [alertview show];
    
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}


- (void)sendPayReq:(CDVInvokedUrlCommand *)command{
    NSDictionary *params = [self checkArgs:command];

    if(params == nil){
        return;
    }
    NSLog(@"数组params:%@",params);
    self.app_id = [params objectForKey:@"appid"];
    NSString *urlString = [params objectForKey:@"urlString"];
    NSString *method = [params objectForKey:@"method"];
    NSDictionary *postDict = [params objectForKey:@"data"];

    if (method == nil)
    {
        return;
    }
    method = [method lowercaseString];
    [self prepareForExec:command];
    if ([method isEqualToString:@"post"])
    {
            [WXHttpUtil doGetWithUrl:urlString params:postDict callback:^(BOOL isSuccessed, NSDictionary *result) {
            [self dealWithResult:result];

        }];
    }else{
        NSLog(@"走get方法");

        [WXHttpUtil doGetWithUrl:urlString params:postDict callback:^(BOOL isSuccessed, NSDictionary *result) {
            [self dealWithResult:result];
        }];
    }
    
   
}

-(void)dealWithResult:(NSDictionary *)result{
    
        if(result != nil){
            NSLog(@"结果：%@",result);
            NSDictionary *data = result[@"data"];
            NSMutableString *status = [result objectForKey:@"status"];
                if (status.intValue == 0000){
                    NSMutableString *stamp  = [data objectForKey:@"timeStamp"];
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [data objectForKey:@"partnerid"];
                    req.prepayId            = [data objectForKey:@"prepayId"];
                    req.nonceStr            = [data objectForKey:@"nonceStr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [data objectForKey:@"package"];
                    req.sign                = [data objectForKey:@"appSign"];
                    req.openID = self.app_id;
                    [WXApi sendReq:req];
                    //日志输出
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                    return;
                }
            }
    
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"支付失败"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.currentCallbackId];
                      
        [self endForExec];
}



- (void)onResp:(BaseResp *)resp{
//    CDVPluginResult *result = nil;
    if ([resp isKindOfClass:[PayResp class]])
    {
        
        PayResp *response = (PayResp *)resp;
        CDVPluginResult *result = nil;
        switch (response.errCode) {
            case WXSuccess:
                  result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%d",response.errCode]];
                
                break;
                
            default:
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%d",response.errCode]];
                
                break;
        }

       [self.commandDelegate sendPluginResult:result callbackId:[self currentCallbackId]];
        
    }
    [self endForExec];
}

#pragma mark "CDVPlugin Overrides"
- (void)handleOpenURL:(NSNotification *)notification{
    NSURL* url = [notification object];
    if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:self.app_id])
    {
        [WXApi handleOpenURL:url delegate:self];
    }
}



@end
