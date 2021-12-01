//
//  TFJunYou_FAQCenterDetailItemVC.m
//  TFJunYouChat
//
//  Created by JayLuo on 2021/2/8.
//  Copyright © 2021 zengwOS. All rights reserved.
//

#import "TFJunYou_FAQCenterDetailItemVC.h"
#import "TFJunYou_FAQCenterDetailVC.h"

@interface TFJunYou_FAQCenterDetailItemVC ()

@end

@implementation TFJunYou_FAQCenterDetailItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = YES;
    
    [self createHeadAndFoot];
    
    self.title = _model.title;
        
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT - TFJunYou__SCREEN_TOP)];
    [textView setEditable:NO];
    [self.tableBody addSubview:textView];
    
    NSString *htmlString  =[NSString stringWithFormat:@"%@",_model.content];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error: nil];
    
    textView.attributedText = attributedString;
    
}


@end
