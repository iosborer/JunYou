//
//  TFJunYou_MYViewController.m
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_MYViewController.h"
#import "TFJunYou_MYView.h"

@interface TFJunYou_MYViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *talbView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TFJunYou_MYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr=[NSMutableArray array];
    
   UITableView *talbView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    talbView.delegate=self;
    talbView.dataSource=self;
    [self.view addSubview:talbView];
    self.talbView=talbView;
    [talbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    [talbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    NSArray *dictArr=@[@{@"icon":@"my_space_simple",@"title":Localized(@"JX_MyDynamics")},@{@"icon":@"collection_me_simple",@"title":Localized(@"JX_MyCollection")},@{@"icon":@"my_lecture_simple",@"title":Localized(@"JX_MyLecture")},@{@"icon":@"videomeeting_simple",@"title":Localized(@"JXSettingVC_VideoMeeting")},@{@"icon":@"set_up_simple",@"title":Localized(@"JXSettingVC_Set")}];
    
    [_dataArr addObjectsFromArray:dictArr];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    NSDictionary *dictCell=_dataArr[indexPath.row];
    
    cell.imageView.image=[UIImage imageNamed:dictCell[@"icon"]];
    cell.textLabel.text=dictCell[@"title"];
    return cell;
   
}

@end
