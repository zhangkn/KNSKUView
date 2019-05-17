//
//  KNSKUProperty.m
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import "KNSKUProperty.h"

@implementation KNSKUProperty



- (instancetype)initWithValue:(id)value indexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self) {
        _value = value;
        _indexPath = indexPath;
    }
    return self;
}


@end
