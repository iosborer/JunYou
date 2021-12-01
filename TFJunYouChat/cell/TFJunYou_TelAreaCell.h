//
//  TFJunYou_TelAreaCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/4/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TELAREA_CELL_HEIGHT 42

@interface TFJunYou_TelAreaCell : UITableViewCell{
    UILabel *_countryName;
    UILabel *_areaNum;
}

@property (nonatomic,strong) UIView *bottomLine;

- (void)doRefreshWith:(NSDictionary *)dict language:(NSString *)language;

@end
