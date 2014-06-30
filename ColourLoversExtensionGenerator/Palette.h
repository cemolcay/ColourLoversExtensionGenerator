//
//  Palette.h
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 20/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Language) {
    LanguageObjectiveC,
    LanguageSwift,
};

typedef NS_ENUM(NSUInteger, ExtensionClass) {
    ExtensionClassUIColor,
    ExtensionClassNSColor,
    ExtensionClassCCColor,
};

@interface Palette : NSObject

@property (nonatomic, strong) NSString *paletteId;
@property (nonatomic, strong) NSString *paletteName;
@property (nonatomic, strong) NSArray *colours;

- (id)initWithPaletteId:(NSString *)paletteId completed:(void(^)(void))completed;
- (NSString *)generateClass:(ExtensionClass)t andLanguage:(Language)lang;

@end
