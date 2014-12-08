//
//  DetailViewSwipe.h
//  iTune Application Assignment One
//
//  Created by synerzip on 02/12/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationData.h"

@interface DetailViewSwipe : UIViewController

@property (nonatomic,strong) NSMutableArray *applicationRecordsForDetailView;

- (ApplicationData *)newApplicationRecord:(NSIndexPath *) IndexPath;
- (NSIndexPath *)previousIndexPath:(NSIndexPath *)currentIndexPath;
- (NSIndexPath *)nextIndexPath:(NSIndexPath *)currentIndexPath;
- (BOOL)isNextIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit;
- (BOOL)isPreviousIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit;
@end
