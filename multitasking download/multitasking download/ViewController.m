//
//  ViewController.m
//  multitasking download
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "BookModel.h"
#import "MultitaskTableCell.h"
#import "DownloadManager.h"
@interface ViewController ()<UITableViewDataSource,MultitaskTableCellDelegate>
{
    NSArray *_grouplist ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)loadData
{
    //URL
    NSURL *URL = [NSURL URLWithString:@"http://42.62.15.101/yyting/bookclient/ClientGetBookResource.action?bookId=30776&imei=OEVGRDQ1ODktRUREMi00OTU4LUE3MTctOUFGMjE4Q0JDMTUy&nwt=1&pageNum=1&pageSize=50&q=114&sc=acca7b0f8bcc9603c25a52f572f3d863&sortType=0&token=KMSKLNNITOFYtR4iQHIE2cE95w48yMvrQb63ToXOFc8%2A"];
    //session发起任务和任务启动
    [[[NSURLSession sharedSession]dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil &&data !=nil) {
            //反序列化
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *list = result[@"list"];
            NSMutableArray *tmpM = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BookModel *model = [BookModel bookWithDict:obj];
                [tmpM addObject:model];
            }];
            _grouplist = tmpM.copy;
            //刷新列表
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
            
        }else
        {
            NSLog(@"%@",error);
        }
    }]resume];
}
#pragma mark - 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _grouplist.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   //MultitaskTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    MultitaskTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = _grouplist[indexPath.row];
    return cell;
}
#pragma mark - 实现协议方法
-(void)downloadBtnClick:(MultitaskTableCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BookModel *model = _grouplist[indexPath.row];
    BOOL isdownloading = [[DownloadManager sharedManager]checkIsDownloaingWithURLString:model.path];
    if (isdownloading) {
        NSLog(@"暂停%zd",isdownloading);
        [[DownloadManager sharedManager]pauseDownWithURLString:model.path pauseSuccess:^(BOOL isPaused) {
             NSLog(@"暂停%zd",isPaused);
        }];
    }else
    {
   [[DownloadManager sharedManager]downloadWihtURLSting:model.path progressBlock:^(float progress) {
       NSLog(@"进度VC%zd----%f",indexPath.row,progress);
       //根据cell滚动的角标，重新获取cell，
       MultitaskTableCell *updataCell = [self.tableView cellForRowAtIndexPath:indexPath];
       //给book模型的progress 属性赋值
       model.progress = progress;
       // 把最新的模型model交给cell，，然后，cell 会拿着最新的模型给自己的子控件赋值
       //会调用cell 的set:model 方法
       updataCell.model = model;
   } completionBlock:^(NSString *filePath) {
        NSLog(@"文件下载路径VC%@",filePath);
   }];
 }
   // NSLog(@"%s%zd",__func__,indexPath);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
