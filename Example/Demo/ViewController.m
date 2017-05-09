//
//  ViewController.m
//  Demo
//
//  Created by n369 on 16/8/30.
//  
//

#import "ViewController.h"
#import "SXTopMenuView.h"

@interface ViewController () {
    UIImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after 
    
    
    SXTopMenuView *view = [[SXTopMenuView alloc] initWithFrame:CGRectMake(0, 20, 375, 647) titles:@[@"推荐", @"今天不加班", @"上海", @"英雄联盟", @"社区", @"iPhone 8要火", @"视频", @"美剧", @"其他"]];
    [view setTitleCurrentColorR:.3 G:.4 B:.5];
    [view setTitleNomalColorR:.7 G:.6 B:.5];
    view.currentFont = 20;
    view.layoutDistance = 80;
    
    [self.view addSubview:view];
}

- (void)rightAction:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
