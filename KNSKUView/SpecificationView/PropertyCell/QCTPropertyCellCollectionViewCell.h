//
//  QCTPropertyCellCollectionViewCell.h
//  retail
//
//  Created by mac on 2019/5/16.
//  Copyright © 2019 QCT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCTPropertyCellCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic)  UILabel *propertyL;

- (void)updateWithTitle:(NSString *)title editing:(BOOL)editing selected:(BOOL)selected;
//- (void)setTintStyleColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
