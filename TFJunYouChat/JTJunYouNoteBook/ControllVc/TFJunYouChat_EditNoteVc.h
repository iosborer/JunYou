//
//  TFJunYouChat_EditNoteVc.h
//  P-Note
//
//  Created by yaxiongfang on 4/9/16.
//  Copyright © 2016 yxfang. All rights reserved.
//

#import "TFJunYouChat_BaseNoteVc.h"

@class Note;

NS_ASSUME_NONNULL_BEGIN
@interface TFJunYouChat_EditNoteVc : TFJunYouChat_BaseNoteVc

@property int folderId;

@property(nonatomic, strong) Note *note;

@property(weak, nonatomic) IBOutlet UITextView *edtContent;

@property(weak, nonatomic) IBOutlet UITextField *edtTitle;

@end

NS_ASSUME_NONNULL_END
