//
//  TFJunYou_ChatLogVC.m
//  TFJunYouChat
//
//  Created by p on 2018/7/5.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_ChatLogVC.h"
#import "TFJunYou_BaseChatCell.h"
#import "TFJunYou_MessageCell.h"
#import "TFJunYou_ImageCell.h"
#import "TFJunYou_LocationCell.h"
#import "TFJunYou_GifCell.h"
#import "TFJunYou_VideoCell.h"
#import "TFJunYou_EmojiCell.h"
#import "TFJunYou_FaceCustomCell.h"

@interface TFJunYou_ChatLogVC ()

@end

@implementation TFJunYou_ChatLogVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HEXCOLOR(0xF2F2F2);
    self.tableView.backgroundColor = HEXCOLOR(0xF2F2F2);
    self.isShowFooterPull = NO;
    self.isShowHeaderPull = NO;
    self.isGotoBack = YES;

    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    //self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    [self createHeadAndFoot];
    
    
    [self.tableView reloadData];
    
}


- (void)actionQuit {
    [super actionQuit];
}

#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_MessageObject *msg=[_array objectAtIndex:indexPath.row];
    
    NSLog(@"indexPath.row:%ld,%ld",indexPath.section,indexPath.row);
    
    //返回对应的Cell
    TFJunYou_BaseChatCell * cell = [self getCell:msg indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    msg.changeMySend = 1;
    cell.msg = msg;
    cell.indexNum = (int)indexPath.row;
    cell.delegate = self;
    //    cell.chatCellDelegate = self;
    //    cell.readDele = @selector(readDeleWithUser:);
    cell.isShowHead = YES;
    [cell setCellData];
    [cell setHeaderImage];
    [cell setBackgroundImage];
    [cell isShowSendTime];
    //转圈等待
    if ([msg.isSend intValue] == transfer_status_ing) {
        [cell drawIsSend];
    }
    msg = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_MessageObject *msg=[_array objectAtIndex:indexPath.row];
    
    switch ([msg.type intValue]) {
        case kWCMessageTypeText:
            return [TFJunYou_MessageCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeImage:
            return [TFJunYou_ImageCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeCustomFace:
            return [TFJunYou_FaceCustomCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeEmoji:
            return [TFJunYou_EmojiCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeLocation:
            return [TFJunYou_LocationCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeGif:
            return [TFJunYou_GifCell getChatCellHeight:msg];
            break;
        case kWCMessageTypeVideo:
            return [TFJunYou_VideoCell getChatCellHeight:msg];
            break;
        default:
            return [TFJunYou_BaseChatCell getChatCellHeight:msg];
            break;
    }
}


#pragma mark -----------------获取对应的Cell-----------------
- (TFJunYou_BaseChatCell *)getCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    TFJunYou_BaseChatCell * cell = nil;
    switch ([msg.type intValue]) {
        case kWCMessageTypeText:
            cell = [self creatMessageCell:msg indexPath:indexPath];
            break;
            
        case kWCMessageTypeImage:
            cell = [self creatImageCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeCustomFace:
            cell = [self creatFaceCustomCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeEmoji:
            cell = [self creatEmojiCell:msg indexPath:indexPath];
            break;
        case kWCMessageTypeLocation:
            cell = [self creatLocationCell:msg indexPath:indexPath];
            break;
            
        case kWCMessageTypeGif:
            cell = [self creatGifCell:msg indexPath:indexPath];
            break;
            
        case kWCMessageTypeVideo:
            cell = [self creatVideoCell:msg indexPath:indexPath];
            break;
        default:
            cell = [[TFJunYou_BaseChatCell alloc] init];
            break;
    }
    return cell;
}
#pragma  mark -----------------------创建对应的Cell---------------------
//文本
- (TFJunYou_BaseChatCell *)creatMessageCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_MessageCell";
    TFJunYou_MessageCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    return cell;
}
//图片
- (TFJunYou_BaseChatCell *)creatImageCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_ImageCell";
    TFJunYou_ImageCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_ImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //        cell.chatImage.delegate = self;
        //        cell.chatImage.didTouch = @selector(onCellImage:);
    }
    return cell;
}
// 自定义表情
- (TFJunYou_BaseChatCell *)creatFaceCustomCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_FaceCustomCell";
    TFJunYou_FaceCustomCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_FaceCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //        cell.chatImage.delegate = self;
        //        cell.chatImage.didTouch = @selector(onCellImage:);
    }
    return cell;
}

// 表情包
- (TFJunYou_BaseChatCell *)creatEmojiCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_EmojiCell";
    TFJunYou_EmojiCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_EmojiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //        cell.chatImage.delegate = self;
        //        cell.chatImage.didTouch = @selector(onCellImage:);
    }
    return cell;
}
//视频
- (TFJunYou_BaseChatCell *)creatVideoCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_VideoCell";
    TFJunYou_VideoCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_VideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//位置
- (TFJunYou_BaseChatCell *)creatLocationCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_LocationCell";
    TFJunYou_LocationCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//动画
- (TFJunYou_BaseChatCell *)creatGifCell:(TFJunYou_MessageObject *)msg indexPath:(NSIndexPath *)indexPath{
    NSString * identifier = @"TFJunYou_GifCell";
    TFJunYou_GifCell *cell=[_table dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_GifCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
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
