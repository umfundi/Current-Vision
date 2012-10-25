//
//  AllGroupsDataSource.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@interface AllGroupsDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSArray *groupArray;

@end
