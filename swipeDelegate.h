//
//  swipeDelegate.h
//  iTune Application Assignment One
//
//  Created by synerzip on 11/12/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#ifndef iTune_Application_Assignment_One_swipeDelegate_h
#define iTune_Application_Assignment_One_swipeDelegate_h

@protocol detailViewSwipeProtocol <NSObject>

- (ApplicationData *)newApplicationRecord:(NSIndexPath *) IndexPath
{
    NSIndexPath * nextIndexPath = [NSIndexPath  indexPathForRow:IndexPath.row+1 inSection:0];
    DetailViewController *detailVC;
    ApplicationData *appObject = self.applicationRecords[nextIndexPath.row];
    detailVC.currentIndexPath = nextIndexPath;
    return appObject;
}

- (NSIndexPath *)nextIndexPath:(NSIndexPath *)currentIndexPath
{
    return [NSIndexPath  indexPathForRow:currentIndexPath.row+1 inSection:0];
}

- (NSIndexPath *)previousIndexPath:(NSIndexPath *)currentIndexPath
{
    return [NSIndexPath  indexPathForRow:currentIndexPath.row-1 inSection:0];
    
}

- (BOOL)isNextIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit
{
    if (currentIndexPath.row < limit)
    {
        return true;
    }
    return false;
}

- (BOOL)isPreviousIndexPath:(NSIndexPath *)currentIndexPath maxLimit:(NSUInteger )limit
{
    if (currentIndexPath.row >= 0)
    {
        return true;
    }
    return false;
}

@end

#endif
