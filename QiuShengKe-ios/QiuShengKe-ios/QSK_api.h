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

#define QSK_MATCH_FOOT_LIST [QIUMI_API_PREFIX stringByAppendingString:@"/schedule/%@/1/all.json"]

#define QSK_MATCH_FOOT_DETAIL [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/match.json"]

#define QSK_MATCH_FOOT_DETAIL_TECH [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/tech.json"]

#define QSK_MATCH_FOOT_DETAIL_ODD [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/odd.json"]

#define QSK_MATCH_FOOT_DETAIL_ANALYSE [QIUMI_API_PREFIX stringByAppendingString:@"/terminal/1/%@/analyse.json"]

#define QSK_MATCH_CHANNELS [@"https://www.qiushengke.com" stringByAppendingString:@"/json/live/%@/%@.json"]

#endif /* QSK_api_h */
