//
//  DetailViewSwipe.h
//  iTune Application Assignment One
//
//  Created by synerzip on 02/12/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationData.h"

@protocol detailViewSwipeProtocol <NSObject>

- (ApplicationData *)newApplicationRecord:(NSIndexPath *) IndexPath;
- (BOOL)isPreviousIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit;
- (BOOL)isNextIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit;
- (NSIndexPath *)nextIndexPath:(NSIndexPath *)currentIndexPath;
- (NSIndexPath *)previousIndexPath:(NSIndexPath *)currentIndexPath;

@end

@interface DetailViewSwipe : NSObject <detailViewSwipeProtocol>

@property (nonatomic,strong) NSMutableArray *applicationRecords;

//- (ApplicationData *)newApplicationRecord:(NSIndexPath *) IndexPath;
//- (NSIndexPath *)previousIndexPath:(NSIndexPath *)currentIndexPath;
//- (NSIndexPath *)nextIndexPath:(NSIndexPath *)currentIndexPath;
//- (BOOL)isNextIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit;
//- (BOOL)isPreviousIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit;
@end
