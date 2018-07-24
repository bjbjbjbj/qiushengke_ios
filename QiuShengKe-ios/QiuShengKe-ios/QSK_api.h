//
//  QSK_api.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#ifndef QSK_api_h
#define QSK_api_h
#define HOST @"http://www.aikq.cc"
#define QIUMI_API_PREFIX [NSString stringWithFormat:@"%@",HOST]

#define QSK_MATCH_CHANNELS [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/lives/%@/%@.json"]

#define QSK_ANCHOR_URL [QIUMI_API_PREFIX stringByAppendingString:@"/app/v110/anchor/room/url/%@.json"]

#define AKQ_CHANNEL_URL [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/channels/%@.json"]

#define APP_CONFIG_URL [QIUMI_API_PREFIX stringByAppendingString:@"/app/v110/config.json"]

//直播
#define AKQ_LIVES_URL [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/lives.json"]

//录像
#define VIDEO_LIST [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/subject/videos/%@/%@.json"]
#define VIDEO_TITLES_LIST [QIUMI_API_PREFIX stringByAppendingString:@"/app/v101/subject/videos/leagues.json"]

#define ANCHOR_INDEX [QIUMI_API_PREFIX stringByAppendingString:@"/app/v110/anchor/index.json"]

#endif /* QSK_api_h */
