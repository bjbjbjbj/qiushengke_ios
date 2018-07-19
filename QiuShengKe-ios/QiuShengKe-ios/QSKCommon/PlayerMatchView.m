//
//  PlayerMatchView.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/7/19.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "PlayerMatchView.h"
@interface PlayerMatchView()
@property(nonatomic, strong) IBOutlet UIView* nsHostC;
@property(nonatomic, strong) IBOutlet UIView* nsAwayC;
@property(nonatomic, strong) IBOutlet UIImageView* nsHostIcon;
@property(nonatomic, strong) IBOutlet UIImageView* nsAwayIcon;
@property(nonatomic, strong) IBOutlet UILabel* nsHostN;
@property(nonatomic, strong) IBOutlet UILabel* nsAwayN;
@property(nonatomic, strong) IBOutlet UILabel* nsTime;
@property(nonatomic, strong) IBOutlet UILabel* nsScore;

@property(nonatomic, strong) NSDictionary* matchData;
@end
@implementation PlayerMatchView

- (void)awakeFromNib{
    [super awakeFromNib];
    QiuMiViewBorder([_nsHostC superview], 1, 0, [UIColor whiteColor]);
    QiuMiViewBorder(_nsTime, 1, 0, [UIColor whiteColor]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)loadData:(NSDictionary *)dic{
    self.matchData = dic;
    [self.nsTime setText:[NSString stringWithFormat:@" %@ ",[self.matchData objectForKey:@"current_time"]]];
    [self.nsHostN setText:[self.matchData objectForKey:@"hname"]];
    [self.nsAwayN setText:[self.matchData objectForKey:@"aname"]];
    [self.nsHostIcon qiumi_setImageWithURLString:[self.matchData objectForKey:@"hicon"] withHoldPlace:@"icon_default_team"];
    [self.nsAwayIcon qiumi_setImageWithURLString:[self.matchData objectForKey:@"aicon"] withHoldPlace:@"icon_default_team"];
    [self.nsScore setText:[NSString stringWithFormat:@"%d - %d",[self.matchData integerForKey:@"hscore"],[self.matchData integerForKey:@"ascore"]]];
    [self.nsTime setText:[self.matchData objectForKey:@"current_time"]];
    if ([self.matchData objectForKey:@"tag"]) {
        if ([[self.matchData objectForKey:@"tag"] objectForKey:@"h_color"]) {
            NSString* color = [[self.matchData objectForKey:@"tag"] objectForKey:@"h_color"];
            [self.nsHostC setBackgroundColor:[PlayerMatchView colorWithHexString:color]];
        }
        else{
            [self.nsHostC setBackgroundColor:[UIColor clearColor]];
        }
        if ([[self.matchData objectForKey:@"tag"] objectForKey:@"a_color"]) {
            NSString* color = [[self.matchData objectForKey:@"tag"] objectForKey:@"a_color"];
            [self.nsAwayC setBackgroundColor:[PlayerMatchView colorWithHexString:color]];
        }
        else{
            [self.nsAwayC setBackgroundColor:[UIColor clearColor]];
        }
    }
}

- (void)loadSocketData:(NSDictionary *)dic{
    self.matchData = dic;
    [self.nsScore setText:[NSString stringWithFormat:@"%d - %d",[self.matchData integerForKey:@"hscore"],[self.matchData integerForKey:@"ascore"]]];
    if ([self.matchData objectForKey:@"time"]) {
        [self.nsTime setText:[self.matchData objectForKey:@"time"]];
    }
    if ([self.matchData objectForKey:@"time2"]) {
        [self.nsTime setText:[self.matchData objectForKey:@"time2"]];
    }
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    color = [color stringByReplacingOccurrencesOfString:@"rgb(" withString:@""];
    color = [color stringByReplacingOccurrencesOfString:@")" withString:@""];
    color = [color stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray* colors = [color componentsSeparatedByString:@","];
    if ([colors count] < 3) {
        return [UIColor clearColor];
    }
    float r = [colors[0] floatValue];
    float g = [colors[1] floatValue];
    float b = [colors[2] floatValue];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
