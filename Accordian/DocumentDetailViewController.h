//
//  DocumentDetailViewController.h
//  Accordian
//
//  Created by Julian Weiss on 4/2/15.
//  Copyright (c) 2015 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Document;

@interface DocumentDetailViewController : UITableViewController

- (instancetype)initWithDocument:(Document *)document;

@end
