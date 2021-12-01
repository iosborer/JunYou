//
//  JTYouJun_ContaintMapVc.h
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

 

NS_ASSUME_NONNULL_BEGIN

@interface JTYouJun_ContaintMapVc : UIViewController

/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
 
  

@property (nonatomic,weak) UIButton *topButton;
 
@end
  
NS_ASSUME_NONNULL_END
