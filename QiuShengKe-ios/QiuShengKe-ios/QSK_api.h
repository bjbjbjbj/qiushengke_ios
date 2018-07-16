//
//  QSK_api.h
//  QiuShengKe-ios
//
//  Created by xieweijie on 2018/4/10.
//  Copyright © 2018年 xieweijie. All rights reserved.
//

#ifndef QSK_api_h
#define QSK_api_h
#define HOST @"http://match.qiushengke.com"
#define QIUMI_API_PREFIX [NSString stringWithFormat:@"%@/static",HOST]

//足球
#define QSK_MATCH_FOOT_LIST [QIUMI_API_PREFIX stringByAppendingString:@"/schedule/%@/1/all.json"]

#define QSK_MATCH_FOOT_DETAIL [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/match.json"]

#define QSK_MATCH_FOOT_DETAIL_TECH [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/tech.json"]

#define QSK_MATCH_FOOT_DETAIL_ODD [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/odd.json"]

#define QSK_MATCH_FOOT_DETAIL_ANALYSE [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/analyse.json"]

//篮球
#define QSK_MATCH_BASKET_LIST [QIUMI_API_PREFIX stringByAppendingString:@"/schedule/%@/2/all.json"]

#define QSK_MATCH_BASKET_DETAIL [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/2/%@/match.json"]

#define QSK_MATCH_BASKET_DETAIL_TECH [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/2/%@/tech.json"]

#define QSK_MATCH_BASKET_DETAIL_ODD [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/2/%@/odd.json"]

#define QSK_MATCH_BASKET_DETAIL_ANALYSE [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/2/%@/analyse.json"]

#define QSK_MATCH_CHANNELS @"http://aikq.cc/app/v101/lives/%@/%@.json"

#define QSK_ANCHOR_URL @"http://localhost:8000/anchor/room/url/%@.json"

//直播
#define AKQ_LIVES_URL  @"http://www.aikq.cc/app/v101/lives.json"

//录像
#define VIDEO_LIST @"http://aikq.cc/app/v101/subject/videos/%@/%@.json"
#define VIDEO_TITLES_LIST @"http://aikq.cc/app/v101/subject/videos/leagues.json"

#define ANCHOR_INDEX @"http://localhost:8000/app/v110/anchor/index.json"

#endif /* QSK_api_h */
