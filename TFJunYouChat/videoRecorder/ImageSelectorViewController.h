//
//  ImageSelectorViewController.h
//  TFJunYouChat
//
//  Created by 1 on 17/1/19.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

@protocol ImageSelectorViewDelegate <NSObject>

-(void)imageSelectorDidiSelectImage:(NSString *)imagePath;

@end

@interface ImageSelectorViewController : TFJunYou_admobViewController


@property (nonatomic,strong) NSArray * imageFileNameArray;
@property (nonatomic, weak) id<ImageSelectorViewDelegate> imgDelegete;

@end
