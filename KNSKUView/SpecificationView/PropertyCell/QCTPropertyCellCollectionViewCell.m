//
//  QCTPropertyCellCollectionViewCell.m
//  retail
//
//  Created by mac on 2019/5/16.
//  Copyright © 2019 QCT. All rights reserved.
//

#import "QCTPropertyCellCollectionViewCell.h"

@implementation QCTPropertyCellCollectionViewCell



- (void)layoutSubviews {
    [super layoutSubviews];
    

}



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self selfInit];
        [self createSubView];
        [self addConstraints];
        [self bindViewModel];
    }
    return self;
}

- (void)selfInit{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)createSubView {
}

- (void)addConstraints {
//    WS(weakSelf);
//    [self.titleLab
}

- (void)bindViewModel {
    
}

#pragma mark - set and  get
- (UILabel *)propertyL{
    if (!_propertyL) {
         UILabel* tmp = [[UILabel alloc]init];
        _propertyL = tmp;
        
        
        _propertyL.textAlignment = NSTextAlignmentCenter;
        _propertyL.font = kPingFangFont(13);
        
        
        _propertyL.layer.borderWidth = 1;
        
        _propertyL.clipsToBounds = YES;
        _propertyL.layer.borderColor = k_tableView_Line.CGColor;
        
        _propertyL.layer.cornerRadius = kAdjustRatio(3);
        
        [self.contentView addSubview:_propertyL];
        
        __weak __typeof__(self) weakSelf = self;

        
        
        [_propertyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(weakSelf.contentView);
            make.right.bottom.equalTo(weakSelf.contentView);
        }];
        
        
    }
    return _propertyL;
}




- (void)updateWithTitle:(NSString *)title editing:(BOOL)editing selected:(BOOL)selected
{
    self.propertyL.text = title;
    
    if (selected) {
        self.propertyL.textColor = ktabSelectedTextColor;
        self.propertyL.layer.borderColor = ktabSelectedTextColor.CGColor;
        return;
    }
    if (editing) {
        self.propertyL.layer.borderColor = k_tableView_Line.CGColor;
        self.propertyL.textColor = rgb(51,51,51);
    }else{
        self.propertyL.textColor = [KN_Common colorWithHexString:@"#CCCCCC" alpha:1];
        self.propertyL.layer.borderColor = [KN_Common colorWithHexString:@"#CCCCCC" alpha:1].CGColor;
    }
}

//- (void)setTintStyleColor:(UIColor *)color{
//        self.layer.borderColor = color.CGColor;
//        self.propertyL.textColor = color;
//
//
//
//}
//
///**
//
//
// */
//- (void)setTintStyleborderColorColor:(UIColor *)color{
//    _propertyL.layer.borderColor = color.CGColor;
//}
//
//



@end
