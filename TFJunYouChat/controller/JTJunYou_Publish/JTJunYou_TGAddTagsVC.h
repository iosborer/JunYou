//
//  JTJunYou_TGAddTagsVC.h
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TagsBlock)(NSArray *tags);
NS_ASSUME_NONNULL_BEGIN

@interface JTJunYou_TGAddTagsVC : UIViewController
@property (nonatomic, copy) TagsBlock tagsBlock;
@property (nonatomic, strong) NSMutableArray *tags;
@end

NS_ASSUME_NONNULL_END
