//
//  KNSKUCondition.m
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import "KNSKUCondition.h"

@implementation KNSKUCondition



- (void)setProperties:(NSArray<KNSKUProperty *> *)properties {
    
    _properties = properties;
    NSMutableArray *array = [NSMutableArray array];
    [properties enumerateObjectsUsingBlock:^(KNSKUProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:@(obj.indexPath.item)];
    }];
    _conditionIndexs = [array copy];
}
@end
