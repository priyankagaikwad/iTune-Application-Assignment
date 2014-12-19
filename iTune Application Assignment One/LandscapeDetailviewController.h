//
//  LandscapeDetailviewController.h
//  iTune Application Assignment One
//
//  Created by synerzip on 17/12/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationData;

@interface LandscapeDetailviewController : UIViewController

@property (nonatomic) NSMutableArray *applicationRecordsForDetailView;
@property (nonatomic) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) ApplicationData * appRecord;
//- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender;
//- (IBAction)swipeRight:(UISwipeGestureRecognizer *)sender;

@end
