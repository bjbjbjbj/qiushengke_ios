//
//  QiuMiFooterView.m
//  QiuMi
//
//  Created by Song Xiaochen on 14-11-17.
//  Copyright (c) 2014年 太平洋网络. All rights reserved.
//

#import "QiuMiFooterView.h"

@interface QiuMiFooterView()
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

@implementation QiuMiFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.textLabel = textLabel;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
        textLabel.textColor = QIUMI_COLOR_G2;
        textLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:textLabel];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicator setFrame:CGRectMake(0, 0, 14, 14)];
        [activityIndicator setHidesWhenStopped:YES];
        self.activityIndicator = activityIndicator;
        [self addSubview:activityIndicator];
        
        [self setStatus:QiuMiFooterViewStatusReady];
        
//这UI看看，实在不行开多个方法设置这个东东是否可见
        //iOS7设置了footer，最后一栏就不会有线，要加上
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
//        [self addSubview:line];
//        line.backgroundColor = COLOR(220, 220, 220, 1);
        self.hidden = YES;
    }
    return self;
}

- (void)setStatus:(QiuMiFooterViewStatus)status
{
    self.hidden = NO;
    QiuMiViewResize(self, CGSizeMake(self.frame.size.width, 40));
    switch (status)
    {
        case QiuMiFooterViewStatusReady:
            _textLabel.text = @"加载加载加载...";
            [_activityIndicator stopAnimating];
            break;
        case QiuMiFooterViewStatusLoading:
            _textLabel.text = @"别催了已经很努力加载了>.<";
            [_activityIndicator startAnimating];
            break;
        case QiuMiFooterViewStatusEnd:
            _textLabel.text = @"";
            QiuMiViewResize(self, CGSizeMake(self.frame.size.width, 8));
            [_activityIndicator stopAnimating];
            break;
        case QiuMiFooterViewStatusHide:
            _textLabel.text = @"";
            QiuMiViewResize(self, CGSizeMake(self.frame.size.width, CGFLOAT_MIN));
            [_activityIndicator stopAnimating];
            break;
        case QiuMiFooterViewStatusNULL:
            _textLabel.text = @"没有内容";
            [_activityIndicator stopAnimating];
            break;
        default:
            break;
    }
    
    CGSize size = [NSString obtainLabelWithByString:_textLabel.text font:_textLabel.font constrainedToSize:CGSizeMake(SCREENWIDTH, 40)];
    float x = (self.bounds.size.width - size.width) * 0.5 - 5 - _activityIndicator.frame.size.width/2 - 5;
    _activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
    _activityIndicator.center = CGPointMake(x, self.bounds.size.height*0.5);
}

- (void)nolineWithHeight:(float)heightForCell tableView:(UITableView *)tableView numbersOfCell:(NSInteger)numbersOfCell {
    if (heightForCell * numbersOfCell > tableView.frame.size.height) {
        
    } else {
        [self setStatus:QiuMiFooterViewStatusHide];
        self.hidden = YES;
    }
}

- (void)hiddenWithHeight:(float)heightForCell tableView:(UITableView *)tableView numbersOfCell:(NSInteger)numbersOfCell {
    if (heightForCell * numbersOfCell > tableView.frame.size.height) {
        
    } else {
        [self setStatus:QiuMiFooterViewStatusHide];
    }
}


@end
