//
//  ViewController.m
//  MyiOSProject
//
//  Created by Zhangzhengang on 2018/8/29.
//  Copyright © 2018年 Zhangzhengang. All rights reserved.
//

#import "ViewController.h"
#import "HttpServerHelper.h"
#import "FLAnimatedImageView+WebCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    [HttpServerHelper httpRequestUrl:@"http://127.0.0.1:8000/userlogin" andMethod:HTTP_POST andRequestQueue:nil andParamters:@{@"username":@"zzgking886",@"password":@"wushixia1119"} andFinishBlock:^(id resultData, BOOL isError, id errorMessage) {
    //        if (isError)
    //        {
    //            NSLog(@"errorMessage = %@ ", errorMessage);
    //        }
    //        else
    //        {
    //            NSLog(@"resultData = %@ ", resultData);
    //        }
    //    }];
    
    //http://serv.cbox.cntv.cn/json/cbox6/yidongzhupeizhi/index.json
    
    //    [HttpServerHelper httpRequestUrl:@"http://serv.cbox.cntv.cn/json/cbox6/yidongzhupeizhi/index.json" andMethod:HTTP_GET andRequestQueue:nil andParamters:@{@"username":@"zzgking886",@"password":@"wushixia1119"} andFinishBlock:^(id resultData, BOOL isError, id errorMessage) {
    //        if (isError)
    //        {
    //            NSLog(@"errorMessage = %@ ", errorMessage);
    //        }
    //        else
    //        {
    //            NSLog(@"resultData = %@ ", resultData);
    //        }
    //    }];
    
    //http://127.0.0.1:8000/usertablelist
    //http://127.0.0.1:8000/vrtablelist
    [HttpServerHelper httpRequestUrl:@"" andMethod:HTTP_GET andRequestQueue:@[@"http://127.0.0.1:8000/usertablelist",@"http://127.0.0.1:8000/vrtablelist"] andParamters:nil andFinishBlock:^(id resultData, BOOL isError, id errorMessage) {
        if (isError)
        {
            NSLog(@"errorMessage = %@ ", errorMessage);
        }
        else
        {
            NSLog(@"resultData zzg = %@ ", resultData);
        }
    }];
    
    //http://file.huitao.net/htimg/al/gd4/alicdn/imgextra/i4/TB1oG05KpXXXXb.XpXXrYuG9XXX_034851.jpg
    //https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535537674592&di=7aeb26a81ad135ba49c0f460baa65807&imgtype=0&src=http%3A%2F%2F2017.zcool.com.cn%2Fcommunity%2F037b7355775cafb0000018c1b222864.gif
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 20, 120, 150)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://file.huitao.net/htimg/al/gd4/alicdn/imgextra/i4/TB1oG05KpXXXXb.XpXXrYuG9XXX_034851.jpg"]];
    [self.view addSubview:imageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
