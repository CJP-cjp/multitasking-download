//
//  DownloadManager.m
//  multitasking download
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//DownloaManager 文件下载器，直接管理NSURLSession

#import "DownloadManager.h"
#import "NSString+path.h"
@interface DownloadManager()<NSURLSessionDataDelegate>

@end
@implementation DownloadManager

{
    //全局的session
    NSURLSession *_downloadSession;
    //进度回调缓存池
    NSMutableDictionary *_progressBlockDict;
    //完成回调缓存池
     NSMutableDictionary *_completionBlockDict;
    //下载任务缓存池
    NSMutableDictionary *_downloadTaskDict;
}

+(instancetype)sharedManager
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new
                    ];
    });
    return instance;
    }
-(instancetype)init
{
    if(self = [super init]){
        //session的配置信息
        //NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"HM"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //实例化全局的下载session
        //NSURLSession的代理方法，即使是在主线程中执行的，也不会卡UI
        _downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        //实例化进度缓存池
        _progressBlockDict = [NSMutableDictionary dictionary ];
        _completionBlockDict = [NSMutableDictionary dictionary
                               ];
        _downloadTaskDict  = [NSMutableDictionary dictionary
                              ];
    }
    return self;
}
//音频下载的主方法
-(void)downloadWihtURLSting:(NSString*)URLString progressBlock:(void(^)(float progress))progressBlock completionBlock:(void(^)(NSString *filePath))completionBlock
{
    //URL
    NSURL *URL = [NSURL URLWithString:URLString];
    //发起和启动任务
    NSURLSessionDownloadTask *downloadTask;
    NSData *resumeData = [NSData dataWithContentsOfFile:[URLString appendTempPath]];
    //检查是否有续传数据
    if (resumeData) {
        //如果有续传数据，就从断点开始下载
        downloadTask=  [_downloadSession downloadTaskWithResumeData:resumeData];
        //从断点开始下载后，删除缓存
        [[NSFileManager defaultManager]removeItemAtPath:[URLString appendTempPath] error:NULL];
    }else
    {
        //重新开始下载
         downloadTask=  [_downloadSession downloadTaskWithURL:URL];
    }
   
    [downloadTask resume];
    //一个下载任务对应一个进度回调
    //block是一个指针对象，所以客户添加到集合，而且可以直接使用%@打印
    [_progressBlockDict setObject:progressBlock forKey:downloadTask];
    [_completionBlockDict setObject:completionBlock forKey:downloadTask];
   [ _downloadTaskDict setObject:downloadTask  forKey:URLString];
}
-(BOOL)checkIsDownloaingWithURLString:(NSString*)URLSting
{
    NSURLSessionDownloadTask *downloadTask = [_downloadTaskDict objectForKey:URLSting ];
    if (downloadTask) {
        return YES;
    }
    return NO;
}
//暂停下载的主方法
-(void)pauseDownWithURLString:(NSString*)URLString pauseSuccess:(void(^)(BOOL isPaused))pauseSuccess
{
    //取出的正在下载的任务
    NSURLSessionDownloadTask *downloadTask = [_downloadTaskDict objectForKey:URLString];
    if (downloadTask) {
        //[downloadTask cancel];
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            NSLog(@"暂停了吗?");
            //缓存续存数据
            [resumeData writeToFile:[URLString appendTempPath] atomically:YES];
            if(pauseSuccess){
                pauseSuccess(YES);
            }
            [_completionBlockDict removeAllObjects];
            [_progressBlockDict removeAllObjects];
            [_downloadTaskDict removeAllObjects];

        }];
    }
}
#pragma mark - 代理方法
//监听文件下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //计算进度
    float progress =(float) totalBytesWritten /totalBytesExpectedToWrite;
    //从进度缓冲池取回回调
    //NSLog(@"%f",progress);
    void(^progressBlock)(float progress) =[_progressBlockDict objectForKey:downloadTask];
    
    //回调进度
   if (progressBlock)
  {
      [[NSOperationQueue mainQueue]addOperationWithBlock:^{
          
       progressBlock(progress);
          
      }];
  }
}
//监听下载完成
-(void)URLSession:(NSURLSession*)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location
{
    //NSLog()
    NSLog(@"下载完成了，%@",location.path);
    //取出文件的的下载地址
    NSString *URLString = downloadTask.currentRequest.URL.absoluteString;
    NSString *fileName = [URLString lastPathComponent];
    NSString *filePath  = [NSString stringWithFormat:@"/Users/mac/Desktop/%@",fileName];
    //把文件拷贝到缓存文件？？？
    [[NSFileManager defaultManager]copyItemAtPath:location.path toPath:filePath error:nil];
    //取出下载完成的回调
    void(^comletionBlock)(NSString*)= [_completionBlockDict objectForKey:downloadTask];
    if (comletionBlock) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            comletionBlock(location.path);
        }];
    }
    //任务完成后，要删除缓存池
    [_completionBlockDict removeAllObjects];
    [_progressBlockDict removeAllObjects];
    [_downloadTaskDict removeAllObjects];
    
}
@end
