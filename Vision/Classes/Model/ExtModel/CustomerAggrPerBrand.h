//
//  CustomerAggrGroupByBrand.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerAggrPerBrand : NSObject

@property (nonatomic, retain) NSString *brand;

@property (nonatomic, assign) double month;
@property (nonatomic, retain) NSString *monthString;
@property (nonatomic, assign) double ytd;
@property (nonatomic, retain) NSString *ytdString;
@property (nonatomic, assign) double mat;
@property (nonatomic, retain) NSString *matString;
@property (nonatomic, assign) double monthprv;
@property (nonatomic, retain) NSString *monthprvString;
@property (nonatomic, assign) double ytdprv;
@property (nonatomic, retain) NSString *ytdprvString;
@property (nonatomic, assign) double matprv;
@property (nonatomic, retain) NSString *matprvString;

@property (nonatomic, retain) NSString *monthpro;
@property (nonatomic, retain) NSString *ytdpro;
@property (nonatomic, retain) NSString *matpro;

- (void)addSalesReport:(NSDictionary *)report;
- (void)finishAdd;

@end
