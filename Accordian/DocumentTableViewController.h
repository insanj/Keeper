//
//  DocumentTableViewController.h
//  Accordian
//
//  Created by Julian Weiss on 2/19/15.
//  Copyright (c) 2015 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *currentDocuments;

@end
