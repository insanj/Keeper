//
//  ACSegmentedViewController.m
//  
//
//  Created by Julian Weiss on 7/14/15.
//
//

#import "ACSegmentedViewController.h"

@interface ACSegmentedViewController ()

@property (copy, nonatomic) NSArray *segmentedTitles;

@property (strong, nonatomic) UISegmentedControl *segmentedTitleView;

@end

@implementation ACSegmentedViewController

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        _segmentedTitles = titles;
        _segmentedTitleView = [[UISegmentedControl alloc] initWithItems:_segmentedTitles];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    if ([_segmentedTitles containsObject:title]) {
        _segmentedTitleView.selectedSegmentIndex = [_segmentedTitles indexOfObject:title];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = self.navigationController.view.tintColor;
    
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    navigationBarFrame.origin.x += 50.0;
    navigationBarFrame.size.width -= 100.0;
    navigationBarFrame.origin.y += 5.0;
    navigationBarFrame.size.height -= 10.0;
    
    _segmentedTitleView.frame = navigationBarFrame;
    self.navigationItem.titleView = _segmentedTitleView;
    
    self.tableView.rowHeight = 60.0;
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Accordian.Cell.Default"];
}

@end
