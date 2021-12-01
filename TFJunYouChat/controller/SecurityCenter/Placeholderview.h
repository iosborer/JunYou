//
//  Placeholderview.h
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/6.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Placeholderview : UITextView
@property(nonatomic,copy) NSString *placeholder;
@property(nonatomic,strong) UIColor *placeColor;
@end

NS_ASSUME_NONNULL_END
