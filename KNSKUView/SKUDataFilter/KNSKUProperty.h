//
//  KNSKUProperty.h
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNSKUProperty : NSObject


@property (nonatomic, copy, readonly) NSIndexPath * indexPath;
@property (nonatomic, copy, readonly) id value;

- (instancetype)initWithValue:(id)value indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
