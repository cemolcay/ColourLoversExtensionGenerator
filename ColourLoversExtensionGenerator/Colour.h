//
//  Colour.h
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 20/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colour : NSObject

@property (nonatomic) NSColor *color;

@property (nonatomic) NSString *hexWithHashtag;
@property (nonatomic) NSString *hexWithoutHashtag;

@property (assign) CGFloat r;
@property (assign) CGFloat g;
@property (assign) CGFloat b;

@property (nonatomic) NSString *name;

- (id)initWithHexWithoutHashtag:(NSString *)hex;

@end
