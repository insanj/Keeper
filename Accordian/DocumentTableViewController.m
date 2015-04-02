//
//  DocumentTableViewController.m
//  Accordian
//
//  Created by Julian Weiss on 2/19/15.
//  Copyright (c) 2015 insanj. All rights reserved.
//

#import "DocumentTableViewController.h"
#import "Document.h"
#import "DocumentCreateViewController.h"

@implementation DocumentTableViewController

- (instancetype)init {
	self = [super initWithStyle:UITableViewStylePlain];
	
	if (self) {
		self.currentDocuments = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Documents";
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusButtonTapped:)];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSArray *savedDocuments = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Accordian.Documents"];
	if (savedDocuments) {
		for (NSDictionary *dictionaryRepresentation in savedDocuments) {
			Document *document = [[Document alloc] init];
			[document setValuesFromDictionaryRespresentation:dictionaryRepresentation];
			[self.currentDocuments addObject:document];
		}
		
		[self.tableView reloadData];
	}
	
	else if (!savedDocuments) {
		[[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"Accordian.Documents"];
	}
	
	self.navigationItem.leftBarButtonItem.enabled = self.currentDocuments.count > 0;
}

#pragma mark - actions

- (void)plusButtonTapped:(UIBarButtonItem *)sender {
	DocumentCreateViewController *createViewController = [[DocumentCreateViewController alloc] init];
	UINavigationController *modalViewController = [[UINavigationController alloc] initWithRootViewController:createViewController];
	[self presentViewController:modalViewController animated:YES completion:NULL];
	
	// [self.navigationController pushViewController:createViewController animated:YES];
	
	/*UIAlertView *createDocumentAlert = [[UIAlertView alloc] initWithTitle:@"New Document" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	createDocumentAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[createDocumentAlert show];*/
}

- (void)editButtonTapped:(UIBarButtonItem *)sender {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
	
	[self.tableView setEditing:YES animated:YES];
	
	[self.tableView beginUpdates];
	[self.tableView endUpdates];
}

- (void)doneButtonTapped:(UIBarButtonItem *)sender {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];

	[self.tableView setEditing:NO animated:YES];

	[self.tableView beginUpdates];
	[self.tableView endUpdates];
}

#pragma mark alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != [alertView cancelButtonIndex]) {
		Document *createdDocument = [[Document alloc] init];
		createdDocument.createdDate = [NSDate date];
		createdDocument.content = [alertView textFieldAtIndex:0].text;
		[self.currentDocuments addObject:createdDocument];
		
		NSArray *savedDocuments = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Accordian.Documents"];
		[[NSUserDefaults standardUserDefaults] setObject:[savedDocuments arrayByAddingObject:[createdDocument dictionaryRepresentationOfDocument]] forKey:@"Accordian.Documents"];

		self.navigationItem.leftBarButtonItem.enabled = YES;

		[self.tableView reloadData];
	}
}

#pragma mark - table view
#pragma mark data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return fmax(self.currentDocuments.count, 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.currentDocuments.count > 0) {
		Document *rowDocument = self.currentDocuments[indexPath.row];
		CGFloat boundingWidth = tableView.isEditing ? tableView.frame.size.width - 55.0 :  tableView.frame.size.width - 15.0;
		CGSize sizeOfDocumentContent = [rowDocument.content boundingRectWithSize:CGSizeMake(boundingWidth, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0]} context:nil].size;
		CGSize sizeOfDateContent = [rowDocument.createdDate.description boundingRectWithSize:CGSizeMake(boundingWidth, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;
		return 40.0 + sizeOfDocumentContent.height + sizeOfDateContent.height;
	}
	
	return self.tableView.frame.size.height - 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.currentDocuments.count > 0) {
		UITableViewCell *documentCell = [tableView dequeueReusableCellWithIdentifier:@"Document"];
		
		if (!documentCell) {
			documentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Document"];
			documentCell.textLabel.font = [UIFont systemFontOfSize:18.0];
			documentCell.textLabel.numberOfLines = 0;
			
			documentCell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
			documentCell.detailTextLabel.textColor = [UIColor darkGrayColor];
			documentCell.detailTextLabel.numberOfLines = 0;
		}
		
		Document *document = (Document *)self.currentDocuments[indexPath.row];
		
		documentCell.textLabel.text = document.content;
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateStyle = NSDateFormatterShortStyle;
		dateFormatter.timeStyle = NSDateFormatterShortStyle;
		
		documentCell.detailTextLabel.text = [dateFormatter stringFromDate:document.createdDate];
		
		return documentCell;
	}
	
	else {
		UITableViewCell *nothingHereCell = [tableView dequeueReusableCellWithIdentifier:@"Nothing"];
		
		if (!nothingHereCell) {
			nothingHereCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Nothing"];
			nothingHereCell.textLabel.textColor = [UIColor darkGrayColor];
			nothingHereCell.textLabel.numberOfLines = 2;
			nothingHereCell.textLabel.textAlignment = NSTextAlignmentCenter;
			nothingHereCell.userInteractionEnabled = NO;
		}
		
		nothingHereCell.textLabel.text = @"No Documents Yet\nTap Plus to Create One";
		return nothingHereCell;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.currentDocuments.count > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[tableView beginUpdates];

		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[self.currentDocuments removeObjectAtIndex:indexPath.row];

		if (self.currentDocuments.count == 0) {
			[tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self doneButtonTapped:self.navigationItem.leftBarButtonItem];
			self.navigationItem.leftBarButtonItem.enabled = NO;
		}
		
		[tableView endUpdates];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Document *document = self.currentDocuments[indexPath.row];
	UIAlertView *documentAlert = [[UIAlertView alloc] initWithTitle:@"Document" message:document.content delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[documentAlert show];
}

@end
