//
//  CNCboxHttpServerHelper.m
//  CNCboxSDK
//
//  Created by Zhangzhengang on 2018/8/28.
//  Copyright © 2018年 Zhangzhengang. All rights reserved.
//

#import "HttpServerHelper.h"

@interface HttpServerHelper() <NSURLSessionDataDelegate>
{
    NSMutableData   *resultData;//存放单次data
    NSMutableDictionary *mutableResultData;
    BOOL            m_isMoreHttp;
    NSMutableArray  *mutableList;//记录多次个数
}

- (void)onehttpRequestUrl:(NSString *)url andMethod:(HTTP_TYPE)method andParamters:(NSDictionary *)paramters;
- (void)morehttpRequestUrl:(NSArray *)requestQueue;

@end

@implementation HttpServerHelper


#pragma mark -
#pragma mark Public Function
+ (void)httpRequestUrl:(NSString *)httpUrl
             andMethod:(HTTP_TYPE)method
       andRequestQueue:(NSArray *)requestQueue
          andParamters:(NSDictionary *)paramters
        andFinishBlock:(HttpFinishBlock)finishBlock
{
    HttpServerHelper *httpserverhelper = [[HttpServerHelper alloc] init];
    httpserverhelper.finishBlock = finishBlock;
    if (requestQueue == nil || [requestQueue count] == 0)
    {
        [httpserverhelper onehttpRequestUrl:httpUrl andMethod:method andParamters:paramters];
    }
    else
    {
        [httpserverhelper morehttpRequestUrl:requestQueue];
    }
}


#pragma mark -
#pragma mark Private Function
- (id)init
{
    self = [super init];
    if (self)
    {
        m_isMoreHttp = YES;
    }
    return self;
}


- (void)onehttpRequestUrl:(NSString *)url andMethod:(HTTP_TYPE)method andParamters:(NSDictionary *)paramters
{
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    
    if (method == HTTP_POST)
    {
        [request setHTTPMethod:@"POST"];
        if ([paramters count] > 0)
        {
            NSArray *paramtersKey = [[NSArray alloc] initWithArray:[paramters allKeys]];
            NSString *strBody = @"";
            for (NSString *strKey in paramtersKey)
            {
                strBody = [strBody stringByAppendingFormat:@"%@=%@&",strKey,[paramters objectForKey:strKey]];
            }
            NSData *BodyData = [strBody dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:BodyData];
        }
    }
    else
    {
        [request setHTTPMethod:@"GET"];
    }
    
    NSURLSessionConfiguration *sessionconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionconfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request];
    [datatask resume];
}


- (void)morehttpRequestUrl:(NSArray *)requestQueue
{
    m_isMoreHttp = YES;
    mutableResultData = [[NSMutableDictionary alloc] init];
    mutableList = [[NSMutableArray alloc] initWithArray:requestQueue];
    for (NSString *onehttpurl in mutableList)
    {
        NSURL *url = [NSURL URLWithString:onehttpurl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [self saveMutableDataWithUrl:response.URL.absoluteString andData:data andError:error];
        }];
        [datatask resume];
    }
}

- (void)saveMutableDataWithUrl:(NSString *)url andData:(NSData *)data andError:(NSError *)error
{
    if (error)
    {
        [mutableResultData setObject:error.description forKey:url];
        if ([mutableResultData count] == [mutableList count])
        {
            self.finishBlock(mutableResultData, YES, error);
        }
        return;
    }
    NSData *onedata = [[NSData alloc] initWithData:data];
    id oneSerializationData = [NSJSONSerialization JSONObjectWithData:onedata options:0 error:nil];
    if ([oneSerializationData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *onedicData = [[NSDictionary alloc] initWithDictionary:oneSerializationData];
        [mutableResultData setObject:onedicData forKey:url];
    }
    else if ([oneSerializationData isKindOfClass:[NSArray class]])
    {
        NSArray *onearrayData = [[NSArray alloc] initWithArray:oneSerializationData];
        [mutableResultData setObject:onearrayData forKey:url];
    }
    
    if ([mutableResultData count] == [mutableList count])
    {
        self.finishBlock(mutableResultData, NO, nil);
    }
}


#pragma mark -
#pragma mark NSURLSession Delegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    if (!resultData)
    {
        resultData = [[NSMutableData alloc]init];
    }
    else
    {
        [resultData setLength:0];
    }
    
    completionHandler(NSURLSessionResponseAllow);
}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次

    [resultData appendData:data];
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
    if (error == nil)
    {
        id jsondata = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
        self.finishBlock(jsondata, NO, @"");
        return;
    }
}

@end
