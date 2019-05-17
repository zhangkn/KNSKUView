//
//  KN_Common.h
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KN_Common : NSObject


/**
 *  十六进制字符串转UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alphaValue ;
@end

NS_ASSUME_NONNULL_END
