//
//  ClientSalesDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class ClientSalesAggr;
@class ClientSalesAggrPerGroup;

@protocol ClientSalesDataSourceDelegate <NSObject>

- (void)groupSelected:(ClientSalesAggrPerGroup *)group;

@end

@interface ClientSalesDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) ClientSalesAggr *clientSalesAggr;
@property (nonatomic, assign) id<ClientSalesDataSourceDelegate> delegate;

@end
