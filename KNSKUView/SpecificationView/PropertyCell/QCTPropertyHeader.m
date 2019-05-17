//
//  QCTPropertyHeader.m
//  retail
//
//  Created by mac on 2019/5/16.
//  Copyright © 2019 QCT. All rights reserved.
//

#import "QCTPropertyHeader.h"

@implementation QCTPropertyHeader




- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self selfInit];
        [self createSubView];
        [self addConstraints];
    }
    return self;
}

- (void)selfInit{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)createSubView {
}

- (void)addConstraints {
    WS(weakSelf);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(kAdjustRatio(20));//18
        make.centerY.equalTo(weakSelf);
    }];
}

- (void)updateWithTitle:(NSString *)title
{
    self.titleLab.text = title;
}

#pragma mark - set and get
- (UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *tmp = [[UILabel alloc]init];
        _titleLab = tmp;
        _titleLab.font = kPingFangFont(13);
        
        _titleLab.textColor = rgb(153,153,153);
        [self addSubview:_titleLab];

        
    }
    return _titleLab;
}




@end
