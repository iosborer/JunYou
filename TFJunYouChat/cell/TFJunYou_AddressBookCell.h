//
//  TFJunYou_AddressBookCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/09/30.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCheckBox.h"
#import "TFJunYou_AddressBook.h"

@class TFJunYou_AddressBookCell;
@protocol TFJunYou_AddressBookCellDelegate <NSObject>

- (void)addressBookCell:(TFJunYou_AddressBookCell *)abCell checkBoxSelectIndexNum:(NSInteger)indexNum isSelect:(BOOL)isSelect;
- (void)addressBookCell:(TFJunYou_AddressBookCell *)abCell addBtnAction:(TFJunYou_AddressBook *)addressBook;

@end

@interface TFJunYou_AddressBookCell : UITableViewCell <QCheckBoxDelegate>

@property (nonatomic, strong) TFJunYou_ImageView *headImage;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) QCheckBox *checkBox;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isShowSelect;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, weak) id<TFJunYou_AddressBookCellDelegate>delegate;

@property (nonatomic, strong) TFJunYou_AddressBook *addressBook;

@property (nonatomic, assign) BOOL isInvite;

@end
