//
//  TFJunYou_ExpertCell.h
//  TFJunYouChat
//
//  Created by MacZ on 2016/10/20.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFJunYou_NearCell : UICollectionViewCell

@property(nonatomic,assign) int fnId;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didTouch;

- (void)doRefreshNearExpert:(NSDictionary *)dict;

@end
