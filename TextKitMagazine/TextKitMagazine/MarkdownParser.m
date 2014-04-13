//
//  MarkdownParser.m
//  TextKitMagazine
//
//  Created by Long Vinh Nguyen on 4/13/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "MarkdownParser.h"

@implementation MarkdownParser
{
    NSDictionary *_bodyTextAttributes;
    NSDictionary *_headingOneAttributes;
    NSDictionary *_headingTwoAttributes;
    NSDictionary *_headingThreeAttributes;
}

- (id)init
{
    if (self = [super init]) {
        [self createTextAttributes];
    }
    
    return self;
}

- (void)createTextAttributes
{
    //
    UIFontDescriptor *baskerville = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute: @"Baskerville"}];
    UIFontDescriptor *baskervilleBold = [baskerville fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    UIFontDescriptor *bodyFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFont.fontAttributes[UIFontDescriptorSizeAttribute];
    CGFloat bodyFontSizeValue = [bodyFontSize floatValue];
    
    _bodyTextAttributes = [self attributesWithDescriptor:baskerville size:bodyFontSizeValue];
    _headingOneAttributes = [self attributesWithDescriptor:baskervilleBold size:bodyFontSizeValue * 2.0f];
    _headingTwoAttributes = [self attributesWithDescriptor:baskervilleBold size:bodyFontSizeValue * 1.8f];
    _headingThreeAttributes = [self attributesWithDescriptor:baskervilleBold size:bodyFontSizeValue * 1.4f];
}

- (NSDictionary *)attributesWithDescriptor:(UIFontDescriptor *)descriptor size:(CGFloat)bodyFontSize
{
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:bodyFontSize];
    return @{NSFontAttributeName: font};
}

- (NSAttributedString *)parseMarkdownFile:(NSString *)path
{
    NSMutableAttributedString *outputAttributedString = [[NSMutableAttributedString alloc] init];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i < lines.count; i++) {
        NSString *line = lines[i];
        if ([line isEqualToString:@""]) {
            continue;
        }
        
        NSDictionary *attributes = _bodyTextAttributes;
        if ([[line substringToIndex:3] isEqualToString:@"###"]) {
            attributes = _headingOneAttributes;
            line = [line substringFromIndex:3];
        } else  if ([[line substringToIndex:2] isEqualToString:@"##"]) {
            attributes = _headingTwoAttributes;
            line = [line substringFromIndex:2];
        } else if ([[line substringToIndex:1] isEqualToString:@"#"]) {
            attributes = _headingThreeAttributes;
            line = [line substringFromIndex:1];
        }
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:line attributes:attributes];
        [outputAttributedString appendAttributedString:attributedText];
        [outputAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    
    NSString *pattern = @"\\!\\[.*\\]\\((.*)\\)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regex matchesInString:outputAttributedString.string options:0 range:NSMakeRange(0, outputAttributedString.length)];
    
    for (NSTextCheckingResult *result in matches) {
        NSRange matchRange = [result range];
        NSRange captureRange = [result rangeAtIndex:1];
        
        NSTextAttachment *textAttachement = [NSTextAttachment new];
        UIImage *image = [UIImage imageNamed:[outputAttributedString.string substringWithRange:captureRange]];
        textAttachement.image = image;
        NSAttributedString *replacedAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachement];
        [outputAttributedString replaceCharactersInRange:matchRange withAttributedString:replacedAttributedString];
    }
    
    
    return outputAttributedString;
}

@end
