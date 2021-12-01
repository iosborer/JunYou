//
//  TFJunYou_CameraVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/11/6.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFJunYou_CameraVC;
@protocol TFJunYou_CameraVCDelegate <NSObject>

- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithImage:(UIImage *)image;
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithVideoPath:(NSString *)filePath timeLen:(NSInteger)timeLen;

@end

@interface TFJunYou_CameraVC : UIViewController

@property (nonatomic, weak) id<TFJunYou_CameraVCDelegate>cameraDelegate;


@property(nonatomic,assign) int maxTime;
@property(nonatomic,assign) int minTime;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didRecord;
@property (nonatomic,strong) NSString* outputFileName;//返回的video


/**
 * isVideo  YES:开启视频录制,若不需要即不需赋值
 * isPhoto  YES:开启照片拍摄,若不需要即不需赋值
 * 若需要 视频录制、照片拍摄同时开启，即都不赋值
 */
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL isPhoto;


@end
