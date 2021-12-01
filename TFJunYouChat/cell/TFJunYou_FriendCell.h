//
//  TFJunYou_FriendCell.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFJunYou_FriendObject;
@class TFJunYou_FriendCell;

@protocol TFJunYou_FriendCellDelegate <NSObject>

- (void) friendCell:(TFJunYou_FriendCell *)friendCell headImageAction:(NSString *)userId;

@end

@interface TFJunYou_FriendCell : UITableViewCell{
    UIImageView* bageImage;
    UILabel* bageNumber;
    UIButton* _btn2;
    UIButton* _btn1;
    UILabel* _lbSubtitle;
    UILabel* _timeLab;
}
@property (nonatomic,strong) NSString*  title;
@property (nonatomic,strong) NSString*  subtitle;
@property (nonatomic,strong) NSString*  rightTitle;
@property (nonatomic,strong) NSString*  bottomTitle;
@property (nonatomic,strong) NSString*  headImage;
@property (nonatomic,strong) NSString*  bage;
@property (nonatomic,strong) TFJunYou_FriendObject* user;
@property (nonatomic,strong) id target;
@property (nonatomic, weak) id<TFJunYou_FriendCellDelegate>delegate;

@property (nonatomic, strong) UIView* lineView;

-(void)update;

@end
