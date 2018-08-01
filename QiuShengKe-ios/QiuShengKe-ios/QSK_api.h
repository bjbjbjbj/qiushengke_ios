//
//  QSK_api.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#ifndef QSK_api_h
#define QSK_api_h
#define QKS_CONFIG @"config"

//特殊配置
#define APP_CONFIG_URL @"http://mp.dlfyb.com/app/v110/config.json"

#define HOST [[QSKCommon instance] baseUrl]
#define QIUMI_API_PREFIX [NSString stringWithFormat:@"%@",HOST]

#define QSK_MATCH_CHANNELS [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/lives/%@/%@.json"]

#define QSK_ANCHOR_URL [QIUMI_API_PREFIX stringByAppendingString:@"/app/v110/anchor/room/url/%@.json"]

#define AKQ_CHANNEL_URL [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/channels/%@.json"]

//直播
#define AKQ_LIVES_URL [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/lives.json"]

//录像
#define VIDEO_LIST [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/subject/videos/%@/%@.json"]
#define VIDEO_TITLES_LIST [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/subject/videos/leagues.json"]

#define ANCHOR_INDEX [QIUMI_API_PREFIX stringByAppendingString:@"/app/v110/anchor/index.json"]

//正在直播主播
#define ANCHOR_LIVING_INDEX [QIUMI_API_PREFIX stringByAppendingString:@"/app/v110/anchor/living.json"]

//socket
#define API_SOCKET @"http://ws.aikq.cc"

#endif /* QSK_api_h */
