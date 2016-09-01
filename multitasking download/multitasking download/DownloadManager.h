//
//  DownloadManager.h
//  multitasking download
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
////DownloaManager 文件下载器，直接管理NSURLSession

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject
//暂停下载的主方法
-(void)pauseDownWithURLString:(NSString*)URLString pauseSuccess:(void(^)(BOOL isPaused))pauseSuccess;
-(BOOL)checkIsDownloaingWithURLString:(NSString*)URLSting;
+(instancetype)sharedManager;
//音频下载的主方法
/*
 *
 *
 */
-(void)downloadWihtURLSting:(NSString*)URLString progressBlock:(void(^)(float progress))progressBlock completionBlock:(void(^)(NSString *filePath))completionBlock;
@end
