//
//  Product.m
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Product.h"


@implementation Product

@dynamic pcode;
@dynamic pname;
@dynamic pclass;
@dynamic brand;
@dynamic size;
@dynamic group1;
@dynamic group2;
@dynamic group3;
@dynamic group4;
@dynamic group5;
@dynamic group6;
@dynamic type;
@dynamic datecrea;
@dynamic status;
- (void) fromJSONObject:(id) object
{
    self.brand = [object objectForKey:@"BRAND"] ? [object objectForKey:@"BRAND"] : @"";
    self.pclass = [object objectForKey:@"CLASS"] ? [object objectForKey:@"CLASS"] : @"";
    self.group1 = [object objectForKey:@"GROUP1"] ? [object objectForKey:@"GROUP1"] : @"";
    self.group2 = [object objectForKey:@"GROUP2"] ? [object objectForKey:@"GROUP2"] : @"";
    self.group3 = [object objectForKey:@"GROUP3"] ? [object objectForKey:@"GROUP3"] : @"";
    self.group4 = [object objectForKey:@"GROUP4"] ? [object objectForKey:@"GROUP4"] : @"";
    self.group5 = [object objectForKey:@"GROUP5"] ? [object objectForKey:@"GROUP5"] : @"";
    self.group6 = [object objectForKey:@"GROUP6"] ? [object objectForKey:@"GROUP6"] : @"";
    self.pcode = [object objectForKey:@"PCODE"] ? [object objectForKey:@"PCODE"] : @"";
    self.pname = [object objectForKey:@"PNAME"] ? [object objectForKey:@"PNAME"] : @"";
    self.size = [object objectForKey:@"SIZE"] ? [object objectForKey:@"SIZE"] : @"";
    self.type = [object objectForKey:@"Type"] ? [object objectForKey:@"Type"] : @"";
    self.status = [NSNumber numberWithBool:([object objectForKey:@"status"] ? [[object objectForKey:@"status"] boolValue] : false)];
    
    if ([object objectForKey:@"Datecrea"])
    {
        NSString *input = [object objectForKey:@"Datecrea"];
        
        int loc = -1;
        if ([input rangeOfString:@"+"].length > 0)
        {
            loc = [input rangeOfString:@"+"].location;
        }
        else if  ([input rangeOfString:@"-"].length > 0)
        {
            loc = [input rangeOfString:@"-"].location;
        }
        
        if (loc > 0)
        {
            NSString *newStr = [NSString stringWithFormat:@"%@GMT%@", [input substringToIndex:loc], [input substringFromIndex:loc]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
            self.datecrea = [formatter dateFromString:newStr];
        }
        else {
            self.datecrea = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
        }
    }
    else {
        self.datecrea = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    }
    
    
}

@end
