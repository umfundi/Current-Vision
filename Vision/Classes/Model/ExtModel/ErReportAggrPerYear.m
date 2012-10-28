//
//  ErReportAggrPerYear.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ErReportAggrPerYear.h"

@implementation ErReportAggrPerYear

@synthesize year;
@synthesize jan, janString;
@synthesize feb, febString;
@synthesize mar, marString;
@synthesize totq1;
@synthesize apr, aprString;
@synthesize may, mayString;
@synthesize jun, junString;
@synthesize totq2;
@synthesize jul, julString;
@synthesize aug, augString;
@synthesize sep, sepString;
@synthesize totq3;
@synthesize oct, octString;
@synthesize nov, novString;
@synthesize dec, decString;
@synthesize totq4;
@synthesize value, growth;
@synthesize qty, qtygrowth;

- (void)addErReport:(NSDictionary *)erReport YTDorMAT:(BOOL)isYTD
{
    jan += [[erReport objectForKey:@"m_11val"] doubleValue];
    feb += [[erReport objectForKey:@"m_10val"] doubleValue];
    mar += [[erReport objectForKey:@"m_9val"] doubleValue];
    apr += [[erReport objectForKey:@"m_8val"] doubleValue];
    may += [[erReport objectForKey:@"m_7val"] doubleValue];
    jun += [[erReport objectForKey:@"m_6val"] doubleValue];
    jul += [[erReport objectForKey:@"m_5val"] doubleValue];
    aug += [[erReport objectForKey:@"m_4val"] doubleValue];
    sep += [[erReport objectForKey:@"m_3val"] doubleValue];
    oct += [[erReport objectForKey:@"m_2val"] doubleValue];
    nov += [[erReport objectForKey:@"m_1val"] doubleValue];
    dec += [[erReport objectForKey:@"m0val"] doubleValue];
}

- (void)finishAdd
{
    janString = [NSString stringWithFormat:@"%.0f", round(jan)];
    febString = [NSString stringWithFormat:@"%.0f", round(feb)];
    marString = [NSString stringWithFormat:@"%.0f", round(mar)];
    totq1 = [NSString stringWithFormat:@"%.0f", round(jan + feb + mar)];
    aprString = [NSString stringWithFormat:@"%.0f", round(apr)];
    mayString = [NSString stringWithFormat:@"%.0f", round(may)];
    junString = [NSString stringWithFormat:@"%.0f", round(jun)];
    totq2 = [NSString stringWithFormat:@"%.0f", round(apr + may + jun)];
    julString = [NSString stringWithFormat:@"%.0f", round(jul)];
    augString = [NSString stringWithFormat:@"%.0f", round(aug)];
    sepString = [NSString stringWithFormat:@"%.0f", round(sep)];
    totq3 = [NSString stringWithFormat:@"%.0f", round(jul + aug + sep)];
    octString = [NSString stringWithFormat:@"%.0f", round(oct)];
    novString = [NSString stringWithFormat:@"%.0f", round(nov)];
    decString = [NSString stringWithFormat:@"%.0f", round(dec)];
    totq4 = [NSString stringWithFormat:@"%.0f", round(oct + nov + dec)];
    value = [NSString stringWithFormat:@"%.0f", round(jan + feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec)];
//#warning growth in ErReport
//    growth = [NSString stringWithFormat:@"%.0f%%", round(0)];
//#warning qty in ProductSales
//    qty = [NSString stringWithFormat:@"%.0f%%", round(0)];
//#warning growth in ProductSales
//    qtygrowth = [NSString stringWithFormat:@"%.0f%%", round(0)];
}

@end
