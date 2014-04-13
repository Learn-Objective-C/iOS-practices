//
//  SyntaxHighLightTextStorage.m
//  TextKitNotepad
//
//  Created by Long Vinh Nguyen on 4/11/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "SyntaxHighLightTextStorage.h"

@implementation SyntaxHighLightTextStorage
{
    NSMutableAttributedString *_backingStore;
    NSDictionary *_replacements;
}

- (id)init
{
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
        [self createHighlightPatterns];
    }
    
    return self;
}

- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharacterInRange:%@ withString:%@", NSStringFromRange(range), str);
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing
{
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(extendedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyStylesToRange:extendedRange];
    NSLog(@"performReplacementsForRange changedRange %@", NSStringFromRange(changedRange));
    NSLog(@"performReplacementsForRange extendedRange %@", NSStringFromRange(extendedRange));
}

- (void)applyStylesToRange:(NSRange)searchRange
{
    NSDictionary *normalAttrs = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSUnderlineStyleAttributeName: @0};
    
    // iterate over each replacements
    for (NSString *key in _replacements) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:key options:0 error:nil];
        NSDictionary *attributes = _replacements[key];
        // iterate over each match, making the text bold
        [regex enumerateMatchesInString:_backingStore.string options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange matchRange = result.range;
            [self addAttributes:attributes range:matchRange];
            if ([attributes objectForKey:NSUnderlineStyleAttributeName]) {
                NSURL *url;
                NSString *myURLString = [[self.string substringWithRange:matchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([myURLString hasPrefix:@"http://"]) {
                    url = [NSURL URLWithString:myURLString];
                } else {
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myURLString]];
                }

                [self addAttributes:@{NSLinkAttributeName:url} range:matchRange];
            }
            
            // 4 reset the style to original
            if (NSMaxRange(matchRange) < self.length) {
                [self addAttributes:normalAttrs range:NSMakeRange(NSMaxRange(matchRange), 1)];
            }
        }];
    }
}

- (void)createHighlightPatterns
{
    UIFontDescriptor *scriptFontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute: @"Zapfino"}];
    
    // base on our script font on the preferred body font size
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    UIFont *scriptFont = [UIFont fontWithDescriptor:scriptFontDescriptor size:[bodyFontSize floatValue]];
    
    // create the attributes
    NSDictionary *boldAttributes = [self createAttributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitBold];
    NSDictionary *italicAttributes = [self createAttributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitItalic];
    NSDictionary *strikeThroughAttributes = @{NSStrikethroughStyleAttributeName: @1};
    NSDictionary *scriptAttributes = @{NSFontAttributeName: scriptFont};
    NSDictionary *redTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor]};
    NSDictionary *urlAttributes = @{NSUnderlineStyleAttributeName: @1,
                                    NSForegroundColorAttributeName: [UIColor blueColor]
                                    };
    
    _replacements = @{@"\\*\\w+(\\s\\w+)*\\*)\\s":boldAttributes,
                      @"(_\\w+(\\s\\w+)*_)\\s":italicAttributes,
                      @"([0-9]+\\.)\\s": boldAttributes,
                      @"(-\\w+(\\s\\w+)*-)\\s": strikeThroughAttributes,
                      @"(~\\w+(\\s\\w+)*~)\\s": scriptAttributes,
                      @"\\s[A-Z]{2,}\\s": redTextAttributes,
                      @"((https?:\\/\\/)?[a-zA-Z0-9\\-\\.]+\\.(com|org|net|mil|edu|COM|ORG|NET|MIL|EDU|vn))": urlAttributes,
                      };
}

- (NSDictionary *)createAttributesForFontStyle:(NSString *)style withTrait:(uint32_t)trait
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:style];
    UIFontDescriptor *descriptorWithTrait = [fontDescriptor fontDescriptorWithSymbolicTraits:trait];
    UIFont *font = [UIFont fontWithDescriptor:descriptorWithTrait size:0.0];
    return @{NSFontAttributeName: font};
}

- (void)update
{
    // update the highlight patterns
    [self createHighlightPatterns];
    
    // change the 'global' font
    NSDictionary *bodyFont = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    [self addAttributes:bodyFont range:NSMakeRange(0, self.length)];
    
    // re-apply the regex matches
    [self applyStylesToRange:NSMakeRange(0, self.length)];
}




@end
