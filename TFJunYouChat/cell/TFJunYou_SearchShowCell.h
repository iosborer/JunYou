//
//  TFJunYou_SearchRecordCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/8/27.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,TFJunYou_SearchShowCellStyle){
    TFJunYou_SearchShowCellStyleUser,
    TFJunYou_SearchShowCellStyleRecord,
};
NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_SearchShowCell : UITableViewCell
@property (nonatomic,assign)TFJunYou_SearchShowCellStyle cellStyle;
@property (nonatomic,strong)UIImageView *headImgView;
@property (nonatomic,strong)UILabel *aboveLable;
@property (nonatomic,strong)UILabel *belowLable;
@property (nonatomic,strong)UILabel *rightLable;
@property (nonatomic,strong)NSString *headImg;
@property (nonatomic,strong)NSString *aboveText;
@property (nonatomic,strong)NSMutableAttributedString *aboveAttributedText;
@property (nonatomic,strong)NSString *belowText;
@property (nonatomic,strong)NSMutableAttributedString *belowAttributedText;
@property (nonatomic,strong)NSString *rightText;
@property (nonatomic,strong)UIView *selectView;
@property (nonatomic,strong)NSString *searchText;
@property (nonatomic,assign)NSInteger num;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withNewStyle:(TFJunYou_SearchShowCellStyle)newStyle;
- (void)cutSelectedView;
@end

NS_ASSUME_NONNULL_END
