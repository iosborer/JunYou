//
//  TFJunYou_ReadListVC.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/2.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_ReadListVC.h"
#import "TFJunYou_ReadListCell.h"

@interface TFJunYou_ReadListVC ()
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation TFJunYou_ReadListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack = YES;
    //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT-TFJunYou__SCREEN_BOTTOM);
    [self createHeadAndFoot];
    
    self.title = Localized(@"JX_ReadList");
    _array = [NSMutableArray array];

    
    [self getLocData];
}

- (void) getLocData {
    _array = [self.msg fetchReadList];

    
    [self.tableView reloadData];
}

#pragma mark   ---------tableView协议----------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSString* cellName = [NSString stringWithFormat:@"readListCell"];
    TFJunYou_ReadListCell *readListCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!readListCell) {
        readListCell = [[TFJunYou_ReadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    readListCell.room = _room;
    TFJunYou_UserObject * obj = _array[indexPath.row];
    [readListCell setData:obj];
    
    return readListCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
