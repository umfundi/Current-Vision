//
//  SALES_REPORT_by_Products.m
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SALES_REPORT_by_Products.h"


@implementation SALES_REPORT_by_Products

@dynamic dl;
@dynamic groupName;
@dynamic id_customer;
@dynamic id_practice;
@dynamic id_product;
@dynamic id_user;
@dynamic m_1val;
@dynamic m_2val;
@dynamic m_3val;
@dynamic m_4val;
@dynamic m_5val;
@dynamic m_6val;
@dynamic m_7val;
@dynamic m_8val;
@dynamic m_9val;
@dynamic m_10val;
@dynamic m_11val;
@dynamic m0val;
@dynamic matunitcur;
@dynamic matunitprv;
@dynamic matunitprv2;
@dynamic matvalcur;
@dynamic matvalprv;
@dynamic matvalprv2;
@dynamic period;
@dynamic pname;
@dynamic tri_period;

- (void) fromJSONObject:(id) object
{
    self.dl         = [object objectForKey:@"DL"] ? [object objectForKey:@"DL"] : @"";
    self.groupName  = [object objectForKey:@"groupName"] ? [object objectForKey:@"groupName"] : @"";
    self.id_customer  = [object objectForKey:@"id_customer"] ? [object objectForKey:@"id_customer"] : @"";
    self.id_practice  = [object objectForKey:@"id_practice"] ? [object objectForKey:@"id_practice"] : @"";
    self.id_product  = [object objectForKey:@"id_product"] ? [object objectForKey:@"id_product"] : @"";
    self.id_user  = [object objectForKey:@"id_user"] ? [object objectForKey:@"id_user"] : @"";
    
    self.m0val  = [object objectForKey:@"m0val"] ? [object objectForKey:@"m0val"] : @"";
    self.m_1val  = [object objectForKey:@"m_1val"] ? [object objectForKey:@"m_1val"] : @"";
    self.m_2val  = [object objectForKey:@"m_2val"] ? [object objectForKey:@"m_2val"] : @"";
    self.m_3val  = [object objectForKey:@"m_3val"] ? [object objectForKey:@"m_3val"] : @"";
    self.m_4val  = [object objectForKey:@"m_4val"] ? [object objectForKey:@"m_4val"] : @"";
    self.m_5val  = [object objectForKey:@"m_5val"] ? [object objectForKey:@"m_5val"] : @"";
    self.m_6val  = [object objectForKey:@"m_6val"] ? [object objectForKey:@"m_6val"] : @"";
    self.m_7val  = [object objectForKey:@"m_7val"] ? [object objectForKey:@"m_7val"] : @"";
    self.m_8val  = [object objectForKey:@"m_8val"] ? [object objectForKey:@"m_8val"] : @"";
    self.m_9val  = [object objectForKey:@"m_9val"] ? [object objectForKey:@"m_9val"] : @"";
    self.m_10val  = [object objectForKey:@"m_10val"] ? [object objectForKey:@"m_10val"] : @"";
    self.m_11val  = [object objectForKey:@"m_11val"] ? [object objectForKey:@"m_11val"] : @"";
    
    self.matunitcur  = [object objectForKey:@"matunitcur"] ? [object objectForKey:@"matunitcur"] : @"";
    self.matunitprv  = [object objectForKey:@"matunitprv"] ? [object objectForKey:@"matunitprv"] : @"";
    self.matunitprv2  = [object objectForKey:@"matunitprv2"] ? [object objectForKey:@"matunitprv2"] : @"";
    self.matvalcur  = [object objectForKey:@"matvalcur"] ? [object objectForKey:@"matvalcur"] : @"";
    self.matvalprv  = [object objectForKey:@"matvalprv"] ? [object objectForKey:@"matvalprv"] : @"";
    self.matvalprv2  = [object objectForKey:@"matvalprv2"] ? [object objectForKey:@"matvalprv2"] : @"";
    
    self.period  = [object objectForKey:@"period"] ? [object objectForKey:@"period"] : @"";
    self.pname  = [object objectForKey:@"pname"] ? [object objectForKey:@"pname"] : @"";
    self.tri_period  = [object objectForKey:@"tri_period"] ? [object objectForKey:@"tri_period"] : @"";
}




@end
