#import "WXHttpUtil.h"
#import "AFNetworking.h"

@implementation WXHttpUtil

+(void)doGetWithUrl:(NSString *)path params:(NSDictionary *)params callback:(WXHttpCallback)callback{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", nil];
    
    [manager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseJSON:%@",responseObject);
        if (responseObject)
        {
            NSDictionary *result = responseObject;
            callback(YES, result);
        }
        else
        {
            callback(NO, nil);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        callback(NO, nil);

    }];
    //





}

+(void)doPostWithUrl:(NSString *)path params:(NSDictionary *)params callback:(WXHttpCallback)callback{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", nil];
    
    [manager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseJSON:%@",responseObject);
        if (responseObject)
        {
            NSDictionary *result = responseObject;
            callback(YES, result);
        }
        else
        {
            callback(NO, nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        callback(NO, nil);
        
    }];
    //
    
    
    
    
    
}


@end
