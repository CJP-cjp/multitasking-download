

//
//  BookModel.m
//  multitasking download
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
+(instancetype)bookWithDict:(NSDictionary*)dict
{
    BookModel *model = [[BookModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
