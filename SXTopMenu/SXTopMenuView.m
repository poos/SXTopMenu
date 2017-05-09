//
//  SXTopMenuView.m
//  iOS_eFarming
//
//  Created by Shown on 2017/5/8.
//  Copyright © 2017年 n369. All rights reserved.
//


#import "SXTopMenuView.h"

@interface UIView (Addition)

//取得view宽/高
- (CGFloat)width;
- (CGFloat)height;
//取得view的上/下/左/右偏移
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)left;
- (CGFloat)right;
@end

@implementation UIView (Addition)
//取得view宽/高
- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}

//取得view的上/下/左/右偏移
- (CGFloat)top {
    return self.frame.origin.y;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)left {
    return self.frame.origin.x;
}
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
@end


@interface SXTopMenuView () <UIScrollViewDelegate> {
    UIScrollView *_topScroll;   //顶部的scroll
    NSMutableArray *_buttonArr; //用于存放button的arr
    NSInteger _lastInt;         //上次的button
    NSInteger _selectInt;       //选中的button
    UIView *_singleLine;        //下划线
    NSMutableArray *_singleLineRectArr;//记录singleRect
    
    UIScrollView *_mainScroll;  //下边scroll
    
    UIColor *_currentColor;
    CGFloat _currentR;
    CGFloat _currentG;
    CGFloat _currentB;
    UIColor *_nomalColor;
    CGFloat _nomalR;
    CGFloat _nomalG;
    CGFloat _nomalB;
}

@end
static NSInteger const buttonTag = 1001;

@implementation SXTopMenuView

#pragma mark - setAction

- (void)setTitleNomalColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b {
    _nomalColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    _nomalR = r;
    _nomalG = g;
    _nomalB = b;
}

- (void)setTitleCurrentColorR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b {
    _currentColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    _currentR = r;
    _currentG = g;
    _currentB = b;
}

- (void)createView {
    
    [self createTopView];
    [self createMainView];
    
}


- (void)createTopView {
    _topScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, _topHeight)];
    _topScroll.showsHorizontalScrollIndicator = NO;
    _topScroll.backgroundColor = _topBackColor;
    [self addSubview:_topScroll];
    [self createTitles];
    [self createSingleLine];
}

- (void)createMainView {
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topHeight, self.width, self.height - _topHeight)];
    _mainScroll.contentSize = CGSizeMake(self.width * _buttonArr.count, 0);
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.pagingEnabled = YES;
    _mainScroll.delegate = self;
    [self addSubview:_mainScroll];
    
    //添加各个view
    for (int i = 0; i < _buttonArr.count; i++) {
        if (i< _viewArr.count) {
            UIView *view = _viewArr[i];
            view.frame = CGRectMake(i * _mainScroll.width, 0, _mainScroll.width, _mainScroll.height);
            [_mainScroll addSubview:view];
        } else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * _mainScroll.width, 0, _mainScroll.width, _mainScroll.height)];
            view.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
            [_mainScroll addSubview:view];
        }
    }
}
- (void)createSingleLine {
    _singleLine = [[UILabel alloc] initWithFrame:CGRectMake(10, _topHeight-2, [_buttonArr[_selectInt] width], 2)];
    _singleLine.backgroundColor = _singleLineColor;
    [_topScroll addSubview:_singleLine];
}

- (void)createTitles {
    CGFloat leftX = 10;
    _lastInt = -1;
    _selectInt = 0;
    _buttonArr = [[NSMutableArray alloc] init];
    _singleLineRectArr = [[NSMutableArray alloc] init];
    
    NSInteger fontTemp = _currentFont;
    if (_nomalFont > _currentFont) {
        fontTemp = _nomalFont;
    }
    
    for (int i = 0; i < _titleArr.count; i++) {
        
        CGFloat width = [self widthWithFont:fontTemp ofTitle:_titleArr[i]] + _titleDistance/2;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(leftX, 0, width, _topHeight)];
        [button setTitle:_titleArr[i] forState:UIControlStateNormal];
        
        CGFloat fontValue = (i == _selectInt) ? _currentFont : _nomalFont;
        button.titleLabel.font = [UIFont systemFontOfSize:fontValue];
        
        UIColor *color = (i == _selectInt) ? _currentColor : _nomalColor;
        [button setTitleColor:color forState:UIControlStateNormal];
        
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_singleLineRectArr addObject:@[@(leftX),@(button.width)]];
        leftX += width;
        
        [_buttonArr addObject:button];
        [_topScroll addSubview:_buttonArr[i]];
    }
    _topScroll.contentSize = CGSizeMake(leftX + 10, 44);
}

- (CGFloat)widthWithFont:(CGFloat)font ofTitle:(NSString *)title {
    CGSize textSize = [title sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:font] }];
    return textSize.width;
}

#pragma mark - buttonAction

- (void)navButtonAction:(UIButton *)button {
    
    _lastInt = _selectInt;
    _selectInt = [_buttonArr indexOfObject:button];
    //    _selectInt = button.tag - buttonTag;
    if (_lastInt == _selectInt) {
        return;
    }
    //点击的不是同一个时候刷新button
    [self refreshTitle];
}

//刷新动画
- (void)refreshTitle {
    
    //改变singleLine和topScroll
    [UIView animateWithDuration:_amimateDuration animations:^{
    //非首次点击
    if (_lastInt != -1) {
        UIButton *lastBtn = _buttonArr[_lastInt];
        [lastBtn setTitleColor:_nomalColor forState:UIControlStateNormal];
        lastBtn.titleLabel.font = [UIFont systemFontOfSize:_nomalFont];
    }
    //当前不是第一个或最后一个;纠正bug?
    if (_selectInt!=0 && _selectInt!=_buttonArr.count-1) {
        UIButton *needChangBtn = _buttonArr[0];
        [needChangBtn setTitleColor:_nomalColor forState:UIControlStateNormal];
        needChangBtn.titleLabel.font = [UIFont systemFontOfSize:_nomalFont];
        UIButton *needChangBtn2 = _buttonArr[_buttonArr.count-1];
        [needChangBtn2 setTitleColor:_nomalColor forState:UIControlStateNormal];
        needChangBtn2.titleLabel.font = [UIFont systemFontOfSize:_nomalFont];
    }
    
    UIButton * nowButton = _buttonArr[_selectInt];
    [nowButton setTitleColor:_currentColor forState:UIControlStateNormal];
    nowButton.titleLabel.font = [UIFont systemFontOfSize:_currentFont];
    
        _singleLine.frame = CGRectMake(nowButton.left, _singleLine.top, nowButton.width, _singleLine.height);
        if (_singleLine.left - _topScroll.contentOffset.x < _layoutDistance) {
            CGFloat left = _singleLine.left - _layoutDistance < 0 ? 0 : _singleLine.left - _layoutDistance;
            [_topScroll setContentOffset:CGPointMake(left, _topScroll.contentOffset.y) animated:YES];
        }
        if (_singleLine.right > _topScroll.contentOffset.x + self.width - _layoutDistance ) {
            CGFloat left = _topScroll.contentOffset.x+_layoutDistance-(_topScroll.contentOffset.x+self.width -_singleLine.right);
            left = left > _topScroll.contentSize.width-self.width?_topScroll.contentSize.width-self.width :left;
            [_topScroll setContentOffset:CGPointMake(left, _topScroll.contentOffset.y) animated:YES];
        }
        
    }];
    [_mainScroll setContentOffset:CGPointMake(_selectInt * self.width, 0) animated:NO];
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= self.width * (_buttonArr.count-1)) {
        return;
    }
    CGFloat right = _mainScroll.contentOffset.x - self.width * _selectInt;
    NSNumber * newX = (right > 0) ? _singleLineRectArr[_selectInt+1][0] : _singleLineRectArr[_selectInt-1][0];
    CGFloat calcNewX = [newX floatValue] - [_buttonArr[_selectInt] left];
    
    NSNumber * newWid = (right > 0) ? _singleLineRectArr[_selectInt+1][1] : _singleLineRectArr[_selectInt-1][1];
    CGFloat calcNewWid = [newWid floatValue] - [_buttonArr[_selectInt] width];
    
    CGFloat scale = (right < 0 ? -right: right) / self.width;
    _singleLine.frame = CGRectMake(scale * calcNewX + [_buttonArr[_selectInt] left], _singleLine.top, [_buttonArr[_selectInt] width] + scale *calcNewWid, _singleLine.height);
    
    UIButton * buttonForm = nil;
    UIButton * buttonTo = nil;
    if (right > 0) {
        buttonForm = _buttonArr[_selectInt];
        buttonTo = _buttonArr[_selectInt+1];
    }
    if (right < 0) {
        buttonForm = _buttonArr[_selectInt];
        buttonTo = _buttonArr[_selectInt-1];
    }
    
    CGFloat colorR = scale * (_currentR-_nomalR) + _nomalR;
    CGFloat colorToR = scale * (_nomalR-_currentR) + _currentR;
    CGFloat colorG = scale * (_currentG-_nomalG) + _nomalG;
    CGFloat colorToG = scale * (_nomalG-_currentG) + _currentG;
    CGFloat colorB = scale * (_currentB-_nomalB) + _nomalB;
    CGFloat colorToB = scale * (_nomalB-_currentB) + _currentB;
    [buttonTo setTitleColor:[UIColor colorWithRed:colorR green:colorG blue:colorB alpha:1] forState:UIControlStateNormal];
    [buttonForm setTitleColor:[UIColor colorWithRed:colorToR green:colorToG blue:colorToB alpha:1] forState:UIControlStateNormal];
    
    CGFloat font = scale * (_currentFont-_nomalFont) + _nomalFont;
    CGFloat fontTo = scale * (_nomalFont-_currentFont) + _currentFont;
    buttonTo.titleLabel.font = [UIFont systemFontOfSize:font];
    buttonForm.titleLabel.font = [UIFont systemFontOfSize:fontTo];
    
    if (right >= self.width-1) {
        _lastInt = _selectInt;
        _selectInt ++;
    } else if (right <= -self.width+1) {
        _lastInt = _selectInt;
        _selectInt --;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_singleLine.left - _topScroll.contentOffset.x < _layoutDistance) {
        CGFloat left = _singleLine.left - _layoutDistance < 0 ? 0 : _singleLine.left - _layoutDistance;
        [_topScroll setContentOffset:CGPointMake(left, _topScroll.contentOffset.y) animated:YES];
    }
    if (_singleLine.right > _topScroll.contentOffset.x + self.width - _layoutDistance) {
        CGFloat left = _topScroll.contentOffset.x+_layoutDistance-(_topScroll.contentOffset.x+self.width -_singleLine.right);
        left = left > _topScroll.contentSize.width-self.width?_topScroll.contentSize.width-self.width :left;
        [_topScroll setContentOffset:CGPointMake(left, _topScroll.contentOffset.y) animated:YES];
    }
}

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    
    _topHeight = 44;
    _layoutDistance = 44;
    _titleDistance = 24;
    _topBackColor = [UIColor whiteColor];
    _amimateDuration = .1;
    
    _currentFont = 16;
    _nomalFont = 16;
    
    _currentR = 68/255.0;
    _currentG = 68/255.0;
    _currentB = 68/255.0;
    _currentColor = [UIColor colorWithRed:_currentR green:_currentG blue:_currentB alpha:1];
    _nomalR = 153/255.0;
    _nomalG = 153/255.0;
    _nomalB = 153/255.0;
    _nomalColor = [UIColor colorWithRed:_nomalR green:_nomalG blue:_nomalB alpha:1];
    
    _singleLineColor = [UIColor colorWithRed:44/255.0 green:147/255.0 blue:253/255.0 alpha:1];
}

- (void)didMoveToSuperview {
    [self createView];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        _titleArr = titles;
    }
    return self;
}

@end
