//
//  XMG_AddrBookCell.m
//  JTManyChildrenSongs
//
//  Created by os on 2020/12/3.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "XMG_AddrBookCell.h"
#import "UIView+Frame.h"
   
@interface XMG_AddrBookCell()

@property (nonatomic,weak)UIImageView *titleImg;
@property (nonatomic,weak)UILabel *subTitle;

@end
@implementation XMG_AddrBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
          
        
        UIImageView *titleImg=[[UIImageView alloc]init];
        titleImg.image=[UIImage imageNamed:@"homeicon5"];
        [self.contentView addSubview:titleImg];
        _titleImg=titleImg;
        [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(21);
            make.left.mas_equalTo(15); 
            make.bottom.mas_equalTo(-21);
        }];
        
        UILabel *subTitle=[[UILabel alloc]init];
        subTitle.text=@"新的朋友";
        [self.contentView addSubview:subTitle];
        _subTitle=subTitle;
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleImg.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(titleImg.mas_centerY);
        }];
         
        UIView* line = [[UIView alloc]init];
        line.backgroundColor = HEXCOLOR(0xF2F2F2);
        [self.contentView addSubview:line]; 
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleImg.mas_right).mas_offset(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    
    
    return self;
}
 
- (void)setUserBaseModel:(TFJunYou_UserBaseObj *)userBaseModel {
    
    _userBaseModel=userBaseModel;
    _titleImg.image=[UIImage imageNamed:userBaseModel.userId];
    _subTitle.text=userBaseModel.userNickname;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XMG_AddrBookCell";
    XMG_AddrBookCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XMG_AddrBookCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone; 
    }
    
    
    return cell;
}
 
@end

