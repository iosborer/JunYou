//
//  TFJunYou_TableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_TableView.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

@class TFJunYou_Label;
@class TFJunYou_TableView;
@protocol TFJunYou_TableViewDelegate;

@interface TFJunYou_TableViewController : UIViewController<TFJunYou_TableViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    BOOL _isLoading;
    //refresh一次page＋1
    int  _page;
    
    TFJunYou_TableView* _table;
    
    int _tableHeight;    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    ATMHud* _wait;
//    TFJunYou_TableViewController* _pSelf;
    int _oldRowCount;//翻页之前的行数
    NSTimeInterval _lastScrollTime;
}

@property (nonatomic, strong) TFJunYou_TableView* tableView;

@property(nonatomic,assign) BOOL isGotoBack;
@property(nonatomic,assign) BOOL isFreeOnClose;
@property(nonatomic,assign) BOOL isShowHeaderPull;
@property(nonatomic,assign) BOOL isShowFooterPull;
@property(nonatomic,strong) UIView *tableHeader;
@property(nonatomic,strong) UIView *tableFooter;
@property(nonatomic,assign) int heightHeader;
@property(nonatomic,assign) int heightFooter;
@property(nonatomic,strong) UIButton *footerBtnMid;
@property(nonatomic,strong) UIButton *footerBtnLeft;
@property(nonatomic,strong) UIButton *footerBtnRight;
@property(nonatomic,strong) TFJunYou_Label  *headerTitle;
@property(nonatomic,strong) MJRefreshFooterView *footer;
@property(nonatomic,strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) UIButton *gotoBackBtn;



-(void)setupStrings;
-(void)stopLoading;
-(void)createHeadAndFoot;
-(void)scrollToPageUp;
-(void)scrollToPageDown;
-(void)getServerData;
-(void)actionQuit;
-(void)onGotoHome;
-(void)doQuit;
-(void)actionTitle:(TFJunYou_Label*)sender;
-(void)doAutoScroll:(NSIndexPath*)indexPath;

//获取_table
- (TFJunYou_TableView *)getTableView;
- (void)moveSelfViewToLeft;
- (void)resetViewFrame;
@end
