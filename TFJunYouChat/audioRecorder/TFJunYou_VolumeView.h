//
//  TFJunYou_VolumeView.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-7-24.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFJunYou_VolumeView : UIView{
    TFJunYou_ImageView* _input;
    TFJunYou_ImageView* _volume;

}
@property(nonatomic,assign) double volume;

@property (nonatomic, assign) BOOL isWillCancel;

-(void)show;
-(void)hide;
@end
