//
//  TFJunYou_ShareFileTableViewCell.h
//  TFJunYouChat
//
//  Created by 1 on 17/7/6.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFJunYou_ShareFileObject;

@interface TFJunYou_ShareFileTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView * typeView;
@property (strong, nonatomic) UILabel * fileTitleLabel;
@property (strong, nonatomic) UILabel * sizeLabel;
@property (strong, nonatomic) UILabel * fromLabel;
@property (strong, nonatomic) TFJunYou_Label * fromUserLabel;
@property (strong, nonatomic) UILabel * timeLabel;
@property (strong, nonatomic) UIImageView * didDownView;
@property (strong, nonatomic) UIProgressView * progressView;
@property (strong, nonatomic) UIButton * downloadStateBtn;

@property (strong, nonatomic) TFJunYou_ShareFileObject *shareFile;

-(void)setShareFileListCellWith:(TFJunYou_ShareFileObject *)shareFileObjcet indexPath:(NSIndexPath *) indexPath;
@end
