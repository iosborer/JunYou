//
//  TFJunYou_WaitView.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 17/1/13.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFJunYou_WaitView : UIActivityIndicatorView{
    UIView* _parent;
}

-(id)initWithParent:(UIView*)parent;
-(void)start;
-(void)stop;
-(void)adjust;

@property (nonatomic, strong,setter=setParent:) UIView* parent;//可动态改变父亲

@end
