//
//  TFJunYou_ShowView.h
//  JTManyChildrenSongs
//
//  Created by os on 2020/9/19.
//  Copyright © 2020 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_CalculatorView.h"
#import "TFJunYou_Stack.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_ShowView : UIView

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) TFJunYou_CalculatorView *TFJunYou_CalculatorView;
@property(nonatomic, strong) TFJunYou_Stack *stack;
@property(nonatomic, strong) NSMutableString *textString;
@end

NS_ASSUME_NONNULL_END
