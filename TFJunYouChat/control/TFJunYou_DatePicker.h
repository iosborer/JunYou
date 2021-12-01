//
//  TFJunYou_DatePicker.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 15-1-7.
//  Copyright (c) 2015年 Reese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_DatePicker : UIView{
    TFJunYou_Label* _sel;
}
@property(nonatomic,strong) UIDatePicker* datePicker;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didSelect;
@property(assign) SEL didCancel;
@property(assign) SEL didChange;
@property(nonatomic,strong) NSString* hint;
//-(NSDate*)date;

@property(nonatomic,strong) NSDate* date;

@end
