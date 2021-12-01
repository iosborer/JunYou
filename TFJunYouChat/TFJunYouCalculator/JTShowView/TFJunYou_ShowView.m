//
//  TFJunYou_ShowView.m
//  JTManyChildrenSongs
//
//  Created by os on 2020/9/19.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "TFJunYou_ShowView.h"
@interface TFJunYou_ShowView ()

@end

@implementation TFJunYou_ShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
         
        //设置状态栏为白色
        self.TFJunYou_CalculatorView = [[TFJunYou_CalculatorView alloc] initWithFrame:self.bounds];
        self.stack = [[TFJunYou_Stack alloc] init];
        [self.stack initStack];
        self.textString = [[NSMutableString alloc] initWithString:@""];
        
        for (UIButton *button in [self.TFJunYou_CalculatorView subviews]) {
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:self.TFJunYou_CalculatorView];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 414, 203)];
        self.textView.backgroundColor = [UIColor blackColor];
        self.textView.textAlignment = NSTextAlignmentRight;
        self.textView.editable = NO;
        self.textView.textColor = [UIColor whiteColor];
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont systemFontOfSize:36];
        [self.TFJunYou_CalculatorView addSubview:self.textView];
    }
    // Do any additional setup after loading the view, typically from a nib.
    
    return self;
    
}

- (void)click:(UIButton *)button{
    if (button.tag == 99) {
        [self.stack inStack:@"."];
        if (self.stack.last != 0){
            ;
        } else{
            [self.textString appendString:@"."];
        }
        self.textView.text = self.textString;
    }
    if (button.tag == 100) {
        [self.stack inStack:@"0"];
        [self.textString appendString:@"0"];
        self.textView.text = self.textString;
    }
    if (button.tag == 101) {
        [self.stack inStack:@"1"];
        [self.textString appendString:@"1"];
        self.textView.text = self.textString;
    }
    if (button.tag == 102) {
        [self.stack inStack:@"2"];
        [self.textString appendString:@"2"];
        self.textView.text = self.textString;
    }
    if (button.tag == 103) {
        [self.stack inStack:@"3"];
        [self.textString appendString:@"3"];
        self.textView.text = self.textString;
    }
    if (button.tag == 104) {
        [self.stack inStack:@"4"];
        [self.textString appendString:@"4"];
        self.textView.text = self.textString;
    }
    if (button.tag == 105) {
        [self.stack inStack:@"5"];
        [self.textString appendString:@"5"];
        self.textView.text = self.textString;
    }
    if (button.tag == 106) {
        [self.stack inStack:@"6"];
        [self.textString appendString:@"6"];
        self.textView.text = self.textString;
    }
    if (button.tag == 107) {
        [self.stack inStack:@"7"];
        [self.textString appendString:@"7"];
        self.textView.text = self.textString;
    }
    if (button.tag == 108) {
        [self.stack inStack:@"8"];
        [self.textString appendString:@"8"];
        self.textView.text = self.textString;
    }
    if (button.tag == 109) {
        [self.stack inStack:@"9"];
        [self.textString appendString:@"9"];
        self.textView.text = self.textString;
    }
    if (button.tag == 110) {
        [self.stack inStack:@"AC"];
        [self.textString setString:@""];
        self.textView.text = self.textString;
    }
    if (button.tag == 111) {
        [self.stack inStack:@"("];
        [self.textString appendString:@"("];
        self.textView.text = self.textString;
    }
    if (button.tag == 112) {
        [self.stack inStack:@")"];
        [self.textString appendString:@")"];
        self.textView.text = self.textString;
    }
    if (button.tag == 113) {
        [self.stack inStack:@"+"];
        NSString *str = [[NSString alloc] initWithString:self.stack.symbolStack[self.stack.symbolTop]];
        if (self.stack.last == 1) {
            [self.textString deleteCharactersInRange:NSMakeRange([self.textString length]-1, 1)];
        }
        [self.textString appendString:str];
        self.textView.text = self.textString;
    }
    if (button.tag == 114) {
        [self.stack inStack:@"-"];
        NSString *str = [[NSString alloc] initWithString:self.stack.symbolStack[self.stack.symbolTop]];
        if (self.stack.last == 1) {
            [self.textString deleteCharactersInRange:NSMakeRange([self.textString length]-1, 1)];
        }
        [self.textString appendString:str];
        self.textView.text = self.textString;
    }
    if (button.tag == 115) {
        [self.stack inStack:@"×"];
        NSString *str = [[NSString alloc] initWithString:self.stack.symbolStack[self.stack.symbolTop]];
        if (self.stack.last == 1) {
            [self.textString deleteCharactersInRange:NSMakeRange([self.textString length]-1, 1)];
        }
        [self.textString appendString:str];
        self.textView.text = self.textString;
    }
    if (button.tag == 116) {
        [self.stack inStack:@"÷"];
        NSString *str = [[NSString alloc] initWithString:self.stack.symbolStack[self.stack.symbolTop]];
        if (self.stack.last == 1) {
            [self.textString deleteCharactersInRange:NSMakeRange([self.textString length]-1, 1)];
        }
        [self.textString appendString:str];
        self.textView.text = self.textString;
    }
    if (button.tag == 117) {
        [self.stack inStack:@"="];
        
        if (self.stack.over == 1) {
            NSNumber *t = self.stack.numberStack[self.stack.numberTop];
            NSString *str = [NSString stringWithFormat:@"%@", t];
            self.textView.text = str;
            [self.textString setString:str];
        } else{
            self.textView.text = @"出错";
            [self.textString setString:@""];
        }
    }
}

 


@end
