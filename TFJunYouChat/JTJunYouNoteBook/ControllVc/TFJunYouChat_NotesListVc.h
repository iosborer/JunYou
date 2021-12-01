// 笔记列表
// Created by yaxiongfang on 4/9/16.
// Copyright (c) 2016 yxfang. All rights reserved.
//

#import "TFJunYouChat_BaseNoteVc.h"


NS_ASSUME_NONNULL_BEGIN
@interface TFJunYouChat_NotesListVc : TFJunYouChat_BaseNoteVc <UITableViewDelegate, UITableViewDataSource>

/**
 * 携带参数初始化
 */
- (id)init:(int)folderId andName:(NSString *)folderName;

// 分类目录id
@property int folderId;

// 分类目录名称
@property(nonatomic, strong) NSString *folderName;

@end

NS_ASSUME_NONNULL_END
