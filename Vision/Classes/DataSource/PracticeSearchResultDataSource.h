//
//  PracticeSearchResultDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@interface PracticeSearchResultDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSArray *searchResult;

- (id)initWithResults:(NSArray *)resultArray;

@end
