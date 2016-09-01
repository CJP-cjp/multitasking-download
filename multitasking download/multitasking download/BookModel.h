//
//  BookModel.h
//  multitasking download
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject
@property(copy,nonatomic)NSString *name;
@property(copy,nonatomic)NSString *path;
@property(assign,nonatomic)BOOL isSelectedBtn;
//下载进度
@property(assign,nonatomic)float progress;
+(instancetype)bookWithDict:(NSDictionary*)dict;
@end
