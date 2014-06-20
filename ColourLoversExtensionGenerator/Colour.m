//
//  Colour.m
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 20/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "Colour.h"

@implementation Colour

- (id)initWithHexWithoutHashtag:(NSString *)hex {
    if ((self = [super init])) {
        self.hexWithoutHashtag = hex;
        self.hexWithHashtag = [@"#" stringByAppendingString:hex];
        
        const char *cStr = [self.hexWithHashtag cStringUsingEncoding:NSASCIIStringEncoding];
        long col = strtol(cStr+1, NULL, 16);
        
        self.b = (CGFloat) (col & 0xFF);
        self.g = (CGFloat) ((col >> 8) & 0xFF);
        self.r = (CGFloat) ((col >> 16) & 0xFF);
        
        self.color = [NSColor colorWithRed:self.r/255.0 green:self.g/255.0f blue:self.b/255.0f alpha:1];
    }
    return self;
}

@end
