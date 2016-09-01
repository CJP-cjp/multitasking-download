//
//  MultitaskTableCell.h
//  multitasking download
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
@class MultitaskTableCell;
@protocol MultitaskTableCellDelegate<NSObject>
-(void)downloadBtnClick:(MultitaskTableCell*)cell;
@end
@interface MultitaskTableCell : UITableViewCell
@property(strong,nonatomic)BookModel *model;
@property(weak,nonatomic)id <MultitaskTableCellDelegate>delegate;
@end
