//
//  TFJunYou_GroupMemberCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/10/11.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_GroupMemberCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)TFJunYou_Label *label;
- (void)buildNewImageview;

@end

NS_ASSUME_NONNULL_END
