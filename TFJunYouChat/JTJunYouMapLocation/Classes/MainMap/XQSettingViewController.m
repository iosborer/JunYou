//
//  XQSettingViewController.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/26.
//  Copyright © 2020 zengwOS.  All rights reserved.
//

#import "XQSettingViewController.h"

@interface XQSettingViewController () <UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , strong) NSArray *titleArr;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIView *tableHeaderView;
@end

@implementation XQSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
    }
    cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                                       [NSArray arrayWithObjects:
                                                        @"米",
                                                        @"英尺",
                                                        nil]];
        segmentedControl.frame = CGRectMake(kScreenW - 150, 12, 140, 36);
        NSNumber *segmentOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"segmentOn"];
        segmentedControl.selectedSegmentIndex  = segmentOn.integerValue;
        [segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:segmentedControl];
    }
    else if (indexPath.row == 1) {
        UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenW - 60, 12, 50, 36)];
        NSNumber *switchOn = [[NSUserDefaults standardUserDefaults] objectForKey:@"switchOn"];
        s.on = switchOn.boolValue;
        [s addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:s];
    }
    else if (indexPath.row == 2) {
        cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return cell;
}

- (void)segmentedControlAction:(UISegmentedControl *)segmentedControl {
    NSNumber *segmentOn = [NSNumber numberWithInteger:segmentedControl.selectedSegmentIndex];
    [[NSUserDefaults standardUserDefaults] setObject:segmentOn forKey:@"segmentOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)switchOn:(UISwitch *)s {
    NSNumber *switchOn = [NSNumber numberWithBool:s.on];
    [[NSUserDefaults standardUserDefaults] setObject:switchOn forKey:@"switchOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = kColorFromHex(0xeeeeee);
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        logo.image = kGetImage(@"AppIcon");
        logo.center = _tableHeaderView.center;
        [_tableHeaderView addSubview:logo];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableHeaderView.frame) - 1, CGRectGetWidth(_tableHeaderView.frame), 1)];
        line.backgroundColor = kColorFromHex(0xeeeeee);
        [_tableHeaderView addSubview:line];
    }
    return _tableHeaderView;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"海拔单位",@"设置震动",@"当前版本"];
    }
    return _titleArr;
}

@end
