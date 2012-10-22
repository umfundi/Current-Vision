//
//  PracticeAggrPerBrand.m
//  Vision
//
//  Created by Ian Molesworth on 22/10/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "PracticeAggrPerBrand.h"
#import "User.h"

@implementation PracticeAggrPerBrand

@synthesize brand;
@synthesize month, monthString;
@synthesize ytd, ytdString;
@synthesize mat, matString;
@synthesize monthprv, monthprvString;
@synthesize ytdprv, ytdprvString;
@synthesize matprv, matprvString;

@synthesize monthpro;
@synthesize ytdpro;
@synthesize matpro;

- (void)addSalesReport:(NSDictionary *)report
{
    month += [[report objectForKey:@"m0val"] doubleValue];
    ytd += [[report objectForKey:@"ytdvalcur"] doubleValue];
    mat += [[report objectForKey:@"matvalcur"] doubleValue];
#warning monthprv in SalesGrid
    monthprv += [[report objectForKey:@"m0val"] doubleValue];
    ytdprv += [[report objectForKey:@"ytdvalprv"] doubleValue];
    matprv += [[report objectForKey:@"matvalprv"] doubleValue];
}

- (void)finishAdd
{
    monthString = [NSString stringWithFormat:@"%.0f", round(month)];
    ytdString = [NSString stringWithFormat:@"%.0f", round(ytd)];
    matString = [NSString stringWithFormat:@"%.0f", round(mat)];
    monthprvString = [NSString stringWithFormat:@"%.0f", round(monthprv)];
    ytdprvString = [NSString stringWithFormat:@"%.0f", round(ytdprv)];
    matprvString = [NSString stringWithFormat:@"%.0f", round(matprv)];
    
    if (monthprv == 0)
        monthpro = @"";
    else
        monthpro = [NSString stringWithFormat:@"%.0f%%", round((month - monthprv) / monthprv * 100)];
    if (ytdprv == 0)
        ytdpro = @"";
    else
        ytdpro = [NSString stringWithFormat:@"%.0f%%", round((ytd - ytdprv) / ytdprv * 100)];
    if (matprv == 0)
        matpro = @"";
    else
        matpro = [NSString stringWithFormat:@"%.0f%%", round((mat - matprv) / matprv * 100)];
}
@end
