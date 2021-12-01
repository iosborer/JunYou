//
//  topImageBottomTitleView.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/25.
//  Copyright © 2020 zengwOS.  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class topImageBottomTitleView;
@protocol topImageBottomTitleViewTapDelegate <NSObject>

- (void)topImageBottomTitleViewTapWithView:(topImageBottomTitleView *)view;

@end
@interface topImageBottomTitleView : UIView
- (void)setUIWithDic:(NSDictionary *)dic;
@property (nonatomic , weak) id<topImageBottomTitleViewTapDelegate> delegate;
@property (nonatomic , assign) BOOL checked;
@end

NS_ASSUME_NONNULL_END
