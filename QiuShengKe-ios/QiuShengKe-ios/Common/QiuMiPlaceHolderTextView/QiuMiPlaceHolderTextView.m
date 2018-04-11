//
//  QiuMiPlaceHolderTextView.m
//  Qiumi
//
//  Created by Song Xiaochen on 1/19/15.
//  Copyright (c) 2015 51viper.com. All rights reserved.
//

#import "QiuMiPlaceHolderTextView.h"

@implementation QiuMiPlaceHolderTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.placeHolderLabel = nil;
    self.placeholderColor = nil;
    self.placeholder = nil;
}

- (void)didMoveToSuperview
{
    NSLog(@"%s",__func__);
    [super didMoveToSuperview];
    //    [self setPlaceholder:@""];
    [self setPlaceholderColor:placeholderColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidEndEditingNotification object:nil];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        self.backgroundColor = [UIColor clearColor];
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidEndEditingNotification object:nil];
        
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0 && ![self isFirstResponder])
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        placeHolderLabel.frame = CGRectMake(8,8,self.bounds.size.width - 16,0);
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

-(void)paste:(id)sender {
    [super paste:sender];
    [self textChanged:nil];
}

@end
