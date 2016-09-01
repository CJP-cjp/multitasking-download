//
//  MultitaskTableCell.m
//  multitasking download
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MultitaskTableCell.h"
@interface MultitaskTableCell()
@property(weak,nonatomic)IBOutlet UILabel *nameLabel;
@property(weak,nonatomic)IBOutlet UIProgressView *progressView;

@end
@implementation MultitaskTableCell

- (void)awakeFromNib {
    // Initialization code
    //创建和设置下载按钮
    UIButton *downBtn = [[UIButton alloc]init];
    [downBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [downBtn sizeToFit];
    //把按钮赋值给cell最右边的view
    self.accessoryView = downBtn;
    [downBtn addTarget:self action:@selector(downloadbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
//按钮的点击事件
-(void)downloadbtnClick:(UIButton *)sender
{
  //修改按钮的状态---此方法不适合在cell 使用，因为复用的缘故，只适合在普通的自定义的view上使用
    //sender.selected = !sender.selected;
    //问题：由于cell的复用，就造成了按钮的状态的复用
    //解决办法：1.自定义按钮，给按钮一个BOOL值得属性，专门记录按钮的状态
    //2.在模型里定义BOOL值得属性，专门记录按钮的状态
    self.model.isSelectedBtn =!self.model.isSelectedBtn;
    NSString *title = (self.model.isSelectedBtn == YES) ?@"暂停":@"下载";
    [sender setTitle:title forState:UIControlStateNormal];
    //告诉控制器去下载音频---用代理，不用block（垃圾代码）？？？？？？能用代理的地方，可以用block，自定义cell的情况除外，能用代理的地方，用代理，不用block
    if ([_delegate respondsToSelector:@selector(downloadBtnClick:)]) {
        [_delegate downloadBtnClick:self];
    }
    
}
//在滚动屏幕时，频繁调用，产生复用？？？？？
-(void)setModel:(BookModel *)model
{
    _model = model;
    UIButton *downloadBtn = (UIButton*)self.accessoryView;
    NSString *title = (self.model.isSelectedBtn == YES) ?@"暂停":@"下载";
    [downloadBtn setTitle:title forState:UIControlStateNormal];
    self.nameLabel.text = model.name;
    self.progressView.progress = model.progress;
    //self.progressView
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
