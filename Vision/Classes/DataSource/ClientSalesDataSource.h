//
//  ClientSalesDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class ClientSalesAggr;

@interface ClientSalesDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) ClientSalesAggr *clientSalesAggr;

@end
