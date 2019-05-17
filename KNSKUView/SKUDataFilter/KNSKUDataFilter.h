//
//  KNSKUDataFilter.h
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


#import <Foundation/Foundation.h>
#import "KNSKUProperty.h"
#import "KNSKUCondition.h"

NS_ASSUME_NONNULL_BEGIN


@class KNSKUDataFilter;
@protocol KNSKUDataFilterDataSource <NSObject>

@required
/**属性种类总个数*/
- (NSInteger)numberOfSectionsForPropertiesInFilter:(KNSKUDataFilter *)filter;

/*
 * 每个种类所有的的属性值
 * 这里不关心具体的值，可以是属性ID, 属性名，字典、model
 */
- (NSArray *)filter:(KNSKUDataFilter *)filter propertiesInSection:(NSInteger)section;

/**满足条件的总个数*/
- (NSInteger)numberOfConditionsInFilter:(KNSKUDataFilter *)filter;

/*
 * 对应的条件式
 * 这里条件式的属性值，需要和propertiesInSection里面的数据类型保持一致
 */
- (NSArray *)filter:(KNSKUDataFilter *)filter conditionForRow:(NSInteger)row;

/**条件式 对应的 结果数据（库存、价格等）可用于显示对应规格商品的数据*/
- (id)filter:(KNSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row;
@end

@interface KNSKUDataFilter : NSObject



@property (nonatomic, assign) id<KNSKUDataFilterDataSource> dataSource;

/**当前 选中的属性indexPath*/
@property (nonatomic, strong, readonly) NSArray <NSIndexPath *> *selectedIndexPaths;
/**当前 可选的属性indexPath*/
@property (nonatomic, strong, readonly) NSSet <NSIndexPath *> *availableIndexPathsSet;
/**当前 结果*/
@property (nonatomic, strong, readonly) id  currentResult;


/**init*/
- (instancetype)initWithDataSource:(id<KNSKUDataFilterDataSource>)dataSource;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;


/**选中 属性的时候 调用*/
- (void)didSelectedPropertyWithIndexPath:(NSIndexPath *)indexPath;

/**重新加载数据*/
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END