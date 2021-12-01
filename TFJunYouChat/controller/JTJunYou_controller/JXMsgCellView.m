//
//  JXMsgCellView.m
//  shiku_im
//
//  Created by 123 on 2020/6/11.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "JXMsgCellView.h"

@interface JXMsgCellView() 
 
@property (nonatomic,strong) NSMutableArray *dataArr;
 
 
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
@implementation JXMsgCellView


+(instancetype)XIBMsgCellView{
    return  [[NSBundle mainBundle]loadNibNamed:@"JXMsgCellView" owner:self options:nil].firstObject;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.tipLabel.layer.cornerRadius=7.5;
    _tipLabel.layer.masksToBounds=YES;
}
 
-(void)setBageNumber:(NSString *)bageNumber{
    
    if ([bageNumber intValue]==0) {
        _tipLabel.hidden=YES;
        _tipLabel.text=@"0";
    }else{
        _tipLabel.hidden=NO;
        _tipLabel.text = [NSString stringWithFormat:@"%@",bageNumber];
    }
}
@end
