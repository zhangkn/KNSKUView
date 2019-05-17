//
//  QCTPropertyHeader.h
//  retail
//
//  Created by mac on 2019/5/16.
//  Copyright © 2019 QCT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNConsts.h"
NS_ASSUME_NONNULL_BEGIN

@interface QCTPropertyHeader : UICollectionReusableView


@property (strong, nonatomic)  UILabel *titleLab;

- (void)updateWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
