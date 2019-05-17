//
//  KNSKUDataFilter.m
//  KNSKUView
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019 QCT. All rights reserved.
//
#warning filter:propertiesInSection：和方法filter:conditionForRow：数据类型应该保持一致  这里不关心具体的值，可以是属性ID, 属性名，字典、model

/* Tips：
 *
 *  ----------------- warning -----------------
 *  使用注意
 1、虽然SKUDataFilter不关心具体的值，但是条件式本质是由属性组成，故代理方法filter:propertiesInSection：和方法filter:conditionForRow：数据类型应该保持一致
 2、因为SKUDataFilter关心的是属性的坐标，那么在代理方法传值的时候，代理方法filter:propertiesInSection：和方法filter:conditionForRow：各自的数据顺序要保持一致 并且两个方法的数据也要对应
 
 *  ----------------- indexPath -----------------
 *
 *  indexPath记录属性的位置坐标
 *  表示为 第section 种属性类下面的 第item个 属性 （从0计数)
 *
 *  例：
 *
 *  颜色: r g
 *  尺寸: s m l
 *
 *  属性m 表示为 secton : 1, item : 1
 *
 *  ----------------- conditionIndexs -----------------
 *
 *  条件式（符合条件的属性组合-在商品中表示有库存，可售等）
 *  conditionIndex 是本filter对属性管理的关键
 *
 *  condition (r,s)
 *  使用 conditionIndex 用属性下标表示则为 (0,0)
 *
 *  conditionIndex 通过它本身的值（即为属性的Item）和下标（即为属性的section） 可以查询任何一个属性的indexPath

 */


#import "KNSKUDataFilter.h"


@interface KNSKUDataFilter ()

@property (nonatomic, strong) NSSet <KNSKUCondition *> *conditions;

@property (nonatomic, strong) NSMutableArray <NSIndexPath *> *selectedIndexPaths;


@property (nonatomic, strong) NSMutableSet <NSIndexPath *> *availableIndexPathsSet;

/**全可用的*/
@property (nonatomic, strong) NSSet <NSIndexPath *> *allAvailableIndexPaths;


@property (nonatomic, strong) id  currentResult;


@end

@implementation KNSKUDataFilter



- (instancetype)initWithDataSource:(id<KNSKUDataFilterDataSource>)dataSource
{
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _selectedIndexPaths = [NSMutableArray array];
        [self initPropertiesSkuListData];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return self;
}

- (void)reloadData {
    [_selectedIndexPaths removeAllObjects];
    [self initPropertiesSkuListData];
    [self updateCurrentResult];
}

#pragma mark -- public method
/**选中某个属性*/
- (void)didSelectedPropertyWithIndexPath:(NSIndexPath *)indexPath {
    
    if (![_availableIndexPathsSet containsObject:indexPath]) {
        //不可选
        return;
    }
    
    if (indexPath.section > [_dataSource numberOfSectionsForPropertiesInFilter:self] || indexPath.item >= [[_dataSource filter:self propertiesInSection:indexPath.section] count]) {
        //越界
        NSLog(@"indexPath is out of range");
        return;
    }
    
    if ([_selectedIndexPaths containsObject:indexPath]) {
        //已被选
        [_selectedIndexPaths removeObject:indexPath];
        
        [self updateAvailableIndexPaths];
        [self updateCurrentResult];
        return;
    }
    
    __block NSIndexPath *lastIndexPath = nil;
    
    [_selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.section == obj.section) {
            lastIndexPath = obj;
        }
    }];
    
    if (!lastIndexPath) {
        //添加新属性
        [_selectedIndexPaths addObject:indexPath];
        [_availableIndexPathsSet intersectSet:[self availableIndexPathsFromSelctedIndexPath:indexPath sectedIndexPaths:_selectedIndexPaths]];
        [self updateCurrentResult];
        return;
    }
    
    if (lastIndexPath.item != indexPath.item) {
        //切换属性
        [_selectedIndexPaths addObject:indexPath];
        [_selectedIndexPaths removeObject:lastIndexPath];
        [self updateAvailableIndexPaths];
        [self updateCurrentResult];
    }
    
}


#pragma mark -- private method

/**获取初始数据*/
- (void)initPropertiesSkuListData {
    
    NSMutableSet *modelSet = [NSMutableSet set];
    
    for (int i = 0; i < [_dataSource numberOfConditionsInFilter:self]; i ++) {
        
        KNSKUCondition *model = [KNSKUCondition new];
        NSArray * conditions = [_dataSource filter:self conditionForRow:i];
        
        if (![self checkConformToSkuConditions:conditions]) {
            NSLog(@"第 %d 个 condition 不完整 \n %@", i, conditions);
            continue;
        }
        
        model.properties = [self propertiesWithConditionRawData:conditions];
        model.result = [_dataSource filter:self resultOfConditionForRow:i];
        
        [modelSet addObject:model];
    }
    _conditions = [modelSet copy];
    
    [self getAllAvailableIndexPaths];
}

/**检查数据是否正确*/
- (BOOL)checkConformToSkuConditions:(NSArray *)conditions {
    if (conditions.count != [_dataSource numberOfSectionsForPropertiesInFilter:self]) {
        return NO;
    }
    
    __block BOOL  flag = YES;
    [conditions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *properties = [_dataSource filter:self propertiesInSection:idx];
        if (![properties containsObject:obj]) {
            flag = NO;
            *stop = YES;
        }
    }];
    return flag;
}

/**获取属性*/
- (NSArray<KNSKUProperty *> *)propertiesWithConditionRawData:(NSArray *)data {
    
    NSMutableArray *array = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[self propertyOfValue:obj inSection:idx]];
    }];
    
    return array;
}

- (KNSKUProperty *)propertyOfValue:(id)value inSection:(NSInteger)section {
    
    NSArray *properties = [_dataSource filter:self propertiesInSection:section];
    
    NSString *str = [NSString stringWithFormat:@"Properties for %ld dosen‘t exist %@", (long)section, value];
    NSAssert([properties containsObject:value], str);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[properties indexOfObject:value] inSection:section];
    
    return [[KNSKUProperty alloc] initWithValue:value indexPath:indexPath];
}

/**获取条件式 对应 的数据*/
- (id)skuResultWithConditionIndexs:(NSArray<NSNumber *> *)conditionIndexs {
    
    __block id result = nil;
    
    [_conditions enumerateObjectsUsingBlock:^(KNSKUCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj.conditionIndexs isEqual:conditionIndexs]) {
            result = obj.result;
            *stop = YES;
        }
    }];
    
    return result;
}

/**获取初始可选的所有IndexPath*/
- (NSMutableSet<NSIndexPath *> *)getAllAvailableIndexPaths {
    
    NSMutableSet *set = [NSMutableSet set];
    [_conditions enumerateObjectsUsingBlock:^(KNSKUCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj.conditionIndexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            [set addObject:[NSIndexPath indexPathForItem:obj1.integerValue inSection:idx1]];
        }];
    }];
    
    _availableIndexPathsSet = set;
    
    _allAvailableIndexPaths = [set copy];
    
    return set;
}

/**选中某个属性时 根据已选中的系列属性 获取可选的IndexPath*/
- (NSMutableSet<NSIndexPath *> *)availableIndexPathsFromSelctedIndexPath:(NSIndexPath *)selectedIndexPath sectedIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
    NSMutableSet *set = [NSMutableSet set];
    [_conditions enumerateObjectsUsingBlock:^(KNSKUCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.conditionIndexs objectAtIndex:selectedIndexPath.section].integerValue == selectedIndexPath.item) {
            
            [obj.properties enumerateObjectsUsingBlock:^(KNSKUProperty * _Nonnull property, NSUInteger idx2, BOOL * _Nonnull stop1) {
                
                //从condition中添加种类不同的属性时，需要根据已选中的属性过滤
                //过滤方式为 condition要么包含已选中 要么和已选中属性是同级
                if (property.indexPath.section != selectedIndexPath.section) {
                    
                    __block BOOL flag = YES;
                    
                    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        flag = (([obj.conditionIndexs[obj1.section] integerValue] == obj1.row) || (obj1.section == property.indexPath.section)) && flag;
                    }];
                    
                    if (flag) {
                        [set addObject:property.indexPath];
                    }
                    
                }else {
                    [set addObject:property.indexPath];
                }
            }];
        }
    }];
    
    //合并本行数据
    [_allAvailableIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.section == selectedIndexPath.section) {
            [set addObject:obj];
        }
    }];
    
    return set;
}

/**当前可用的*/
- (void)updateAvailableIndexPaths {
    
    if (_selectedIndexPaths.count == 0) {
        
        _availableIndexPathsSet = [_allAvailableIndexPaths mutableCopy];
        return ;
    }
    
    __block NSMutableSet *set = [NSMutableSet set];
    
    NSMutableArray *seleted = [NSMutableArray array];
    
    [_selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [seleted addObject:obj];
        
        NSMutableSet *tempSet = nil;
        
        tempSet = [self availableIndexPathsFromSelctedIndexPath:obj sectedIndexPaths:seleted];
        
        if (set.count == 0) {
            set = [tempSet mutableCopy];
        }else {
            [set intersectSet:tempSet];
        }
        
    }];
    
    _availableIndexPathsSet = set;
    
    
}

/** 当前结果*/
- (void)updateCurrentResult {
    
    if (_selectedIndexPaths.count != [_dataSource numberOfSectionsForPropertiesInFilter:self]) {
        _currentResult = nil;
        return;
    }
    NSMutableArray *conditions = [NSMutableArray array];
    
    for (int i = 0; i < [_dataSource numberOfSectionsForPropertiesInFilter:self]; i ++) {
        [_selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.section == i) {
                [conditions addObject:@(obj.row)];
            }
        }];
        
    }
    _currentResult = [self skuResultWithConditionIndexs:[conditions copy]];
}

- (BOOL)isAvailableWithPropertyIndexPath:(NSIndexPath *)indexPath {
    
    __block BOOL isAvailable = NO;
    
    [_conditions enumerateObjectsUsingBlock:^(KNSKUCondition * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.conditionIndexs objectAtIndex:indexPath.section].integerValue == indexPath.row) {
            isAvailable = YES;
            *stop = YES;
        }
    }];;
    
    return isAvailable;
}


#pragma mark -- setter
- (void)setDataSource:(id<KNSKUDataFilterDataSource>)dataSource {
    _dataSource = dataSource;
    [self initPropertiesSkuListData];
}





@end
