//
//  ViewController.h
//  iTune Application Assignment One
//
//  Created by Yogesh Bharate on 25/09/14.
//  Copyright (c) 2014 Synerzip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "ApplicationData.h"

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *dataLoadingIndicator;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, strong) NSMutableDictionary *dictForStroingAppImageURLsAndPaths;
@property (nonatomic) NSMutableArray *applicationRecords;

@end