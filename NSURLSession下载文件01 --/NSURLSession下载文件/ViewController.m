//
//  ViewController.m
//  NSURLSession下载文件
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>
@property(strong,nonatomic)NSURLSession *downloadSession;
@property(strong,nonatomic)NSURLSessionDownloadTask *downloadTask;
@property(strong,nonatomic)NSData *  resumeData;
@end
/*
 问题：无法监听下载的进度
 解决：使用代理方法监听下载，必须自定义URLSession
 注意：当我们在使用NSURLSessionDownloadTask时，代理和Block不能共存，
 解决办法是，自定
 */
@implementation ViewController
//懒加载，在不知道什么时候调用时，--开发中少用，垃圾
//懒加载实例化的对象，可以保证在当前类里面，他的对象有且只有一个
//不能用self. ,死循环
-(NSURLSession *)downloadSession
{
    //开发中，一般使用默认
    NSURLSessionConfiguration  *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (_downloadSession == nil) {
        _downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _downloadSession;
}
- (IBAction)pauseClick:(id)sender {
    //一旦暂停下载之后，这个方法会把续传的数据返回来
    //resumeData :保存的是当前的下载地址和当前下载到第几个字节等等一些额外的信息，
    //注意点：downloadTaskWithResumeData:如果resumedata 为空这个方法在执行时会崩溃
    //注意点2：当连续的点击“暂停按钮时"，resumeData会为0
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        
        self.resumeData = resumeData;
        NSLog(@"续传数据 %tu",resumeData);
        //注意点：一旦拿到续传数据之后，酒吧下载任务设置成nil ,当再次点击”暂停按钮'时，就不会重复的获取续传数据
        //提示，继续下载时，会发起新的任务
        self.downloadTask = nil;
        
    }];
}
//继续下载的主方法:继续下载时，使用的也是全局的downloadTask
//
- (IBAction)continueClick:(id)sender {
    //创建续传任务之前需要判断续传数据是否为空
    if(self.resumeData!=nil)
    {
        self.downloadTask = [self.downloadSession downloadTaskWithResumeData:_resumeData];
        [self.downloadTask resume];
        //一旦开启续传数据之后，需要立即把续传数据设置为空
        //提示：当点击暂停时，续传数据会重新赋值的
        self.resumeData  = nil;
    }
    
}

- (IBAction)downloadClick4:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"http://localhost/sogou.zip"];
            //NSURLSessionDataTask * downloadTask = [self.downloadSession downloadTaskWithURL:URL];
    //自定义session ，任务发起
       self.downloadTask = [self.downloadSession downloadTaskWithURL:URL];
            [self.downloadTask resume];
    
    
}
//监听下载进度
//bytesWtiten  :每次接收的大小
//totoalBytesWritten :已接收的总大小
//totalBytesExpectedToWrite:文件的总大小
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    //计算下载进度
   float   progress = (float)totalBytesWritten  / totalBytesExpectedToWrite;
    NSLog(@"下载进度%f",progress);
}
//监听文件下载完成：可以拿到缓存路径
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
//    //下载完成时，输入路径
  //  NSLog(@"%@",location.path);
    //下载完成时，及时将文件拷贝到其他
    [[NSFileManager defaultManager ]copyItemAtPath:location.path toPath:@"/Users/mac/Desktop/sogou.zip" error:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
