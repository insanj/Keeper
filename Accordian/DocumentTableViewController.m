//
//  DocumentTableViewController.m
//  Accordian
//
//  Created by Julian Weiss on 2/19/15.
//  Copyright (c) 2015 insanj. All rights reserved.
//

#import "DocumentTableViewController.h"
#import "Document.h"

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
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusButtonTapped:)];
	
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
}

#pragma mark - actions

- (void)plusButtonTapped:(UIBarButtonItem *)sender {
	UIAlertView *createDocumentAlert = [[UIAlertView alloc] initWithTitle:@"New Document" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	createDocumentAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[createDocumentAlert show];
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
		CGSize sizeOfDocumentContent = [rowDocument.content boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 15.0, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0]} context:nil].size;
		CGSize sizeOfDateContent = [rowDocument.createdDate.description boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 15.0, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;
		return 20.0 + sizeOfDocumentContent.height + sizeOfDateContent.height;
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
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		
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
			nothingHereCell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		nothingHereCell.textLabel.text = @"No Documents Yet\nTap Plus to Create One";
		return nothingHereCell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Document *document = self.currentDocuments[indexPath.row];
	UIAlertView *documentAlert = [[UIAlertView alloc] initWithTitle:@"Document" message:document.content delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[documentAlert show];

}

@end
