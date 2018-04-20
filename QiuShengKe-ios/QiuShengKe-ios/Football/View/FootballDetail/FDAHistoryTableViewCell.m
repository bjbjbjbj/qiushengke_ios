//
//  FDAHistoryTableViewCell.m
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/13.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#import "FDAHistoryTableViewCell.h"

@implementation FDAHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_result setTextColor:QIUMI_COLOR_G7];
    QiuMiViewBorder(_result, 2, 0, [UIColor clearColor]);
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (NSInteger)heightOfCell{
    return 50;
}

+(NSInteger)heightOfTitle{
    return 22;
}

- (void)loadData:(NSDictionary *)dic teamId:(NSInteger)tid{
    [self loadData:dic teamId:tid sport:1];
}

- (void)loadData:(NSDictionary *)dic teamId:(NSInteger)tid sport:(NSInteger)sport{
    NSString* timeStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"time"] componentsSeparatedByString:@" "][0]];
    [_time setText:timeStr];
    [_league setText:[dic stringForKey:@"league" withDefault:@"-"]];
    [_hname setText:[dic stringForKey:@"hname" withDefault:@"-"]];
    [_aname setText:[dic stringForKey:@"aname" withDefault:@"-"]];
    [_score setText:[NSString stringWithFormat:@"%@ - %@",[dic stringForKey:@"hscore" withDefault:@"-"],[dic stringForKey:@"ascore" withDefault:@"-"]]];
    if ([dic existForKey:@"goalmiddle1"]) {
        [_goal setHidden:NO];
        if (([dic integerForKey:@"hscore"] + [dic integerForKey:@"ascore"]) > [dic floatForKey:@"goalmiddle1"]) {
            NSInteger num = [dic floatForKey:@"goalmiddle1"]*100;
            NSString* tmp = @"";
            if (num%100 == 25) {
                tmp = [dic stringForKey:@"goalmiddle1"];
            }
            else if (num%100 == 50) {
                tmp = [[dic stringForKey:@"goalmiddle1"] stringByReplacingOccurrencesOfString:@".50" withString:@".5"];
            }
            else if (num%100 == 75) {
                tmp = [dic stringForKey:@"goalmiddle1"];
            }
            else if (num%100 == 0) {
                tmp = [[dic stringForKey:@"goalmiddle1"] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            }
            
            [_goal setText:[NSString stringWithFormat:@"大%@",tmp]];
        }
        else if(([dic integerForKey:@"hscore"] + [dic integerForKey:@"ascore"]) < [dic floatForKey:@"goalmiddle1"]){
            NSInteger num = [dic floatForKey:@"goalmiddle1"]*100;
            NSString* tmp = @"";
            if (num%100 == 25) {
                tmp = [dic stringForKey:@"goalmiddle1"];
            }
            else if (num%100 == 50) {
                tmp = [[dic stringForKey:@"goalmiddle1"] stringByReplacingOccurrencesOfString:@".50" withString:@".5"];
            }
            else if (num%100 == 75) {
                tmp = [dic stringForKey:@"goalmiddle1"];
            }
            else if (num%100 == 0) {
                tmp = [[dic stringForKey:@"goalmiddle1"] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            }
            
            [_goal setText:[NSString stringWithFormat:@"小%@",tmp]];
        }
        else{
            NSInteger num = [dic floatForKey:@"goalmiddle1"]*100;
            NSString* tmp = @"";
            if (num%100 == 25) {
                tmp = [dic stringForKey:@"goalmiddle1"];
            }
            else if (num%100 == 50) {
                tmp = [[dic stringForKey:@"goalmiddle1"] stringByReplacingOccurrencesOfString:@".50" withString:@".5"];
            }
            else if (num%100 == 75) {
                tmp = [dic stringForKey:@"goalmiddle1"];
            }
            else if (num%100 == 0) {
                tmp = [[dic stringForKey:@"goalmiddle1"] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            }
            
            [_goal setText:[NSString stringWithFormat:@"走%@",tmp]];
        }
    }
    else{
        [_goal setHidden:YES];
    }
    
    if ([dic integerForKey:@"hid"] == tid) {
        [_hname setTextColor:QIUMI_COLOR_C3];
    }
    else{
        [_hname setTextColor:QIUMI_COLOR_G2];
    }
    if ([dic integerForKey:@"aid"] == tid) {
        [_aname setTextColor:QIUMI_COLOR_C3];
    }
    else{
        [_aname setTextColor:QIUMI_COLOR_G2];
    }
    //主让
    if (![dic existForKey:@"asiamiddle1"]) {
        [_handicap setText:@"-"];
        [_result setHidden:YES];
    }
    else{
        [_handicap setText:[dic stringForKey:@"asiamiddle1"]];
        switch ([QSKCommon getMatchAsiaOddResult:[dic integerForKey:@"hscore"] ascore:[dic integerForKey:@"ascore"] handicap:[dic floatForKey:@"asiamiddle1"] isHost:tid == [dic integerForKey:@"hid"]]) {
            case 3:
                [_result setText:@"赢"];
                [_result setBackgroundColor:QIUMI_COLOR_C3];
                break;
            case 1:
                [_result setText:@"走"];
                [_result setBackgroundColor:QIUMI_COLOR_C5];
                break;
            case 0:
                [_result setText:@"输"];
                [_result setBackgroundColor:QIUMI_COLOR_C1];
                break;
            default:
                break;
        }
        [_result setHidden:NO];
    }
}
@end

