//
//  CNCboxHttpServerHelper.h
//  CNCboxSDK
//
//  Created by Zhangzhengang on 2018/8/28.
//  Copyright © 2018年 Zhangzhengang. All rights reserved.
//

typedef enum : int {
    HTTP_POST,
    HTTP_GET,
} HTTP_TYPE;

#import <Foundation/Foundation.h>

typedef void(^HttpFinishBlock)(id resultData, BOOL isError, id errorMessage);

@interface HttpServerHelper : NSObject

@property (nonatomic, strong) HttpFinishBlock finishBlock;
/*
 网络请求类使用解释：
 在单个请求中，将requestQueue为nil或者是个count=0的数组即可，建议为nil。
 在单个请求中，resultdata的返回类型为id类型，需用户自己判断是Dictionary or Array
 在多个请求中，将请求url组装进数组，在block中返回的resultData中则是以 url:data的字典形式返回，方便查找。
 在多个请求中，默认为GET方法，并且需要用户自己拼好参数，paramters无效。
 */
+ (void)httpRequestUrl:(NSString *)httpUrl
             andMethod:(HTTP_TYPE)method
       andRequestQueue:(NSArray *)requestQueue
          andParamters:(NSDictionary *)paramters
        andFinishBlock:(HttpFinishBlock)finishBlock;

@end
