//
//  TFJunYou_FAQCenterDetailVC.m
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/8.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_FAQCenterDetailVC.h"
#import "TFJunYou_FAQCenterDetailItemVC.h"

@implementation TFJunYou_FAQCenterDetailModel
@end

@interface TFJunYou_FAQCenterDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TFJunYou_FAQCenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    NSString *typeString = @"常见问题";
    switch (_type) {
        case 1:
            typeString = @"快讯号设置";
            break;
        case 2:
            typeString = @"好友添加";
            break;
        case 3:
            typeString = @"收发消息";
            break;
        case 4:
            typeString = @"快讯群聊";
            break;
        case 5:
            typeString = @"快讯";
            break;
        case 6:
            typeString = @"快讯支付";
            break;
        default:
            typeString = @"常见问题";
            break;
    }
    self.title = typeString;
    [self.tableBody addSubview:self.tableView];
    [self getData];
}

- (void)getData {
    [g_server get_act_ApiEditGetListByType:[NSString stringWithFormat:@"%d", _type] toView:self];
}


- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT - TFJunYou__SCREEN_TOP) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.rowHeight = 50;
        if (@available(iOS 11.0, *))
            {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        else
            {
            self.automaticallyAdjustsScrollViewInsets = NO;
            }
        _tableView = tableView;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    TFJunYou_FAQCenterDetailModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TFJunYou_FAQCenterDetailModel *model = _dataArray[indexPath.row];
    TFJunYou_FAQCenterDetailItemVC *vc = [TFJunYou_FAQCenterDetailItemVC new];
    vc.model = model;
    [g_navigation pushViewController:vc animated:YES];
}


- (void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1 {
    [_wait hide];
    if ([aDownload.action isEqualToString:act_ApiEditGetListByType]) {
        _dataArray = [TFJunYou_FAQCenterDetailModel mj_objectArrayWithKeyValuesArray:array1];
        [self.tableView reloadData];
    }
}

- (int)didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict {
    [_wait hide];
    return show_error;
}

- (int)didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error {//error为空时，代表超时
    [_wait hide];
    return show_error;
}

- (void)didServerConnectStart:(TFJunYou_Connection*)aDownload {
    [_wait start];
}


@end
