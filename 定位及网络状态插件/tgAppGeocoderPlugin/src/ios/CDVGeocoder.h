#import <Cordova/CDV.h>


@interface CDVGeocoder:CDVPlugin

@property (nonatomic, strong) NSString *currentCallbackId;

- (void)getPlaceName:(CDVInvokedUrlCommand *)command;
- (void)test:(CDVInvokedUrlCommand*)command;


@end
