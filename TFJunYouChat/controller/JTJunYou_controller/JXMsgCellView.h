//
//  JXMsgCellView.h
//  shiku_im
//
//  Created by 123 on 2020/6/11.
//  Copyright © 2020 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MsgCellViewBlock)(NSInteger tag);
@interface JXMsgCellView : UIView
 

@property (weak, nonatomic) IBOutlet UIView *friendViewTap;

@property (weak, nonatomic) IBOutlet UIView *groundChatView;
@property (weak, nonatomic) IBOutlet UIView *addresView;
@property (weak, nonatomic) IBOutlet UIView *jixinView;
 

@property (nonatomic,copy) MsgCellViewBlock blockTap;
+(instancetype)XIBMsgCellView;


@property (nonatomic,copy) NSString *bageNumber;
@end
