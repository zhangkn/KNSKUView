//
//  ViewController.m
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import "ViewController.h"
#import "KNSpecificationView.h"

@interface ViewController ()
@property (strong, nonatomic) KNSpecificationView *specificationV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.specificationV setupData];
    
    
    
    
}


- (KNSpecificationView *)specificationV{
    if (!_specificationV) {
        _specificationV = [[KNSpecificationView alloc]initWithFrame:CGRectMake(0, 40, SCREENW, kAdjustRatio(400))];
        
        [self.view addSubview:_specificationV];
        
        
    }
    return _specificationV;
}


@end
