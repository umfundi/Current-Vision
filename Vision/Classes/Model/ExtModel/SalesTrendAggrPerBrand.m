//
//  SalesTrendAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesTrendAggrPerBrand.h"

#import "User.h"
#import "Customer.h"
#import "umfundiCommon.h"

@implementation SalesTrendAggrPerBrand

@synthesize brand;
@synthesize monthValArray, monthValStringArray;
@synthesize growthString;

- (id)init
{
    self = [super init];
    if (self)
    {
        monthValArray = (double *)malloc(sizeof(double) * 13);
        for (NSInteger i = 0 ; i < 12 ; i ++ )
            monthValArray[i] = 0;
    }
    
    return self;
}

+ (NSArray *)SalesTrendsGroupByBrandFrom:(NSArray *)trends YTDorMAT:(BOOL)isYTD
{
    NSMutableArray *aggrs = [[NSMutableArray alloc] initWithCapacity:0];
    SalesTrendAggrPerBrand *aggrPerBrand = [[SalesTrendAggrPerBrand alloc] init];
    for (NSDictionary *trend in trends)
    {
        NSString *brand = [trend objectForKey:@"brand"];
        
        if (aggrPerBrand.brand == nil)
            aggrPerBrand.brand = brand;
        else if (![aggrPerBrand.brand isEqualToString:brand])
        {
            [aggrPerBrand finishAdd];
            [aggrs addObject:aggrPerBrand];
            
            aggrPerBrand = [[SalesTrendAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
        }
        
        [aggrPerBrand addSalesTrend:trend YTDorMAT:isYTD];
    }
    
    if (aggrPerBrand.brand)
    {
        [aggrPerBrand finishAdd];
        [aggrs addObject:aggrPerBrand];
    }
    
    /* Total */
    SalesTrendAggrPerBrand *totalAggr = [[SalesTrendAggrPerBrand alloc] init];
    totalAggr.brand = @"TOTAL";
    for (SalesTrendAggrPerBrand *aggrPerBrand in aggrs)
    {
        for (NSInteger i = 0 ; i < 12 ; i ++ )
            totalAggr.monthValArray[i] += aggrPerBrand.monthValArray[i];
    }
    [totalAggr finishAdd];
    [aggrs addObject:totalAggr];
    
    return aggrs;
}


- (void)addSalesTrend:(NSDictionary *)trend YTDorMAT:(BOOL)isYTD
{
    if (isYTD)
    {
        monthValArray[0] += [[trend objectForKey:@"janval"] doubleValue];
        monthValArray[1] += [[trend objectForKey:@"febval"] doubleValue];
        monthValArray[2] += [[trend objectForKey:@"marval"] doubleValue];
        monthValArray[3] += [[trend objectForKey:@"aprval"] doubleValue];
        monthValArray[4] += [[trend objectForKey:@"mayval"] doubleValue];
        monthValArray[5] += [[trend objectForKey:@"junval"] doubleValue];
        monthValArray[6] += [[trend objectForKey:@"julval"] doubleValue];
        monthValArray[7] += [[trend objectForKey:@"augval"] doubleValue];
        monthValArray[8] += [[trend objectForKey:@"sepval"] doubleValue];
        monthValArray[9] += [[trend objectForKey:@"octval"] doubleValue];
        monthValArray[10] += [[trend objectForKey:@"novval"] doubleValue];
        monthValArray[11] += [[trend objectForKey:@"decval"] doubleValue];
    }
    else
    {
        for (NSInteger i = 0 ; i < 12 ; i ++ )
        {
            NSInteger col_index = 11 - i;
            if (col_index == 0)
                monthValArray[i] += [[trend objectForKey:@"m0val"] doubleValue];
            else
                monthValArray[i] += [[trend objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
        }
    }
}

- (void)finishAdd
{
#warning growth in SalesTrend
    growthString = [NSString stringWithFormat:@"%.0f%%", round(0)];
}

- (SalesTrendAggrPerBrand *)convertToYearAggr
{
    SalesTrendAggrPerBrand *yearAggr = [[SalesTrendAggrPerBrand alloc] init];
    
    yearAggr.brand = brand;
    yearAggr.monthValArray[0] = monthValArray[0];
    for (NSInteger i = 1 ; i < 12 ; i ++ )
        yearAggr.monthValArray[i] = yearAggr.monthValArray[i - 1] + monthValArray[i];
    [yearAggr finishAdd];
    
    return yearAggr;
}

@end
