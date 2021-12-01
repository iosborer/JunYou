//
//  ViewController.m
//  TFJunYouChat
//
//  Created by lifengye on 2018/9/27.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_CalculatorVc.h"
#import "TFJunYou_CalculatorView.h"
#import "TFJunYou_ShowView.h"

@interface TFJunYou_CalculatorVc ()

@end

@implementation TFJunYou_CalculatorVc

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor whiteColor];
    //设置状态栏为白色
 
//    TFJunYou_ShowView *jtbvew=[[TFJunYou_ShowView alloc]init];
//    jtbvew.userInteractionEnabled=YES;
//    jtbvew.frame=CGRectMake(0, 0, 0, 0);
//
//    [self.view addSubview:jtbvew];
//
//}
//- (void)clickaaaaa{
    
    
    self.TFJunYou_CalculatorView = [[TFJunYou_CalculatorView alloc] initWithFrame:self.view.bounds];
    self.stack = [[TFJunYou_Stack alloc] init];
    [self.stack initStack];
    self.textString = [[NSMutableString alloc] initWithString:@""];

    for (UIButton *button in [self.TFJunYou_CalculatorView subviews]) {
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }

    [self.view addSubview:self.TFJunYou_CalculatorView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 20,TFJunYou__SCREEN_WIDTH-41, 203)];
    self.textView.backgroundColor = [UIColor blackColor];
    self.textView.textAlignment = NSTextAlignmentRight;
    self.textView.editable = NO;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.scrollEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:36];
    [self.TFJunYou_CalculatorView addSubview:self.textView];
    

    UIButton  *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame=CGRectMake(5, 20, 40, 24);
    
    
    UIImage *titeIMG = [[UIImage imageNamed:@"playback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [backButton setImage:titeIMG forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backClick{
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)click:(UIButton *)button{
    if (button.tag == 99) {
        
        if ([_textString length]>1&&[_textString hasPrefix:@"."]) {
            
            return;
        }
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
        if ([_textString length]==2&&[_textString hasPrefix:@"0"]&&[_textString hasSuffix:@"0"]) {
           [self.textString deleteCharactersInRange:NSMakeRange(0, 1)];
            return;
        }
        
        self.textView.text = _textString;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
