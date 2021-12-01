//
//  TFJunYou_SearchMoreCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/30.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_SearchMoreCell : UITableViewCell
@property (nonatomic,strong) NSString *imgName;
@property (nonatomic,strong) NSString *moreName;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UIImageView *ImgView;
@property (nonatomic,strong) UILabel *moreLable;
@property (nonatomic,strong) UIView *selectView;

@end

NS_ASSUME_NONNULL_END
