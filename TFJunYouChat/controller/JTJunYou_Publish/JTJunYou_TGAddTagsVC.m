//
//  JTJunYou_TGAddTagsVC.m
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "JTJunYou_TGAddTagsVC.h"

@interface JTJunYou_TGAddTagsVC ()

@end

@implementation JTJunYou_TGAddTagsVC

- (void)backButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

    
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"xx"];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 20)];
    [backButton setImage:[UIImage imageNamed:@"title_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    // Do any additional setup after loading the view.
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
