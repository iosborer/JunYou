//
//  ViewController.h
//  TFJunYouChat
//
//  Created by lifengye on 2018/9/27.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_CalculatorView.h"
#import "TFJunYou_Stack.h"

@interface TFJunYou_CalculatorVc : UIViewController

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) TFJunYou_CalculatorView *TFJunYou_CalculatorView;
@property(nonatomic, strong) TFJunYou_Stack *stack;
@property(nonatomic, strong) NSMutableString *textString;

@end

