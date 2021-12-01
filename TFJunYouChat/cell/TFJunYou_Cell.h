//
//  TFJunYou_Cell.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_BadgeView.h"

@interface TFJunYou_Cell : UITableViewCell{
    
}
@property (nonatomic,retain,setter=setTitle:) NSString*  title;
@property (nonatomic,strong) NSString*  subtitle;
@property (nonatomic,strong) NSString*  bottomTitle;
@property (nonatomic,strong) NSString*  headImage;
@property (nonatomic,strong) NSString*  bage;
@property (nonatomic,strong) NSString*  roomId;
@property (nonatomic,strong) NSString*  userId;
@property (strong, nonatomic) NSString * positionTitle;
@property (nonatomic,strong) TFJunYou_ImageView * headImageView;

@property (nonatomic) int index;
@property (nonatomic, assign) NSObject* delegate;
@property (nonatomic, assign) SEL		didTouch;
@property (nonatomic, assign) SEL       didDragout;
@property (nonatomic, assign) SEL       didReplay;
@property (nonatomic, assign) SEL       didDelMsg;


@property (nonatomic,strong) TFJunYou_Label*   lbTitle;
@property (nonatomic,strong) TFJunYou_Label*   lbBottomTitle;
@property (nonatomic,strong) TFJunYou_Label*   lbSubTitle;
@property (nonatomic,strong) TFJunYou_Label*   timeLabel;
@property (strong, nonatomic) UILabel * positionLabel;
@property (nonatomic, strong) TFJunYou_BadgeView* bageNumber;

@property (nonatomic,strong) TFJunYou_ImageView * notPushImageView;
@property (nonatomic,strong) TFJunYou_ImageView * replayView;
@property (nonatomic, strong) UIImageView *replayImgV;

@property (nonatomic, strong) id dataObj;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isSmall;
@property (nonatomic, assign) BOOL isNotPush;
@property (nonatomic, assign) BOOL isMsgVCCome; 

@property (nonatomic, strong) TFJunYou_UserObject *user;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UIButton *delBtn;

//存cell的badge用的dict
//@property (nonatomic,strong) NSMutableDictionary * bageDict;
//
//- (void) saveBadge:(NSString*)badge withTitle:(NSString*)titl;
- (void)setSuLabel:(NSString *)s;
-(void)setForTimeLabel:(NSString *)s;
//- (void)getHeadImage;


//-(void)msgCellDataSet:(TFJunYou_MsgAndUserObject *) msgObject indexPath:(NSIndexPath *)indexPath;
//-(void)groupCellDataSet:(NSDictionary *)dataDict indexPath:(NSIndexPath *)indexPath;
-(void)headImageViewImageWithUserId:(NSString *)userId roomId:(NSString *)roomIdStr;
@end
