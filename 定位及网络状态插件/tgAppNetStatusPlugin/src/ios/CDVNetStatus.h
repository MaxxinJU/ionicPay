#import <Cordova/CDV.h>


@interface CDVNetStatus:CDVPlugin

@property (nonatomic, strong) NSString *currentCallbackId;

- (void)getNetStatusFormStatebar:(CDVInvokedUrlCommand *)command;
- (void)getNetStatusFormAFN:(CDVInvokedUrlCommand*)command;


@end
