//
//  ProductSalesAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ProductSalesAggrPerYear.h"
#import "Product.h"
#import "User.h"

@implementation ProductSalesAggrPerYear

@synthesize year;
@synthesize monthValArray, monthValStringArray;
@synthesize totq1;
@synthesize totq2;
@synthesize totq3;
@synthesize totq4;
@synthesize value, growth;
@synthesize qty, qtygrowth;

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

- (void)addProductSale:(NSDictionary *)productSale YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull Year:(NSString *)yearInData
{
    if (!isYTD && !isFull)
    {
        if (![yearInData isEqualToString:year])
            return;
        
        // MAT
        for (NSInteger i = 0 ; i < 12 ; i ++ )
        {
            NSInteger col_index = 11 - i;
            if (col_index == 0)
                monthValArray[i] += [[productSale objectForKey:@"m0val"] doubleValue];
            else
                monthValArray[i] += [[productSale objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
        }
    }
    else if (isYTD && !isFull)
    {
        // YTD
        NSInteger currentMonth = [[User loginUser] monthForData] - 1;
        
        if (![yearInData isEqualToString:year])
        {
            for (NSInteger i = currentMonth ; i < 12 ; i ++ )
            {
                NSInteger col_index = (11 - i + currentMonth);
                if (col_index == 0)
                    monthValArray[i] += [[productSale objectForKey:@"m0val"] doubleValue];
                else
                    monthValArray[i] += [[productSale objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
            }
        }
        else
        {
            for (NSInteger i = 0 ; i < currentMonth ; i ++ )
            {
                NSInteger col_index = currentMonth - i - 1;
                if (col_index == 0)
                    monthValArray[i] += [[productSale objectForKey:@"m0val"] doubleValue];
                else
                    monthValArray[i] += [[productSale objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
            }
        }
    }
    else if (isFull)
    {
        // Full
        NSInteger currentMonth = [[User loginUser] monthForData] - 1;
        
        if (![yearInData isEqualToString:year])
        {
            for (NSInteger i = currentMonth ; i < 12 ; i ++ )
            {
                NSInteger col_index = (11 - i + currentMonth);
                if (col_index == 0)
                    monthValArray[i] += [[productSale objectForKey:@"m0val"] doubleValue];
                else
                    monthValArray[i] += [[productSale objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
            }
        }
        else
        {
            for (NSInteger i = 0 ; i < currentMonth ; i ++ )
            {
                NSInteger col_index = currentMonth - i - 1;
                if (col_index == 0)
                    monthValArray[i] += [[productSale objectForKey:@"m0val"] doubleValue];
                else
                    monthValArray[i] += [[productSale objectForKey:[NSString stringWithFormat:@"m_%dval", col_index]] doubleValue];
            }
        }
    }
}

- (void)finishAdd
{
    monthValStringArray = [NSArray arrayWithObjects:
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[0])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[1])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[2])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[3])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[4])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[5])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[6])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[7])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[8])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[9])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[10])],
                           [NSString stringWithFormat:@"%.0f", round(monthValArray[11])],
                           nil];
    
    double tot1 = monthValArray[0] + monthValArray[1] + monthValArray[2];
    totq1 = [NSString stringWithFormat:@"%.0f", round(tot1)];
    
    double tot2 = monthValArray[3] + monthValArray[4] + monthValArray[5];
    totq2 = [NSString stringWithFormat:@"%.0f", round(tot2)];
    
    double tot3 = monthValArray[6] + monthValArray[7] + monthValArray[8];
    totq3 = [NSString stringWithFormat:@"%.0f", round(tot3)];
    
    double tot4 = monthValArray[9] + monthValArray[10] + monthValArray[11];
    totq4 = [NSString stringWithFormat:@"%.0f", round(tot4)];
    
    value = [NSString stringWithFormat:@"%.0f", round(tot1 + tot2 + tot3 + tot4)];
}

@end
