//
//  ACSegmentedViewController.h
//  
//
//  Created by Julian Weiss on 7/14/15.
//
//

#import <UIKit/UIKit.h>

@interface ACSegmentedViewController : UITableViewController

/**
 *  Provide the titles for the segmentedControl (which is hosted in the parent navigation controller's UINavigationBar titleView). The @p title of this view controller is used to determine which is selected. If the current view controller's title is nil, no segment will be selected.
*/
- (instancetype)initWithTitles:(NSArray *)titles;

@end
