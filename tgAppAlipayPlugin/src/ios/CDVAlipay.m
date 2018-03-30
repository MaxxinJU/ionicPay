//
//  CDVAlipay.h
//
//  Created by juxin on 17/9/30.
//
//

#import "CDVAlipay.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliHttpUtil.h"

@interface CDVAlipay()



@property(nonatomic,strong)NSString *currentCallbackId;

@end

@implementation CDVAlipay
-(void)handleOpenURL:(NSNotification *)notification{
    NSURL* url = [notification object];
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if (url!=nil && [url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]]];
             [self.commandDelegate sendPluginResult:result callbackId:self.currentCallbackId];
             [self endForExec];
         }];
    }
}



-(void) prepareForExec:(CDVInvokedUrlCommand *)command{
    self.currentCallbackId = command.callbackId;
    
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
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}




//支付入口
- (void)pay:(CDVInvokedUrlCommand*)command{
    NSDictionary *params = [self checkArgs:command];
    
    if(params == nil){
        return;
    }
    
    NSLog(@"数组params:%@",params);
    NSString *urlString = [params objectForKey:@"urlString"];
    NSString *method = [params objectForKey:@"method"];
    NSDictionary *data = [params objectForKey:@"data"];
    
    if (method == nil)
    {
        return;
    }
    method = [method lowercaseString];
    [self prepareForExec:command];
    if ([method isEqualToString:@"post"])
    {
        [AliHttpUtil doGetWithUrl:urlString params:data callback:^(BOOL isSuccessed, NSDictionary *result) {
            [self dealWithResult:result];
            
        }];
    }else{
        NSLog(@"走get方法");
        
        [AliHttpUtil doGetWithUrl:urlString params:data callback:^(BOOL isSuccessed, NSDictionary *result) {
            [self dealWithResult:result];
        }];
    }
    

}

-(void)dealWithResult:(NSDictionary *)result{
    if(result != nil){
        NSLog(@"字典里的东西：%@",result);
        NSDictionary *data = result[@"data"];
        NSMutableString *status = [result objectForKey:@"status"];
        if ([status intValue] == 0000) {
            
       //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipaycordova";
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
         NSString *orderString = data[@"payInfo"];
          if (orderString != nil) {
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
       
            CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]]];
            [self.commandDelegate sendPluginResult:result callbackId:self.currentCallbackId];
            [self endForExec];
        }];
    }
}
        
}
}

@end
