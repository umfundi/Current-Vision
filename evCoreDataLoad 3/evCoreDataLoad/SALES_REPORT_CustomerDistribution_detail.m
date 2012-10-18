//
//  SALES_REPORT_CustomerDistribution_detail.m
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SALES_REPORT_CustomerDistribution_detail.h"


@implementation SALES_REPORT_CustomerDistribution_detail

@dynamic id_user;
@dynamic ctype;
@dynamic plevel;
@dynamic ptype;
@dynamic brand;
@dynamic id_product;
@dynamic pname;
@dynamic dl;
@dynamic interval;
@dynamic id_customer;
@dynamic pvalprv;
@dynamic pvalcur;

- (void) fromJSONObject:(id) object
{
    self.id_user = [object objectForKey:@"id_user"] ? [object objectForKey:@"id_user"] : @"";
    self.ctype = [object objectForKey:@"ctype"] ? [object objectForKey:@"ctype"] : @"";
    self.plevel = [object objectForKey:@"plevel"] ? [object objectForKey:@"plevel"] : @"";
    self.ptype = [object objectForKey:@"ptype"] ? [object objectForKey:@"ptype"] : @"";
    self.brand = [object objectForKey:@"brand"] ? [object objectForKey:@"brand"] : @"";
    self.id_product = [object objectForKey:@"id_product"] ? [object objectForKey:@"id_product"] : @"";
    self.pname = [object objectForKey:@"pname"] ? [object objectForKey:@"pname"] : @"";
    self.dl = [object objectForKey:@"DL"] ? [object objectForKey:@"DL"] : @"";
    self.interval = [object objectForKey:@"interval"] ? [object objectForKey:@"interval"] : @"";
    self.id_customer = [object objectForKey:@"id_customer"] ? [object objectForKey:@"id_customer"] : @"";
    self.pvalprv = [object objectForKey:@"pvalprv"] ? [object objectForKey:@"pvalprv"] : @"";
    self.pvalcur = [object objectForKey:@"pvalcur"] ? [object objectForKey:@"pvalcur"] : @"";
}

@end
