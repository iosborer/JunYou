//
//  XMG_FriendCirleCell.m
//  JTManyChildrenSongs
//
//  Created by os on 2020/12/3.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "XMG_FriendCirleCell.h"
   
@interface XMG_FriendCirleCell()

@property (nonatomic,weak)UIImageView *titleImg;
@property (nonatomic,weak)UILabel *subTitle;

@end
@implementation XMG_FriendCirleCell

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
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
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
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    
    
    return self;
}

- (void)setUserBaseModel:(TFJunYou_UserBaseObj *)userBaseModel {
    
    _userBaseModel=userBaseModel;
    _titleImg.image=[UIImage imageNamed:userBaseModel.userId];
    self.subTitle.text=userBaseModel.userNickname;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XMG_FriendCirleCell";
    XMG_FriendCirleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XMG_FriendCirleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone; 
    }
    
    
    return cell;
}

 
@end

