//
//  DetailViewSwipe.m
//  iTune Application Assignment One
//
//  Created by synerzip on 02/12/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import "DetailViewSwipe.h"
#import "ApplicationData.h"
#import "DetailViewController.h"
@implementation DetailViewSwipe

- (ApplicationData *)newApplicationRecord:(NSIndexPath *) IndexPath
{
    NSIndexPath * nextIndexPath = [NSIndexPath  indexPathForRow:IndexPath.row+1 inSection:0];
    DetailViewController *detailVC;
    ApplicationData *appObject = self.applicationRecordsForDetailView[nextIndexPath.row];
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
