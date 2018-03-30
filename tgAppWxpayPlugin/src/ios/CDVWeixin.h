//
//  CDVAlipay.h
//
//  Created by juxin on 17/9/30.
//
//
#import <Cordova/CDV.h>
#import "WXApi.h"


@interface CDVWeixin:CDVPlugin <WXApiDelegate>

@property (nonatomic, strong) NSString *currentCallbackId;
@property (nonatomic, strong) NSString *app_id;

- (void)sendPayReq:(CDVInvokedUrlCommand *)command;
- (void)test:(CDVInvokedUrlCommand*)command;


@end
