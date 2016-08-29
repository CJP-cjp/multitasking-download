//
//  ViewController.m
//  NSURLSessionConfiguration练习
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong,nonatomic)NSURLSession *session;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end

@implementation ViewController
//在自定义全局的session时，只需要配置一次config信息，由该自定义session发起的所有的任务都具备相同的config信息
-(NSURLSession *)session
{
    if (_session == nil) {
        //config 类似resquestM
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //设置请求头信息：告诉服务器一些额外的信息，比如客户端的设备
        config.HTTPAdditionalHeaders = @{@"user-Agent":@"iPhone"};
        config.timeoutIntervalForRequest = 15.0;
        
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return _session;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self demoload1];
    [self demoload2];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)demoload1
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [[self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data!=nil) {
            //
            NSString *HTML = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self.webview loadHTMLString:HTML baseURL:url];
        }else
        {
            NSLog(@"%@",error);
        }
    }]resume];
}
-(void)demoload2
{
    NSURL *url = [NSURL URLWithString:@"http://www.qiushibaike.com"];
    [[self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data!=nil) {
            //
            NSString *HTML = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self.webview loadHTMLString:HTML baseURL:url];
        }else
        {
            NSLog(@"%@",error);
        }
    }]resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
