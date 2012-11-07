//
//  ProductSalesAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ProductSalesAggrPerBrand.h"

#import "User.h"
#import "Product.h"
#import "Customer.h"
#import "ProductSalesAggrPerYear.h"

@implementation ProductSalesAggrPerBrand

@synthesize brand;
@synthesize aggrPerYears;
@synthesize aggrPerProducts;

+ (NSArray *)ProductSalesGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull
{
    NSMutableDictionary *sales = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *totalSales = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (NSDictionary *report in reports)
    {
        NSString *id_product = [report objectForKey:@"id_product"];
        Product *product = [Product ProductFromProductID:id_product];
        
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
        
        ProductSalesAggrPerBrand *totalAggrPerClass = [totalSales objectForKey:product.pclass];
        if (!totalAggrPerClass)
        {
            totalAggrPerClass = [[ProductSalesAggrPerBrand alloc] init];
            totalAggrPerClass.brand = product.pclass;
            
            [totalSales setObject:totalAggrPerClass forKey:product.pclass];
        }
        
        ProductSalesAggrPerBrand *aggrPerBrand = [sales objectForKey:product.brand];
        if (!aggrPerBrand)
        {
            aggrPerBrand = [[ProductSalesAggrPerBrand alloc] init];
            aggrPerBrand.brand = product.brand;
            
            [sales setObject:aggrPerBrand forKey:product.brand];
        }
        
        ProductSalesAggrPerBrand *aggrPerProduct;
        for (aggrPerProduct in aggrPerBrand.aggrPerProducts)
        {
            if ([aggrPerProduct.brand isEqualToString:product.pname])
                break;
        }
        if (!aggrPerProduct)
        {
            aggrPerProduct = [[ProductSalesAggrPerBrand alloc] init];
            aggrPerProduct.brand = product.pname;
            
            [aggrPerBrand addAggrPerProduct:aggrPerProduct];
        }
        
        ProductSalesAggrPerYear *aggrPerYear;
        ProductSalesAggrPerYear *prvAggrPerYear;
        /* Add in Total */
        for (aggrPerYear in totalAggrPerClass.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        if (!aggrPerYear)
        {
            aggrPerYear = [[ProductSalesAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [totalAggrPerClass addAggrPerYear:aggrPerYear];
        }
        [aggrPerYear addProductSale:report YTDorMAT:isYTD isFull:isFull Year:period];
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
                prvAggrPerYear = [[ProductSalesAggrPerYear alloc] init];
                prvAggrPerYear.year = prevYear;
                
                [totalAggrPerClass addAggrPerYear:prvAggrPerYear];
            }
            [prvAggrPerYear addProductSale:report YTDorMAT:isYTD isFull:isFull Year:period];
        }
        
        /* Add in Product */
        for (aggrPerYear in aggrPerProduct.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        if (!aggrPerYear)
        {
            aggrPerYear = [[ProductSalesAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerProduct addAggrPerYear:aggrPerYear];
        }
        [aggrPerYear addProductSale:report YTDorMAT:isYTD isFull:isFull Year:period];
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
                prvAggrPerYear = [[ProductSalesAggrPerYear alloc] init];
                prvAggrPerYear.year = prevYear;
                
                [aggrPerProduct addAggrPerYear:prvAggrPerYear];
            }
            [prvAggrPerYear addProductSale:report YTDorMAT:isYTD isFull:isFull Year:period];
        }

        /* Add in Brand */
        for (aggrPerYear in aggrPerBrand.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        if (!aggrPerYear)
        {
            aggrPerYear = [[ProductSalesAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerBrand addAggrPerYear:aggrPerYear];
        }
        [aggrPerYear addProductSale:report YTDorMAT:isYTD isFull:isFull Year:period];
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
                prvAggrPerYear = [[ProductSalesAggrPerYear alloc] init];
                prvAggrPerYear.year = prevYear;
                
                [aggrPerBrand addAggrPerYear:prvAggrPerYear];
            }
            [prvAggrPerYear addProductSale:report YTDorMAT:isYTD isFull:isFull Year:period];
        }
    }
    
    for (ProductSalesAggrPerBrand *aggrPerBrand in totalSales.allValues)
    {
        if (isYTD || isFull)
            [aggrPerBrand.aggrPerYears removeLastObject];
            
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
    }
    
    for (ProductSalesAggrPerBrand *aggrPerBrand in sales.allValues)
    {
        if (isYTD || isFull)
            [aggrPerBrand.aggrPerYears removeLastObject];
        
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
        
        for (ProductSalesAggrPerBrand *aggrPerProduct in aggrPerBrand.aggrPerProducts)
        {
            if (isYTD || isFull)
                [aggrPerProduct.aggrPerYears removeLastObject];
            
            for (ProductSalesAggrPerYear *aggrPerYear in aggrPerProduct.aggrPerYears)
                [aggrPerYear finishAdd];
        }
    }
    
    
    NSMutableArray *productSales = [[NSMutableArray alloc] initWithArray:sales.allValues];
    
    /* Add Total */
    if ([sales count] > 0)
    {
        ProductSalesAggrPerBrand *totalAggr = [[ProductSalesAggrPerBrand alloc] init];
        totalAggr.brand = @"Total";
        
        for (ProductSalesAggrPerBrand *aggrPerCustomer in sales.allValues)
        {
            for (ProductSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
            {
                ProductSalesAggrPerYear *totalAggrPerYear;
                for (totalAggrPerYear in totalAggr.aggrPerYears)
                {
                    if ([aggrPerYear.year isEqualToString:totalAggrPerYear.year])
                        break;
                }
                
                if (!totalAggrPerYear)
                {
                    totalAggrPerYear = [[ProductSalesAggrPerYear alloc] init];
                    totalAggrPerYear.year = aggrPerYear.year;
                    [totalAggr addAggrPerYear:totalAggrPerYear];
                }
                
                for (NSInteger i = 0 ; i < 12 ; i ++)
                    totalAggrPerYear.monthValArray[i] += aggrPerYear.monthValArray[i];
            }
        }
        for (ProductSalesAggrPerYear *aggrPerYear in totalAggr.aggrPerYears)
            [aggrPerYear finishAdd];
        
        [productSales insertObject:totalAggr atIndex:0];
    }
    [productSales addObjectsFromArray:totalSales.allValues];
    
    
    /* Growth */
    for (ProductSalesAggrPerBrand *aggrPerCustomer in productSales)
    {
        ProductSalesAggrPerYear *prvAggrPerYear = nil;
        double prvVal = 0;
        ProductSalesAggrPerYear *aggrPerYear;
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

            if (prvVal == 0)
                aggrPerYear.growth = 0;
            else
                aggrPerYear.growth = round((curVal / prvVal - 1) * 100);
            
            prvVal = curVal;
        }
        
        
        /* Growth per Products */
        for (ProductSalesAggrPerBrand *aggrPerProduct in aggrPerCustomer.aggrPerProducts)
        {
            ProductSalesAggrPerYear *prvAggrPerYear = nil;
            double prvVal = 0;
            for (ProductSalesAggrPerYear *aggrPerYear in aggrPerProduct.aggrPerYears)
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
    
    
    for (ProductSalesAggrPerBrand *aggrPerCustomer in totalSales.allValues)
    {
        while (aggrPerCustomer.aggrPerYears.count > 1)
            [aggrPerCustomer.aggrPerYears removeLastObject];
        
        ProductSalesAggrPerYear *aggrPerYear = [aggrPerCustomer.aggrPerYears lastObject];
        aggrPerYear.year = [@"Total " stringByAppendingString:aggrPerCustomer.brand];
        
        aggrPerCustomer.brand = nil;
    }
    
    return productSales;
}


- (void)addAggrPerYear:(ProductSalesAggrPerYear *)aggrPerYear
{
    if (!aggrPerYears)
        aggrPerYears = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger index = 0;
    for (ProductSalesAggrPerYear *aggr in aggrPerYears)
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

- (void)addAggrPerProduct:(ProductSalesAggrPerBrand *)aggrPerProduct
{
    if (!aggrPerProducts)
        aggrPerProducts = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerProducts addObject:aggrPerProduct];
}

@end
