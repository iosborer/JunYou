//
//  OrganizeSelectVC.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/14.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class OrganizeSelectVC;
@protocol OrganizeSelectVCDelegate <NSObject>

- (void)selectOrganizeVC:(OrganizeSelectVC *)selectVC selectArray:(NSMutableArray *)array;

@end
@interface OrganizeSelectVC : TFJunYou_admobViewController
@property (nonatomic,strong) NSMutableArray *seletedArray;
@property (nonatomic,weak) id<OrganizeSelectVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
