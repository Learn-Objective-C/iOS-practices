//
//  MarkdownParser.h
//  TextKitMagazine
//
//  Created by Long Vinh Nguyen on 4/13/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkdownParser : NSObject

- (NSAttributedString *)parseMarkdownFile:(NSString *)path;

@end
