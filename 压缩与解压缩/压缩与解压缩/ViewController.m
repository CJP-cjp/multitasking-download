//
//  ViewController.m
//  压缩与解压缩
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "SSZipArchive.h"
@interface ViewController ()

@end

@implementation ViewController
/*
 解压缩：从网上下载下来的安装包，其原始的都是压缩包的形式的，那么在下载结束之后，需要实现自动解压缩的功能
 压缩：批量上传文件时，可以把文件压缩一下，整体以压缩包的形式送给服务器；服务器再实现解压缩
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)zip:(id)sender
{
    //参数一：要压缩到的文件路径（目标路径）
    //参数二：原始文件路径
   [SSZipArchive createZipFileAtPath:@"/Users/mac/Desktop/chengjingpo.zip" withContentsOfDirectory:@"/Users/mac/Desktop/sogou "];
}
-(IBAction)unZip:(id)sender
{
    NSLog(@"12");
    //URL
    NSURL *URL = [NSURL URLWithString:@"http://localhost/sogou.zip"];
    [[[NSURLSession sharedSession]downloadTaskWithURL:URL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error ==nil ) {
            [SSZipArchive unzipFileAtPath:location.path toDestination:@"/Users/mac/Desktop/sogou"];
            
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
