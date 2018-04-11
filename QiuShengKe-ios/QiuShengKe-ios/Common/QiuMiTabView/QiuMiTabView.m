//
//  QiuMiTabView.m
//  Qiumi
//
//  Created by Song Xiaochen on 2/9/15.
//  Copyright (c) 2015 51viper.com. All rights reserved.
//

#import "QiuMiTabView.h"
#import "UIColor+RGBA.h"

@interface QiuMiTabView ()<UIScrollViewDelegate>
{
    BOOL _canScroll;
    BOOL _finishAnima;
    BOOL _canChange;
}
@property (nonatomic, strong) NSMutableArray *btnList; //按钮数组
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong) UIScrollView* scrollView;

@end

@implementation QiuMiTabView
- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withCanScroll:(BOOL)canScroll
{
    self = [super initWithFrame:frame];
    if (self) {
        _canScroll = canScroll;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withCanScroll:(BOOL)canScroll withIsUpper:(BOOL)isUpper{
    self = [super initWithFrame:frame];
    if (self) {
        _canScroll = canScroll;
        _isUpperWithArrow = isUpper;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.lineColor = QIUMI_COLOR_C1;
    self.normalColor = [UIColor colorWithWhite:1 alpha:.8];
    self.selectedColor = [UIColor whiteColor];
    self.btnList = [NSMutableArray array];
    self.font = [UIFont systemFontOfSize:14];
    self.buttonInterval = 14;
    self.arrowWidth = 4;
    
    if (_canScroll) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(_buttonInterval, 0, self.frame.size.width - _buttonInterval*2, self.frame.size.height)];
    }
    else
    {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setTag:[@"scrollview" hash]];
    [self.scrollView setScrollsToTop:NO];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];

    self.arrowView = ({
        UIImageView *arrowView = [[UIImageView alloc] init];
        [arrowView setImage:[UIImage imageNamed:@"icon_tab_triangle_blue"]];
        arrowView.transform = CGAffineTransformRotate(arrowView.transform, _isUpperWithArrow ? M_PI : 0);
        arrowView.frame = CGRectMake(0, _isUpperWithArrow ? 0 : CGRectGetHeight(self.frame)- 4, 8, 4);
        arrowView.hidden = YES;
        [_scrollView addSubview:arrowView];
        arrowView;
    });
    
    self.lineView = ({
        UIView *lineView = [[UIView alloc] init];
        lineView.layer.cornerRadius = 1;
        lineView.layer.masksToBounds = YES;
        [lineView setBackgroundColor:_lineColor];
        _lineView.transform = CGAffineTransformRotate(_arrowView.transform, _isUpperWithArrow ? M_PI : 0);
        lineView.frame = CGRectMake(0, _isUpperWithArrow ? 0 : CGRectGetHeight(self.frame) - 2, 8, 2);
        lineView.hidden = YES;
        [_scrollView addSubview:lineView];
        lineView;
    });
    
    _finishAnima = YES;
    _canChange = YES;
    
    UIView* sep = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, .5)];
    [sep setTag:[@"sep" hash]];
    [sep setBackgroundColor:QIUMI_COLOR_G4];
//    [self addSubview:sep];
    if (_isUpperWithArrow) {
        [self _showArrow];
    }else{
        [self _showLine];
    }
    
}

#pragma mark - get/set
- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [_lineView setBackgroundColor:lineColor];
}

- (void)setSepColor:(UIColor *)sepColor
{
    _sepColor = [sepColor copy];
    [[self viewWithTag:[@"sep" hash]] removeFromSuperview];
}

- (void)setSelectedSepColor:(UIColor *)selectedSepColor
{
    _selectedSepColor = [selectedSepColor copy];
    //    [_arrowView setBackgroundColor:selectedSepColor];
    //[_arrowView setHidden:YES];
}

- (void)setColumnTitles:(NSArray *)columnTitles {
    
    if (_columnTitles == columnTitles || columnTitles.count == 0) {
        return;
    }
    _columnTitles = [columnTitles copy];
    [self reloadData];
}

- (void)setButtonInterval:(int)buttonInterval{
    _buttonInterval = buttonInterval;
    [self reloadData];
}

#pragma mark - 切换相关
//栏目内按钮切换操作
- (void)btnClick:(UIButton *)sender {
    _canChange = NO;
    [self selectAtIndex:sender.tag ifcallback:YES withAnima:YES];
}

/*  简介：栏目按钮切换操作
 *  作用：类内部调用，不外放函数接口
 *  参数：ifCallBack ：-- 用来判断是否需要通知回调,
 */
-(void)selectAtIndex:(NSUInteger)index ifcallback:(BOOL)ifcallBack withAnima:(BOOL)isAnima
{
    
    if (!_finishAnima && isAnima) {
        return;
    }
    _finishAnima = NO;
    // 去选择:
    NSUInteger preIndex  = self.currentIndex;
    
    if ([self.btnList count] <= preIndex || [_btnList count] <= index) {
        return;
    }
    
    UIButton *curSelbtn = [self.btnList objectAtIndex:preIndex];
    [curSelbtn setSelected:NO];
    
    for (int i = 0; i < [_btnList count]; i++) {
        UIButton *tempBtn = [_btnList objectAtIndex:i];
        tempBtn.transform = CGAffineTransformIdentity;
        tempBtn.titleLabel.font = _font;
        [tempBtn setTitleColor:_normalColor forState:UIControlStateNormal];
    }
    
    // 选择：
    UIButton *btn = [self.btnList objectAtIndex:index];
    if (nil != _selectedFont && _currentIndex != index) {
        [UIView animateWithDuration:.25 animations:^{
            if (!_hasFollowScroll) {
                curSelbtn.transform = CGAffineTransformScale(curSelbtn.transform, _font.pointSize/_selectedFont.pointSize, _font.pointSize/_selectedFont.pointSize);
                btn.transform = CGAffineTransformScale(btn.transform, _selectedFont.pointSize/_font.pointSize, _selectedFont.pointSize/_font.pointSize);
            }
        } completion:^(BOOL finished) {
            if (!_hasFollowScroll) {
                btn.transform = CGAffineTransformScale(btn.transform, _font.pointSize/_selectedFont.pointSize, _font.pointSize/_selectedFont.pointSize);
                curSelbtn.transform = CGAffineTransformScale(curSelbtn.transform, _selectedFont.pointSize/_font.pointSize, _selectedFont.pointSize/_font.pointSize);
            }
            
            
            //[btn.titleLabel setFont:_selectedFont];
            btn.transform = CGAffineTransformScale(CGAffineTransformIdentity, _selectedFont.pointSize/_font.pointSize, _selectedFont.pointSize/_font.pointSize);
            btn.titleLabel.font = _font;
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
            
            //[curSelbtn.titleLabel setFont:_font];
            curSelbtn.transform = CGAffineTransformIdentity;
            curSelbtn.titleLabel.font = _font;
            [curSelbtn setTitleColor:_normalColor forState:UIControlStateNormal];
        }];
    }
    _currentIndex = index;
    btn.selected = YES;
    
    if (isAnima) {
        //动画
        [UIView animateWithDuration:0.25 animations:^(void) {
            [self doMove:btn];
        } completion:^(BOOL finished) {
            _finishAnima = YES;
            if (ifcallBack == YES && self.doSelectBlock) {
                self.doSelectBlock(_currentIndex);
            }
        }];
    }
    else
    {
        
        [self doMove:btn];
        _finishAnima = YES;
        if (ifcallBack == YES && self.doSelectBlock) {
            self.doSelectBlock(_currentIndex);
        }
    }
    
}

//点击选中后动画
- (void)doMove:(UIButton*)btn
{
    QiuMiViewResize(_lineView, CGSizeMake(btn.titleLabel.frame.size.width+10, 2));

    CGRect frame = btn.frame;
    frame.size.width = [NSString obtainLabelWithByString:btn.titleLabel.text font:_font constrainedToSize:CGSizeMake(1000, 44)].width + _arrowWidth*2;
    frame.size.height = _lineView.frame.size.height;
    [self.lineView setCenter:CGPointMake(btn.center.x, self.lineView.center.y)];
    [self.arrowView setCenter:CGPointMake(btn.center.x, self.arrowView.center.y)];
    
    if (_mustScrollToCenter) {
        //btn中点-显示长度，判断是否能够到中间
        if (btn.center.x > _scrollView.frame.size.width/2 && btn.center.x + _scrollView.frame.size.width/2 < _scrollView.contentSize.width) {
            [_scrollView setContentOffset:CGPointMake(btn.center.x - _scrollView.frame.size.width/2, 0) animated:YES];
        }
        else
        {
            if(btn.center.x <= _scrollView.frame.size.width/2)
            {
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else
            {
                [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0) animated:YES];
            }
        }
    }
    else
    {
        UIButton* preBtn = [_btnList objectAtIndex:0 == _currentIndex ? 0 : _currentIndex - 1];
        UIButton* nextBtn = [_btnList objectAtIndex:MIN([_btnList count] - 1, _currentIndex + 1)];
        if (CGRectGetMaxX(preBtn.frame) < _scrollView.contentOffset.x) {
            [_scrollView scrollRectToVisible:CGRectMake(preBtn.frame.origin.x - 10, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
        }
        else if (CGRectGetMinX(nextBtn.frame) > _scrollView.contentOffset.x + _scrollView.frame.size.width)
        {
            [_scrollView scrollRectToVisible:CGRectMake(CGRectGetMaxX(nextBtn.frame) + 10 - _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
        }
    }
}

- (void)updateCanScroll:(BOOL)canScroll{
    _canScroll = canScroll;
}

- (void)reloadData
{
    //remove sub buttons
    for (UIButton *button in self.btnList) {
        [button removeFromSuperview];
    }
    
    if (_scrollView) {
        if (_canScroll) {
            [_scrollView setFrame:CGRectMake(_buttonInterval, 0, self.frame.size.width - _buttonInterval*2, self.frame.size.height)];
        }
        else
        {
            [_scrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        }
    }
    
    //reset
    [self.btnList removeAllObjects];
    _currentIndex = 0;

//    self.lineView.hidden = NO;
//    self.arrowView.hidden = NO;
    
    //add button
    CGFloat btnWidth = CGRectGetWidth(self.frame)/_columnTitles.count;
    CGFloat totalWidth = 0;
    for (int i = 0 ; i<_columnTitles.count; i++) {
        CGRect frame;
        if (_canScroll) {
            btnWidth = [NSString obtainLabelWithByString:[_columnTitles objectAtIndex:i] font:_font constrainedToSize:CGSizeMake(1000, 44)].width + _buttonInterval*2;
        }
        frame = CGRectMake(totalWidth, 0, btnWidth, CGRectGetHeight(self.frame));
        totalWidth = totalWidth + frame.size.width;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = frame;
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [btn setTitle:_columnTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = _font;
        btn.tag = i;
        [btn addTarget:self
                action:@selector(btnClick:)
      forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        [self.btnList addObject:btn];
        [btn layoutIfNeeded];
        
        
    }
    
    if (_canScroll) {
        [_scrollView setContentSize:CGSizeMake(totalWidth, CGRectGetHeight(_scrollView.frame))];
    }
    else {
        [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    }
    
    [self selectAtIndex:0 ifcallback:NO withAnima:NO];
    _finishAnima = YES;
    
    //line view
    if ([_btnList count] > 0) {
        CGPoint center = CGPointMake([[_btnList objectAtIndex:0] center].x, self.lineView.center.y);
        self.lineView.center = center;
        center = CGPointMake([[_btnList objectAtIndex:0] center].x, self.arrowView.center.y);
        self.arrowView.center = center;
        
        if (_selectedFont) {
            UIButton* btn = [_btnList objectAtIndex:0];
            btn.titleLabel.font = _selectedFont;
        }
    }
}

- (void)changeTheTrangleColorWithType:(NSInteger)type{
    if (_arrowView) {
        switch (type) {
            case 0:
            {
                [_arrowView setImage:[UIImage imageNamed:@"icon_tab_triangle_blue.png"]];
            }
                break;
            case 1:
            {
                [_arrowView setImage:[UIImage imageNamed:@"icon_tab_triangle_alpha.png"]];
            }
                break;
            default:
                break;
        }
    }
    [self _showArrow];
}

- (void)contentScrollPositionX:(CGFloat)x withContentWidth:(CGFloat)contentWidth{
    int pageCount = contentWidth/SCREENWIDTH;
    float scrollPercent = x/(contentWidth*((pageCount - 1)*1.0/pageCount));
    //scrollPercent = x/contentWidth*1.0;
    float nextIndex = scrollPercent*([_btnList count] - 1);
    
    if(_canChange && x >= 0 && x <= (contentWidth - SCREENWIDTH))
    {
        //scrollView位置渐变
        float scrollX = [self _calculateScrollWithFactor:nextIndex];
        if (scrollX >= 0 && scrollX <= _scrollView.contentSize.width - _scrollView.bounds.size.width) {
            [_scrollView setContentOffset:CGPointMake(scrollX, 0)];
            
        }
        //长度渐变
        if (((int)nextIndex + 1) <= [_btnList count]-1) {
            float LongDistance = ([(UIButton*)_btnList[(int)nextIndex + 1] titleLabel].frame.size.width - [(UIButton*)_btnList[(int)nextIndex] titleLabel].frame.size.width);
            //缺一个渐变动画
            QiuMiViewResize(_lineView, CGSizeMake([(UIButton*)_btnList[(int)nextIndex] titleLabel].frame.size.width + 10 + LongDistance * (nextIndex-(int)nextIndex), _lineView.frame.size.height));
        }
        for (int i = 0; i < [_btnList count]; i++) {
            UIButton *btn = [_btnList objectAtIndex:i];
            [btn setSelected:NO];
            float disPercent = fabs(scrollPercent*([_btnList count] - 1) - i);
            //disPercent = fabs(scrollPercent*[_btnList count]-i);
            //颜色渐变
            [btn setTitleColor:[self _distanceColorWithSorcColor:_normalColor withDestColor:_selectedColor withPercent:(disPercent <= 1)?(1 - disPercent):0] forState:UIControlStateNormal];
            //大小渐变
            float becomeBigFactor = (((_selectedFont.pointSize>_font.pointSize)?_selectedFont.pointSize:_font.pointSize)-_font.pointSize)*1.0/_font.pointSize;
            btn.titleLabel.font = [UIFont systemFontOfSize:_font.pointSize];
            btn.transform = CGAffineTransformIdentity;
            btn.transform = CGAffineTransformScale(CGAffineTransformIdentity, (disPercent <= 1)?(1 + becomeBigFactor * (1 - disPercent)):1, (disPercent <= 1)?(1 + becomeBigFactor * (1 - disPercent)):1);
           
            //nextIndex
            if (nextIndex - (int)nextIndex < 0.00000001) {
                NSUInteger preIndex  = self.currentIndex;
                if ([self.btnList count] <= preIndex || [_btnList count] <= nextIndex) {
                    return;
                }
                UIButton *btn = [self.btnList objectAtIndex:nextIndex];
                _currentIndex = nextIndex;
                btn.selected = YES;
            }
        }
        if (((int)nextIndex + 1) <= ([_btnList count] - 1)) {
            UIButton* arrowBtn = [_btnList objectAtIndex:(int)nextIndex];
            UIButton* arrowNextBtn = [_btnList objectAtIndex:(int)nextIndex+1];
            QiuMiViewSetOrigin(_lineView, CGPointMake(arrowBtn.center.x + (arrowNextBtn.center.x - arrowBtn.center.x) * (nextIndex-(int)nextIndex) - _lineView.frame.size.width/2, _lineView.frame.origin.y));
            QiuMiViewSetOrigin(_arrowView, CGPointMake(arrowBtn.center.x + (arrowNextBtn.center.x - arrowBtn.center.x) * (nextIndex-(int)nextIndex) - _arrowView.frame.size.width/2, _arrowView.frame.origin.y));
        }
    }
    if (nextIndex - (int)nextIndex < 0.00000001 && _finishAnima) {
        if (_canChange == NO) {
            _canChange = YES;
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(outerScrollViewEnabelSetNo)]) {
        [self.delegate outerScrollViewEnabelSetNo];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //enshore that the end of scroll is fired because apple are twats...
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (_delegate && [_delegate respondsToSelector:@selector(outerScrollViewEnabelSetYes)]) {
        [self.delegate outerScrollViewEnabelSetYes];
    }
}

#pragma mark - private
- (float)_positionWithCenterView:(UIView*)view{
    float position;
    if (view.center.x > _scrollView.frame.size.width/2 && view.center.x + _scrollView.frame.size.width/2 < _scrollView.contentSize.width) {
        position = view.center.x - _scrollView.frame.size.width/2;
    }
    else
    {
        if(view.center.x <= _scrollView.frame.size.width/2)
        {
            position = 0;
        }
        else
        {
            position = _scrollView.contentSize.width - _scrollView.frame.size.width;
        }
    }
    return position;
}

- (UIColor*)_distanceColorWithSorcColor:(UIColor*)sorcColor withDestColor:(UIColor*)destColor withPercent:(float)percent{
    const CGFloat *sorcComponents = CGColorGetComponents(sorcColor.CGColor);
    const CGFloat *destComponents = CGColorGetComponents(destColor.CGColor);
    NSMutableArray *components  = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        components[i] = [NSNumber numberWithFloat:sorcComponents[i] + (destComponents[i] - sorcComponents[i]) * percent];
    }
    return [UIColor colorWithRed:[components[0] floatValue] green:[components[1] floatValue] blue:[components[2] floatValue] alpha:[components[3] floatValue]];
    
    
}

- (float)_calculateScrollWithFactor:(float)factor{
    float begin = ((UIButton*)_btnList[(int)factor]).center.x - _scrollView.bounds.size.width/2.0;
    float scrollX = _scrollView.contentOffset.x;
    if ((int)factor + 1 <= [_btnList count] - 1 && (int)factor >= 0) {
        scrollX = begin + (factor - (int)factor) * (((UIButton*)_btnList[(int)factor + 1]).center.x - ((UIButton*)_btnList[(int)factor]).center.x);
    }
    if (scrollX >= _scrollView.contentSize.width - _scrollView.bounds.size.width) {
        scrollX = _scrollView.contentSize.width - _scrollView.bounds.size.width;
    }
    return (scrollX >= 0)?scrollX:0;
}

- (void)_showLine{
    [_lineView setHidden:NO];
    [_arrowView setHidden:YES];
}

-(void)_showArrow{
    [_lineView setHidden:YES];
    [_arrowView setHidden:NO];
}
@end
