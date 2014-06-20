//
//  Palette.h
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 20/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Palette : NSObject

@property (nonatomic, strong) NSString *paletteId;
@property (nonatomic, strong) NSString *paletteName;
@property (nonatomic, strong) NSArray *colours;

- (id)initWithPaletteId:(NSString *)paletteId completed:(void(^)(void))completed;

- (NSString *)generateUIColorExtension;
- (void)copyToClipboard:(NSString *)string;

@end
