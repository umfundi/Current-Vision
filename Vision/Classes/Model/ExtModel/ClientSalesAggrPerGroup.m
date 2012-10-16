//
//  ClientSalesAggrPerGroup.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ClientSalesAggrPerGroup.h"

@implementation ClientSalesAggrPerGroup

@synthesize group;
@synthesize rank;

@synthesize jan;
@synthesize janString;
@synthesize feb;
@synthesize febString;
@synthesize mar;
@synthesize marString;
@synthesize apr;
@synthesize aprString;
@synthesize may;
@synthesize mayString;
@synthesize jun;
@synthesize junString;
@synthesize jul;
@synthesize julString;
@synthesize aug;
@synthesize augString;
@synthesize sep;
@synthesize sepString;
@synthesize oct;
@synthesize octString;
@synthesize nov;
@synthesize novString;
@synthesize dec;
@synthesize decString;
@synthesize yearsum;
@synthesize yearsumString;
@synthesize totpro;
@synthesize lastyearsum;
@synthesize lastyearsumString;
@synthesize diffpro;
@synthesize diffsum;

- (void)addClientSales:(NSDictionary *)report
{
    jan += [[report objectForKey:@"janval"] doubleValue];
    feb += [[report objectForKey:@"febval"] doubleValue];
    mar += [[report objectForKey:@"marval"] doubleValue];
    apr += [[report objectForKey:@"aprval"] doubleValue];
    may += [[report objectForKey:@"mayval"] doubleValue];
    jun += [[report objectForKey:@"junval"] doubleValue];
    jul += [[report objectForKey:@"julval"] doubleValue];
    aug += [[report objectForKey:@"augval"] doubleValue];
    sep += [[report objectForKey:@"sepval"] doubleValue];
    oct += [[report objectForKey:@"octval"] doubleValue];
    nov += [[report objectForKey:@"novval"] doubleValue];
    dec += [[report objectForKey:@"decval"] doubleValue];
}

- (void)finishAdd
{
    janString = [NSString stringWithFormat:@"%.0f", round(jan)];
    febString = [NSString stringWithFormat:@"%.0f", round(feb)];
    marString = [NSString stringWithFormat:@"%.0f", round(mar)];
    aprString = [NSString stringWithFormat:@"%.0f", round(apr)];
    mayString = [NSString stringWithFormat:@"%.0f", round(may)];
    junString = [NSString stringWithFormat:@"%.0f", round(jun)];
    julString = [NSString stringWithFormat:@"%.0f", round(jul)];
    augString = [NSString stringWithFormat:@"%.0f", round(aug)];
    sepString = [NSString stringWithFormat:@"%.0f", round(sep)];
    octString = [NSString stringWithFormat:@"%.0f", round(oct)];
    novString = [NSString stringWithFormat:@"%.0f", round(nov)];
    decString = [NSString stringWithFormat:@"%.0f", round(dec)];
    
    yearsum = jan + feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec;
    yearsumString = [NSString stringWithFormat:@"%.0f", round(yearsum)];

    lastyearsum = yearsum;
    lastyearsumString = [NSString stringWithFormat:@"%.0f", round(lastyearsum)];
    
    if (lastyearsum)
        diffpro = [NSString stringWithFormat:@"%.0f%%", round((yearsum - lastyearsum) / lastyearsum)];
    diffsum = [NSString stringWithFormat:@"%.0f%%", round(yearsum - lastyearsum)];
}

@end
