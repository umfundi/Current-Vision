//
//  ErReportAggrPerBrand.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ErReportAggrPerYear;

@interface ErReportAggrPerBrand : NSObject

@property (nonatomic, retain) NSString *brand;
@property (nonatomic, retain) NSMutableArray *aggrPerYears;

+ (NSArray *)ErReportGroupByBrandFrom:(NSString *)customer;

- (void)addAggrPerYear:(ErReportAggrPerYear *)aggrPerYear;

@end
