//
//  TFJunYou_CustomButton.m
//  TFJunYouChat
//
//  Created by 1 on 17/8/15.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_CustomButton.h"

@implementation TFJunYou_CustomButton


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}


@end
