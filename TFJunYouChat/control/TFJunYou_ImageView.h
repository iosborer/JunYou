//
//  TFJunYou_ImageView.h
//  textScr
//
//  Created by JK PENG on 11-8-17.
//  Copyright 2011年 Devdiv. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TFJunYou_ImageView_Animation_None 0 //无动画
#define TFJunYou_ImageView_Animation_Line 1 //渐变
#define TFJunYou_ImageView_Animation_More 2 //多变

@class TFJunYou_ImageView;
@protocol TFJunYou_ImageViewPanDelegate <NSObject>

- (void)tapImageView:(TFJunYou_ImageView *)imageView;

- (void)changeWhenPan:(TFJunYou_ImageView *)sender gesture:(UILongPressGestureRecognizer *)gesture;

- (void)getTouchWhenMove:(TFJunYou_ImageView *)imageView withTouch:(NSSet *)touch withEvent:(UIEvent *)event withLongPressGes:(UILongPressGestureRecognizer *)lpGes;

@end

@interface TFJunYou_ImageView : UIImageView {
    int         _oldAlpha;
    BOOL        _canChange;
}
//为了先获取图片Size,后设置TFJunYou_Imageview大小，专设的变量
@property (nonatomic) CGSize imageSize;

@property (nonatomic, weak) NSObject* delegate;
@property (nonatomic,weak) id<TFJunYou_ImageViewPanDelegate> panDelegate;
@property (nonatomic, assign) SEL		didTouch;
@property (nonatomic, assign) SEL		didDragout;
@property (nonatomic, assign) BOOL      changeAlpha;
@property (nonatomic, assign) BOOL      selected;
@property (nonatomic, assign) BOOL      enabled;
@property (nonatomic, assign) int       animationType;//动画类型，0:没有；1:渐变；2:多变

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

- (void)addTapGesture;
- (void)addLongPressGesture;

@end
