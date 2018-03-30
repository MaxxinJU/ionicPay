//
//  CDVAlipay.h
//
//  Created by juxin on 17/9/30.
//
//

#import <Foundation/Foundation.h>

#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

@interface CDVAlipay : CDVPlugin




- (void)pay:(CDVInvokedUrlCommand*)command;
@end
