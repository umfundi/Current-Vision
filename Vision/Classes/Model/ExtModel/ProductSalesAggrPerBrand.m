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

+ (NSArray *)ProductSalesGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:isYTD ? @"SALES_REPORT_by_Products_YTD" : @"SALES_REPORT_by_Products_MAT"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"id_product" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSString *format = [NSString stringWithFormat:@"%@ == %%@", aField];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, aValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    return [ProductSalesAggrPerBrand ProductSalesGroupByBrandFrom:reports YTDorMAT:isYTD];
}

+ (NSArray *)ProductSalesGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
{
    NSArray *filteredCustomers = [Customer searchCustomerIDsWithField:aField andValue:aValue];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:isYTD ? @"SALES_REPORT_by_Products_YTD" : @"SALES_REPORT_by_Products_MAT"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"id_product" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer in %@", filteredCustomers];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    return [ProductSalesAggrPerBrand ProductSalesGroupByBrandFrom:reports YTDorMAT:isYTD];
}


+ (NSArray *)ProductSalesGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD
{
    NSMutableDictionary *sales = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *totalSales = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (NSDictionary *report in reports)
    {
        NSString *id_product = [report objectForKey:@"id_product"];
        Product *product = [Product ProductFromProductID:id_product];
        
        NSString *period = [report objectForKey:@"period"];
        NSRange seperator_range = [period rangeOfString:@"-"];
        if (seperator_range.location != NSNotFound)
        {
            period = [period substringFromIndex:seperator_range.location + 1];
            
            seperator_range = [period rangeOfString:@"/"];
            if (seperator_range.location != NSNotFound)
                period = [period substringFromIndex:seperator_range.location + 1];
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
        [aggrPerYear addProductSale:report YTDorMAT:isYTD];
        
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
        [aggrPerYear addProductSale:report YTDorMAT:isYTD];

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
        [aggrPerYear addProductSale:report YTDorMAT:isYTD];
    }
    
    for (ProductSalesAggrPerBrand *aggrPerBrand in totalSales.allValues)
    {
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
    }
    
    for (ProductSalesAggrPerBrand *aggrPerBrand in sales.allValues)
    {
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
        
        for (ProductSalesAggrPerBrand *aggrPerProduct in aggrPerBrand.aggrPerProducts)
        {
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
                
                totalAggrPerYear.jan += aggrPerYear.jan;
                totalAggrPerYear.feb += aggrPerYear.feb;
                totalAggrPerYear.mar += aggrPerYear.mar;
                totalAggrPerYear.apr += aggrPerYear.apr;
                totalAggrPerYear.may += aggrPerYear.may;
                totalAggrPerYear.jun += aggrPerYear.jun;
                totalAggrPerYear.jul += aggrPerYear.jul;
                totalAggrPerYear.aug += aggrPerYear.aug;
                totalAggrPerYear.sep += aggrPerYear.sep;
                totalAggrPerYear.oct += aggrPerYear.oct;
                totalAggrPerYear.nov += aggrPerYear.nov;
                totalAggrPerYear.dec += aggrPerYear.dec;
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
        double prvVal;
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
        {
            if (prvAggrPerYear == nil)
            {
                aggrPerYear.growth = @"";
                prvAggrPerYear = aggrPerYear;
                prvVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
                continue;
            }
            
            double curVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
            if (prvVal == 0)
                aggrPerYear.growth = @"";
            else
                aggrPerYear.growth = [NSString stringWithFormat:@"%.0f%%", round((curVal / prvVal - 1) * 100)];
        }
        
        
        /* Growth per Products */
        for (ProductSalesAggrPerBrand *aggrPerProduct in aggrPerCustomer.aggrPerProducts)
        {
            ProductSalesAggrPerYear *prvAggrPerYear = nil;
            double prvVal;
            for (ProductSalesAggrPerYear *aggrPerYear in aggrPerProduct.aggrPerYears)
            {
                if (prvAggrPerYear == nil)
                {
                    aggrPerYear.growth = @"";
                    prvAggrPerYear = aggrPerYear;
                    prvVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
                    continue;
                }
                
                double curVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
                if (prvVal == 0)
                    aggrPerYear.growth = @"";
                else
                    aggrPerYear.growth = [NSString stringWithFormat:@"%.0f%%", round((curVal / prvVal - 1) * 100)];
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
    
    [aggrPerYears addObject:aggrPerYear];
}

- (void)addAggrPerProduct:(ProductSalesAggrPerBrand *)aggrPerProduct
{
    if (!aggrPerProducts)
        aggrPerProducts = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerProducts addObject:aggrPerProduct];
}

@end
