//
//  UIColor+RGBA.m
//  HAScrollNavBar
//
//  Created by haha on 15/7/9.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "UIColor+RGBA.h"

@implementation UIColor (RGBA)

RGBA RGBAFromUIColor(UIColor *color)
{
    return RGBAFromCGColor(color.CGColor);
}

RGBA RGBAFromCGColor(CGColorRef color)
{
    RGBA rgba;
    
    CGColorSpaceRef color_space = CGColorGetColorSpace(color);
    CGColorSpaceModel color_space_model = CGColorSpaceGetModel(color_space);
    const CGFloat *color_components = CGColorGetComponents(color);
    size_t color_component_count = CGColorGetNumberOfComponents(color);
    
    switch (color_space_model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            assert(color_component_count == 2);
            rgba = (RGBA)
            {
                .r = color_components[0],
                .g = color_components[0],
                .b = color_components[0],
                .a = color_components[1]
            };
            break;
        }
            
        case kCGColorSpaceModelRGB:
        {
            assert(color_component_count == 4);
            rgba = (RGBA)
            {
                .r = color_components[0],
                .g = color_components[1],
                .b = color_components[2],
                .a = color_components[3]
            };
            break;
        }
            
        default:
        {
            rgba = (RGBA) { 0, 0, 0, 0 };
            break;
        }
    }
    
    return rgba;
}

+ (UIColor*)distanceColorWithSorcColor:(UIColor*)sorcColor withDestColor:(UIColor*)destColor withPercent:(float)percent{
    if (percent > 1.0) {
        percent = 1.0;
    }
    
    if (percent < 0.0) {
        percent = 0.0;
    }
    
    const CGFloat *sorcComponents = CGColorGetComponents(sorcColor.CGColor);
    const CGFloat *destComponents = CGColorGetComponents(destColor.CGColor);
    NSMutableArray *components  = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        components[i] = [NSNumber numberWithFloat:sorcComponents[i] + (destComponents[i] - sorcComponents[i]) * percent];
    }
    return [UIColor colorWithRed:[components[0] floatValue] green:[components[1] floatValue] blue:[components[2] floatValue] alpha:[components[3] floatValue]];
}

+ (UIColor*)distanceColorWithSorcColor2:(UIColor*)sorcColor withDestColor:(UIColor*)destColor withPercent:(float)percent{
    if (percent > 1.0) {
        percent = 1.0;
    }
    
    if (percent < 0.0) {
        percent = 0.0;
    }
    
    const CGFloat *sorcComponents = CGColorGetComponents(sorcColor.CGColor);
    const CGFloat *destComponents = CGColorGetComponents(destColor.CGColor);
    NSMutableArray *components  = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        components[i] = [NSNumber numberWithFloat:sorcComponents[i] + (destComponents[i] - sorcComponents[i]) * percent];
        if (i == 3) {
            components[i] = [NSNumber numberWithFloat:1.0];
        }
    }
    return [UIColor colorWithRed:[components[0] floatValue] green:[components[1] floatValue] blue:[components[2] floatValue] alpha:[components[3] floatValue]];
}
@end
