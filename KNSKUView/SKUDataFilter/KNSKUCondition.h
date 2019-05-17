//
//  KNSKUCondition.h
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNSKUProperty.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNSKUCondition : NSObject
@property (nonatomic, strong) NSArray<KNSKUProperty *> *properties;

@property (nonatomic, strong, readonly) NSArray<NSNumber *> *conditionIndexs;

@property (nonatomic, strong) id result;


@end

NS_ASSUME_NONNULL_END
