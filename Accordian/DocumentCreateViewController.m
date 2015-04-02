//
//  DocumentCreateViewController.m
//  Accordian
//
//  Created by Julian Weiss on 4/2/15.
//  Copyright (c) 2015 insanj. All rights reserved.
//

#import "DocumentCreateViewController.h"
#import "Document.h"

@interface DocumentCreateViewController () <UITextViewDelegate>

@property (strong, nonatomic) Document *document;

@end

@implementation DocumentCreateViewController

- (instancetype)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	if (self) {
		_document = [Document new];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];

	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.title = @"New Document";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!_document.content) {
		return 50.0;
	}
	
	else {
		CGSize contentSize = [_document.content sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}];
		return fmax(contentSize.height, 50.0);
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Create"];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Create"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UITextView *documentTextView = [UITextView new];
		documentTextView.delegate = self;
		documentTextView.editable = YES;
		documentTextView.scrollEnabled = NO;
		documentTextView.tag = 123;
		documentTextView.translatesAutoresizingMaskIntoConstraints = NO;
		documentTextView.font = [UIFont systemFontOfSize:14.0];
		documentTextView.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:documentTextView];
		
		NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:documentTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:5];
		NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:documentTextView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:5];
		NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:documentTextView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
		NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:documentTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5];
		[cell.contentView addConstraints:@[topConstraint, leftConstraint, rightConstraint, bottomConstraint]];
	}
	
	UITextView *documentTextView = (UITextView *)[cell.contentView viewWithTag:123];
	documentTextView.text = _document.content;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	UITextView *documentTextView = (UITextView *)[cell.contentView viewWithTag:123];
	[documentTextView becomeFirstResponder];
}

#pragma mark - text view

- (void)textViewDidChange:(UITextView *)textView {
	CGSize contentSize = [textView.text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]}];
	UITableViewCell *documentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	
	if (documentCell.frame.size.height < contentSize.height) {
		[self.tableView beginUpdates];
		[self.tableView endUpdates];
	}
	
	_document.content = textView.text;
}

#pragma mark - actions

- (void)cancelButtonTapped:(UIBarButtonItem *)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doneButtonTapped:(UIBarButtonItem *)sender {
	_document.createdDate = [NSDate date];
	
	NSArray *savedDocuments = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Accordian.Documents"];
	[[NSUserDefaults standardUserDefaults] setObject:[savedDocuments arrayByAddingObject:[_document dictionaryRepresentationOfDocument]] forKey:@"Accordian.Documents"];
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
