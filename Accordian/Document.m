//
//  Document.m
//  Accordian
//
//  Created by Julian Weiss on 2/19/15.
//  Copyright (c) 2015 insanj. All rights reserved.
//

#import "Document.h"

@implementation Document

- (NSDictionary *)dictionaryRepresentationOfDocument {
	return @{@"date" : self.createdDate, @"content" : self.content};
}

- (void)setValuesFromDictionaryRespresentation:(NSDictionary *)dictionary {
	self.createdDate = dictionary[@"date"] ?: self.createdDate;
	self.content = dictionary[@"content"] ?: self.content;
}

@end
