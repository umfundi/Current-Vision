//
//  ErReportAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ErReportAggrPerBrand.h"

#import "User.h"
#import "Customer.h"
#import "Product.h"
#import "Focused_brand.h"
#import "ErReportAggrPerYear.h"

@implementation ErReportAggrPerBrand

@synthesize brand;
@synthesize aggrPerYears;
@synthesize aggrPerProducts;

+ (NSArray *)ErReportGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull
{
    NSMutableDictionary *sales = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *totalSales = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    BOOL isCompanion = [[User loginUser].data isEqualToString:@"companion"];
    
    for (NSDictionary *report in reports)
    {
        NSString *id_product = [report objectForKey:@"id_product"];
        Product *product = [Product ProductFromProductID:id_product];
        NSString *brand_class = [Focused_brand brandClassFromName:product.brand];

        if (![brand_class isEqualToString:@"FOCUSED"] && ![brand_class isEqualToString:isCompanion ? @"companion" : @"ruminant"])
            continue;
        
        NSString *period = [report objectForKey:@"period"];
        if (isYTD || isFull)
        {
            NSRange seperator_range = [period rangeOfString:@"-"];
            if (seperator_range.location != NSNotFound)
            {
                period = [period substringFromIndex:seperator_range.location + 1];
                
                seperator_range = [period rangeOfString:@"/"];
                if (seperator_range.location != NSNotFound)
                    period = [period substringFromIndex:seperator_range.location + 1];
            }
        }
        
        ErReportAggrPerBrand *totalAggrPerClass = [totalSales objectForKey:product.pclass];
        if (!totalAggrPerClass)
        {
            totalAggrPerClass = [[ErReportAggrPerBrand alloc] init];
            totalAggrPerClass.brand = product.pclass;
            
            [totalSales setObject:totalAggrPerClass forKey:product.pclass];
        }
        
        ErReportAggrPerBrand *aggrPerBrand = [sales objectForKey:product.brand];
        if (!aggrPerBrand)
        {
            aggrPerBrand = [[ErReportAggrPerBrand alloc] init];
            aggrPerBrand.brand = product.brand;
            
            [sales setObject:aggrPerBrand forKey:product.brand];
        }
        
        ErReportAggrPerBrand *aggrPerProduct;
        for (aggrPerProduct in aggrPerBrand.aggrPerProducts)
        {
            if ([aggrPerProduct.brand isEqualToString:product.pname])
                break;
        }
        if (!aggrPerProduct)
        {
            aggrPerProduct = [[ErReportAggrPerBrand alloc] init];
            aggrPerProduct.brand = product.pname;
            
            [aggrPerBrand addAggrPerProduct:aggrPerProduct];
        }

        ErReportAggrPerYear *aggrPerYear;
        ErReportAggrPerYear *prvAggrPerYear;
        /* Add in Total */
        for (aggrPerYear in totalAggrPerClass.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        if (!aggrPerYear)
        {
            aggrPerYear = [[ErReportAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [totalAggrPerClass addAggrPerYear:aggrPerYear];
        }
        [aggrPerYear addErReport:report YTDorMAT:isYTD isFull:isFull Year:period];
        if (isYTD || isFull)
        {
            NSString *prevYear = [NSString stringWithFormat:@"%d", [period integerValue] - 1];
            for (prvAggrPerYear in totalAggrPerClass.aggrPerYears)
            {
                if ([prvAggrPerYear.year isEqualToString:prevYear])
                    break;
            }
            if (!prvAggrPerYear)
            {
                prvAggrPerYear = [[ErReportAggrPerYear alloc] init];
                prvAggrPerYear.year = prevYear;
                
                [totalAggrPerClass addAggrPerYear:prvAggrPerYear];
            }
            [prvAggrPerYear addErReport:report YTDorMAT:isYTD isFull:isFull Year:period];
        }

        /* Add in Product */
        for (aggrPerYear in aggrPerProduct.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        if (!aggrPerYear)
        {
            aggrPerYear = [[ErReportAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerProduct addAggrPerYear:aggrPerYear];
        }
        [aggrPerYear addErReport:report YTDorMAT:isYTD isFull:isFull Year:period];
        if (isYTD || isFull)
        {
            NSString *prevYear = [NSString stringWithFormat:@"%d", [period integerValue] - 1];
            for (prvAggrPerYear in aggrPerProduct.aggrPerYears)
            {
                if ([prvAggrPerYear.year isEqualToString:prevYear])
                    break;
            }
            if (!prvAggrPerYear)
            {
                prvAggrPerYear = [[ErReportAggrPerYear alloc] init];
                prvAggrPerYear.year = prevYear;
                
                [aggrPerProduct addAggrPerYear:prvAggrPerYear];
            }
            [prvAggrPerYear addErReport:report YTDorMAT:isYTD isFull:isFull Year:period];
        }
        
        /* Add in Brand */
        for (aggrPerYear in aggrPerBrand.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        if (!aggrPerYear)
        {
            aggrPerYear = [[ErReportAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerBrand addAggrPerYear:aggrPerYear];
        }
        [aggrPerYear addErReport:report YTDorMAT:isYTD isFull:isFull Year:period];
        
        if (isYTD || isFull)
        {
            NSString *prevYear = [NSString stringWithFormat:@"%d", [period integerValue] - 1];
            for (prvAggrPerYear in aggrPerBrand.aggrPerYears)
            {
                if ([prvAggrPerYear.year isEqualToString:prevYear])
                    break;
            }
            if (!prvAggrPerYear)
            {
                prvAggrPerYear = [[ErReportAggrPerYear alloc] init];
                prvAggrPerYear.year = prevYear;
                
                [aggrPerBrand addAggrPerYear:prvAggrPerYear];
            }
            [prvAggrPerYear addErReport:report YTDorMAT:isYTD isFull:isFull Year:period];
        }
    }
    
    for (ErReportAggrPerBrand *aggrPerBrand in totalSales.allValues)
    {
        if (isYTD || isFull)
            [aggrPerBrand.aggrPerYears removeLastObject];
        for (ErReportAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
    }
    
    for (ErReportAggrPerBrand *aggrPerBrand in sales.allValues)
    {
        if (isYTD || isFull)
            [aggrPerBrand.aggrPerYears removeLastObject];

        for (ErReportAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
        
        for (ErReportAggrPerBrand *aggrPerProduct in aggrPerBrand.aggrPerProducts)
        {
            if (isYTD || isFull)
                [aggrPerProduct.aggrPerYears removeLastObject];

            for (ErReportAggrPerYear *aggrPerYear in aggrPerProduct.aggrPerYears)
                [aggrPerYear finishAdd];
        }
    }
    
    
    NSMutableArray *erReport = [[NSMutableArray alloc] initWithArray:sales.allValues];
    
    /* Add Total */
    if ([sales count] != 0)
    {
        ErReportAggrPerBrand *totalAggr = [[ErReportAggrPerBrand alloc] init];
        totalAggr.brand = @"Total";
        
        for (ErReportAggrPerBrand *aggrPerCustomer in sales.allValues)
        {
            for (ErReportAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
            {
                ErReportAggrPerYear *totalAggrPerYear;
                for (totalAggrPerYear in totalAggr.aggrPerYears)
                {
                    if ([aggrPerYear.year isEqualToString:totalAggrPerYear.year])
                        break;
                }
                
                if (!totalAggrPerYear)
                {
                    totalAggrPerYear = [[ErReportAggrPerYear alloc] init];
                    totalAggrPerYear.year = aggrPerYear.year;
                    [totalAggr addAggrPerYear:totalAggrPerYear];
                }
                
                for (NSInteger i = 0 ; i < 12 ; i ++)
                    totalAggrPerYear.monthValArray[i] += aggrPerYear.monthValArray[i];
            }
        }
        for (ErReportAggrPerYear *aggrPerYear in totalAggr.aggrPerYears)
            [aggrPerYear finishAdd];
        
        [erReport insertObject:totalAggr atIndex:0];
    }
    [erReport addObjectsFromArray:totalSales.allValues];

    /* Growth */
    for (ErReportAggrPerBrand *aggrPerCustomer in erReport)
    {
        ErReportAggrPerYear *prvAggrPerYear = nil;
        double prvVal = 0;
        ErReportAggrPerYear *aggrPerYear;
        for (NSInteger i = aggrPerCustomer.aggrPerYears.count - 1 ; i >= 0 ; i -- )
        {
            aggrPerYear = [aggrPerCustomer.aggrPerYears objectAtIndex:i];
            if (prvAggrPerYear == nil)
            {
                aggrPerYear.growth = 0;
                prvAggrPerYear = aggrPerYear;
                
                for (NSInteger i = 0 ; i < 12 ; i ++ )
                    prvVal += aggrPerYear.monthValArray[i];
                continue;
            }
            
            double curVal = 0;
            for (NSInteger i = 0 ; i < 12 ; i ++ )
                curVal += aggrPerYear.monthValArray[i];
            
            // iHm
            if (prvVal == 0)
                aggrPerYear.growth = 0;
            else
                aggrPerYear.growth = round((curVal / prvVal - 1) * 100);
            
            prvVal = curVal;
        }
        
        for (ErReportAggrPerBrand *aggrPerProduct in aggrPerCustomer.aggrPerProducts)
        {
            ErReportAggrPerYear *prvAggrPerYear = nil;
            double prvVal = 0;
            for (ErReportAggrPerYear *aggrPerYear in aggrPerProduct.aggrPerYears)
            {
                if (prvAggrPerYear == nil)
                {
                    aggrPerYear.growth = 0;
                    prvAggrPerYear = aggrPerYear;
                    
                    for (NSInteger i = 0 ; i < 12 ; i ++ )
                        prvVal += aggrPerYear.monthValArray[i];
                    continue;
                }
                
                double curVal = 0;
                for (NSInteger i = 0 ; i < 12 ; i ++ )
                    curVal += aggrPerYear.monthValArray[i];
                
                if (prvVal == 0)
                    aggrPerYear.growth = 0;
                else
                    aggrPerYear.growth = round((curVal / prvVal - 1) * 100);
                
                prvVal = curVal;
            }
        }
    }
    
    for (ErReportAggrPerBrand *aggrPerCustomer in totalSales.allValues)
    {
        while (aggrPerCustomer.aggrPerYears.count > 1)
            [aggrPerCustomer.aggrPerYears removeLastObject];
        
        ErReportAggrPerYear *aggrPerYear = [aggrPerCustomer.aggrPerYears lastObject];
        aggrPerYear.year = [@"Total " stringByAppendingString:aggrPerCustomer.brand];
        
        aggrPerCustomer.brand = nil;
    }

    return erReport;
}

- (void)addAggrPerYear:(ErReportAggrPerYear *)aggrPerYear
{
    if (!aggrPerYears)
        aggrPerYears = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger index = 0;
    for (ErReportAggrPerYear *aggr in aggrPerYears)
    {
        if ([aggr.year compare:aggrPerYear.year] == NSOrderedAscending)
        {
            [aggrPerYears insertObject:aggrPerYear atIndex:index];
            return;
        }
        
        index ++;
    }
    
    [aggrPerYears addObject:aggrPerYear];
}

- (void)addAggrPerProduct:(ErReportAggrPerBrand *)aggrPerProduct
{
    if (!aggrPerProducts)
        aggrPerProducts = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerProducts addObject:aggrPerProduct];
}

@end
