//
//  KNConsts.h
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "KN_Common.h"

#define SCREENW [[UIScreen mainScreen] bounds].size.width

#define kAdjustRatio(num) (ceil((SCREENW/375.0)*(num)))
#define WS(weakSelf);  __weak __typeof(&*self)weakSelf = self

#define kPingFangFont(fontSize) [UIFont fontWithName:@"PingFang-SC-Medium" size:(kAdjustRatio(fontSize))]
#define HWColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define rgb(r,g,b) HWColor(r,g,b)
#define ktabSelectedTextColor rgb(252,6,54)
#define k_tableView_Line rgb(231, 231, 231)
