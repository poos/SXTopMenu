//
//  SXTopMenuView.h
//  iOS_eFarming
//
//  Created by Shown on 2017/5/8.
//  Copyright © 2017年 n369. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXTopMenuView : UIView
#pragma mark - 自定义 可选
/**
 默认的初始化如下,view 在didMoveToSuperview时候加载视图
 
 //顶部scroll高度
 _topHeight = 44;
 
 //开始调整的距离
 _layoutDistance = 44;
 
 //标题button的title两边的距离
 _titleDistance = 24;
 
 //顶部scroll的背景色
 _topBackColor = [UIColor whiteColor];
 
 //点击的时候动画时间
 _amimateDuration = .1;
 
 //选择和为选中字体大小     建议大小一致,不一致scroll滑动时字体会抖动,以后会另开一个工程研究label的drawRect
 _currentFont = 16;
 _nomalFont = 16;
 
 //选中和为选中字体颜色
 _currentColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
 _nomalColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
 
 //指示线的颜色
 _singleLineColor = [UIColor colorWithRed:44/255.0 green:147/255.0 blue:253/255.0 alpha:1];
 */
@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign) CGFloat layoutDistance;
@property (nonatomic, assign) CGFloat titleDistance;
@property (nonatomic, strong) UIColor *topBackColor;


@property (nonatomic, assign) double amimateDuration;

@property (nonatomic, assign) CGFloat currentFont;
@property (nonatomic, assign) CGFloat nomalFont;

@property (nonatomic, strong) UIColor *singleLineColor;

@property (nonatomic, strong) NSArray *titleArr;

- (void)setTitleCurrentColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;
- (void)setTitleNomalColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;

#pragma mark - 初始化 必须

/**
 初始化方法

 @param titles 设置顶部title的数组,字符串类型
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles;

/**
 设置下边的view数组, 加载会设置frame (hight <- view.height-topHeight)
 
 不设置会生成占位随机色view
 */
@property (nonatomic, strong) NSArray <UIView *>*viewArr;

@end
