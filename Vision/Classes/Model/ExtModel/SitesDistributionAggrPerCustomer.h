//
//  SitesDistributionAggrPerCustomer.h
//  Vision
//
//  Created by Jin on 11/1/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SitesDistributionAggrPerCustomer : NSObject

@property (nonatomic, strong) NSString *id_customer;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, assign) double prvTotal;
@property (nonatomic, strong) NSString *prvTotalString;
@property (nonatomic, assign) double curTotal;
@property (nonatomic, strong) NSString *curTotalString;
@property (nonatomic, strong) NSString *growthString;

- (void)finishAdd;

@end
