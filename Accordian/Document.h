//
//  Document.h
//  Accordian
//
//  Created by Julian Weiss on 2/19/15.
//  Copyright (c) 2015 insanj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSDate *createdDate;

- (NSDictionary *)dictionaryRepresentationOfDocument;

- (void)setValuesFromDictionaryRespresentation:(NSDictionary *)dictionary;

@end
