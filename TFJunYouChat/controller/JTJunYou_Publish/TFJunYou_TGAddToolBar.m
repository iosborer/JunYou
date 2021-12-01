//
//  TFJunYou_TGAddToolBar.m
//  TFJunYouChat
//
//  Created by mac on 2020/5/20.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_TGAddToolBar.h"
#import "JTJunYou_TGAddTagsVC.h"
#import "UIView+Frame.h"

@interface TFJunYou_TGAddToolBar()
@property (weak, nonatomic) UIView *topV;
@property (weak ,nonatomic) UIButton *addBtn;
@property (strong , nonatomic)NSMutableArray *tagLbls;
@end

@implementation TFJunYou_TGAddToolBar

-(NSMutableArray *)tagLbls{
    if (!_tagLbls) {
        _tagLbls = [NSMutableArray array];
    }
    return _tagLbls;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)addBtnClick{
    JTJunYou_TGAddTagsVC *addTagsVc = [[JTJunYou_TGAddTagsVC alloc]init];
    __weak typeof(self)weakSelf = self;
    addTagsVc.tagsBlock = ^(NSArray *tags){
        [weakSelf creatTags:tags];
    };
    addTagsVc.tags = [self.tagLbls valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:addTagsVc animated:YES];
}

- (void)creatTags:(NSArray *)tags{
    [self.tagLbls makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLbls removeAllObjects];
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (NSInteger i = 0; i < self.tagLbls.count; i++) {
       
    }
 
}


@end
