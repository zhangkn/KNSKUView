//
//  KNSpecificationView.m
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//

#import "KNSpecificationView.h"
#import "KNSKUDataFilter.h"

@interface KNSpecificationView ()

#pragma mark - ******** SKU

@property (strong, nonatomic) UICollectionView *collectionView;

/**
 用于展示的，包含每个种类所有的的属性值
 
 */
@property (nonatomic, strong) NSArray *dataSource;

/**
 对应式
 */
@property (nonatomic, strong) NSArray *skuData;;

@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*selectedIndexPaths;;

@property (nonatomic, strong) KNSKUDataFilter *filter;


@end

@implementation KNSpecificationView


#pragma mark -- collectionView

#pragma mark - set and get

- (UICollectionView *)collectionView {
if (_collectionView == nil) {

UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
// 2.设置整个collectionView的内边距
//分别为上、左、下、右
flowLayout.sectionInset = UIEdgeInsetsMake(0,kAdjustRatio(20),0,kAdjustRatio(20));
    //.设置每一行之间的间距
    flowLayout.minimumLineSpacing = kAdjustRatio(10);
    flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-3*kAdjustRatio(10))/3.0, self.optionsView.height);
_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
_collectionView.backgroundColor = [UIColor whiteColor];
_collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[QCTPropertyCellCollectionViewCell class] forCellWithReuseIdentifier:@"QCTPropertyCellCollectionViewCell"];
    
    
    
    [_collectionView registerClass:[QCTPropertyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QCTPropertyHeader"];
    
    
    //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    
    
    WS(weakSelf);
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    [self addSubview:_collectionView];
    
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-kAdjustRatio(0));
        
    }];
    
    
}
    return _collectionView;
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    //    if (section) {
    //        if (section <= self.model.ProductProperty.count) {
    return CGSizeMake(SCREENW, kAdjustRatio(40));
    //        }else{
    //            return CGSizeMake(SCREENW, kAdjustRatio(0.1));
    //        }
    //    }else{
    //        return CGSizeMake(SCREENW, kAdjustRatio(100));
    //    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    //    if (indexPath.section) {
    //        if (indexPath.section <= self.model.ProductProperty.count) {
    size = CGSizeMake((self.collectionView.frame.size.width - kAdjustRatio(15) * 3- kAdjustRatio(20)*2)/4, kAdjustRatio(29));//35
    //        }else{
    //            size = CGSizeMake(self.collectionView.width, kAdjustRatio(66));
    //        }
    //    }else{
    //        size = CGSizeMake(0.1, 0.1);
    //    }
    return size;
}




- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource[section][@"value"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    QCTPropertyCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PropertyCell" forIndexPath:indexPath];
    
    
    QCTPropertyCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QCTPropertyCellCollectionViewCell" forIndexPath:indexPath];
    
    
    NSArray *data = _dataSource[indexPath.section][@"value"];
    
    
    cell.propertyL.text = data[indexPath.row];
    
    
    
    if ([_filter.availableIndexPathsSet containsObject:indexPath]) {
        //        [cell setTintStyleColor:[UIColor blackColor]];
        
        //containsObject
        [cell updateWithTitle:cell.propertyL.text editing:YES selected:NO];
        
    }else {
        //        [cell setTintStyleColor:[UIColor lightGrayColor]];
        
        [cell updateWithTitle:cell.propertyL.text editing:NO selected:NO];
        
    }
    
    if ([_filter.selectedIndexPaths containsObject:indexPath]) {
        //        [cell setTintStyleColor:[UIColor redColor]];
        
        [cell updateWithTitle:cell.propertyL.text editing:NO selected:YES];
        
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        QCTPropertyHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"QCTPropertyHeader" forIndexPath:indexPath];
        
        
        
        NSString* text = _dataSource[indexPath.section][@"name"];
        
        
        [view updateWithTitle:text];
        
        
        return view;
        
        
        
    }else {
        //        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        
        return nil;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [_filter didSelectedPropertyWithIndexPath:indexPath];
    
    [collectionView reloadData];
    //    [self action_complete:nil];
}


- (KNSKUDataFilter *)filter{
    if (_filter== nil) {
        _filter = [[KNSKUDataFilter alloc] initWithDataSource:self];
        
        
        
        
    }
    
    return _filter;
}



#pragma mark -- ORSKUDataFilterDataSource
/** 属性种类个数*/
- (NSInteger)numberOfSectionsForPropertiesInFilter:(KNSKUDataFilter *)filter {
    return _dataSource.count;//
}


/**
 
 * 每个种类所有的的属性值
 * 这里不关心具体的值，可以是属性ID, 属性名，字典、model
 
 NSArray *dataSource = @[@{@"name" : @"款式",
 @"value" : @[@"male", @"famale"]},
 @{@"name" : @"颜色",
 @"value" : @[@"red", @"green", @"blue"]},
 @{@"name" : @"尺寸",
 @"value" : @[@"XXL", @"XL", @"L", @"S", @"M"]},
 @{@"name" : @"test",
 @"value" : @[@"A", @"B", @"C"]},];
 _dataSource = dataSource;
 
 
 */
- (NSArray *)filter:(KNSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
        return _dataSource[section][@"value"];// testdata
//    return _dataSource[section][@"PVID"];
    
    
}
/**满足条件 的 个数(对应式)
 _skuData = @[
 @{@"contition":@"male,red,XL,A",
 @"price":@"1120",
 @"store":@"167"},
 @{@"contition":@"male,red,M,B",
 @"price":@"1200",
 @"store":@"289"},
 @{@"contition":@"male,green,L,A",
 @"price":@"889",
 @"store":@"300"},
 @{@"contition":@"male,green,M,B",
 @"price":@"991",
 @"store":@"178"},
 @{@"contition":@"famale,red,XL,A",
 @"price":@"1000",
 @"store":@"200"},
 @{@"contition":@"famale,blue,L,B",
 @"price":@"880",
 @"store":@"12"},
 @{@"contition":@"famale,blue,XXL,C",
 @"price":@"1210",
 @"store":@"300"},
 @{@"contition":@"male,blue,L,C",
 @"price":@"888",
 @"store":@"121"},
 @{@"contition":@"famale,green,M,C",
 @"price":@"1288",
 @"store":@"125"},
 @{@"contition":@"male,blue,L,A",
 @"price":@"1210",
 @"store":@"123"}
 ];
 
 */
- (NSInteger)numberOfConditionsInFilter:(KNSKUDataFilter *)filter {
    return _skuData.count;
}

#pragma mark - ******** 对应的条件式
/**
 
 * 对应的条件式contition
 * 这里条件式的属性值，需要和propertiesInSection里面的数据类型保持一致
 
 */
- (NSArray *)filter:(KNSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    NSString *condition = _skuData[row][@"contition"];
    return [condition componentsSeparatedByString:@","];
}
/**
 条件式 对应的 结果数据（库存、价格等）
 
 */
- (id)filter:(KNSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    NSDictionary *dic = _skuData[row];
    return @{@"price": dic[@"price"],
             @"store": dic[@"store"]};
}





- (void)setupData{
    
    
    
//    [self setupSKUData];//， 直接进行数据格式更换
    
    
    //test data
    
        [self testData];
    NSLog(@"dataSource%@",_dataSource);
    NSLog(@"_skuData:%@",_skuData);
    
    
    [self.filter reloadData];
    [self.collectionView reloadData];
    
}


- (void)testData{
    
    
    NSArray *dataSource = @[@{@"name" : @"款式",
                              @"value" : @[@"male", @"famale"]},
                            @{@"name" : @"颜色",
                              @"value" : @[@"red", @"green", @"blue"]},
                            @{@"name" : @"尺寸",
                              @"value" : @[@"XXL", @"XL", @"L", @"S", @"M"]},
                            @{@"name" : @"test",
                              @"value" : @[@"A", @"B", @"C"]},];
    _dataSource = dataSource;
    
    _selectedIndexPaths = [NSMutableArray array];
    
    _skuData = @[
                 @{@"contition":@"male,red,XL,A",
                   @"price":@"1120",
                   @"store":@"167"},
                 @{@"contition":@"male,red,M,B",
                   @"price":@"1200",
                   @"store":@"289"},
                 @{@"contition":@"male,green,L,A",
                   @"price":@"889",
                   @"store":@"300"},
                 @{@"contition":@"male,green,M,B",
                   @"price":@"991",
                   @"store":@"178"},
                 @{@"contition":@"famale,red,XL,A",
                   @"price":@"1000",
                   @"store":@"200"},
                 @{@"contition":@"famale,blue,L,B",
                   @"price":@"880",
                   @"store":@"12"},
                 @{@"contition":@"famale,blue,XXL,C",
                   @"price":@"1210",
                   @"store":@"300"},
                 @{@"contition":@"male,blue,L,C",
                   @"price":@"888",
                   @"store":@"121"},
                 @{@"contition":@"famale,green,M,C",
                   @"price":@"1288",
                   @"store":@"125"},
                 @{@"contition":@"male,blue,L,A",
                   @"price":@"1210",
                   @"store":@"123"}
                 ];
    
    
}




@end
