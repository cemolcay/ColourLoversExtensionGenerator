//
//  Palette.m
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 20/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "Palette.h"
#import "Colour.h"

#include "unistd.h"
#include "netdb.h"

@implementation Palette

- (id)initWithPaletteId:(NSString *)paletteId completed:(void (^)(void))completed{
    if ((self = [super init])) {
        self.paletteId = paletteId;
        __weak typeof(self) weakSelf = self;
        [self json:[NSString stringWithFormat:@"http://www.colourlovers.com/api/palette/%@?format=json", paletteId] success:^(id object) {
           weakSelf.paletteName = [[object firstObject] objectForKey:@"title"];
            
            NSArray *hexes = [[object firstObject] objectForKey:@"colors"];
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSString *s in hexes) {
                [temp addObject:[[Colour alloc] initWithHexWithoutHashtag:s]];
            }
            weakSelf.colours = [[NSArray alloc] initWithArray:[temp mutableCopy]];
            
            completed ();
        } error:^(NSError *error) {
            NSLog(@"palette error");
        }];
    }
    return self;
}

- (NSString *)generateClass:(ExtensionClass)t andLanguage:(Language)lang {
    if (t == ExtensionClassUIColor) {
        if (lang == LanguageObjectiveC)
            return [self generateObjcUIColor];
        else if (lang == LanguageSwift)
            return [self generateSwiftUIColor];
        
        else return @"error";
    }
    else if (t == ExtensionClassNSColor) {
        if (lang == LanguageObjectiveC)
            return [self generateObjcNSColor];
        else if (lang == LanguageSwift)
            return [self generateSwiftNSColor];
        
        else return @"error";
    }
    else return @"error";
}


#pragma mark - Generators

#pragma mark ObjC
- (NSString *)generateObjcUIColor {
    NSString *interface = [NSString stringWithFormat:@"\n@interface UIColor (%@)", [self.paletteName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSString *implementation = [NSString stringWithFormat:@"@implementation UIColor (%@)", [self.paletteName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSString *h = @"";
    NSString *m = @"";
    
    for (int i = 0; i < self.colours.count; i++) {
        Colour *c = [self.colours objectAtIndex:i];
        NSString *name = c.name?c.name:[NSString stringWithFormat:@"color%d", i];
        
        NSString *hline = [NSString stringWithFormat:@"+ (UIColor *)%@;\n", name];
        NSString *mline = [NSString stringWithFormat:@"+ (UIColor *)%@ {\n\treturn [self colorWithRed:%1.f/255.0 green:%1.f/255.0 blue:%1.f/255.0 alpha:1];\n}\n\n", name, c.r, c.g, c.b];
        
        h = [h stringByAppendingString:hline];
        m = [m stringByAppendingString:mline];
    }
    
    NSString *extension = [NSString stringWithFormat:@"%@\n%@\n@end\n\n%@\n%@\n@end", interface, h, implementation, m];
    
    return extension;
}

- (NSString *)generateObjcNSColor {
    NSString *interface = [NSString stringWithFormat:@"\n@interface NSColor (%@)", [self.paletteName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSString *implementation = [NSString stringWithFormat:@"@implementation NSColor (%@)", [self.paletteName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSString *h = @"";
    NSString *m = @"";
    
    for (int i = 0; i < self.colours.count; i++) {
        Colour *c = [self.colours objectAtIndex:i];
        NSString *name = c.name?c.name:[NSString stringWithFormat:@"color%d", i];
        
        NSString *hline = [NSString stringWithFormat:@"+ (NSColor *)%@;\n", name];
        NSString *mline = [NSString stringWithFormat:@"+ (NSColor *)%@ {\n\treturn [self colorWithRed:%1.f/255.0 green:%1.f/255.0 blue:%1.f/255.0 alpha:1];\n}\n\n", name, c.r, c.g, c.b];
        
        h = [h stringByAppendingString:hline];
        m = [m stringByAppendingString:mline];
    }
    
    NSString *extension = [NSString stringWithFormat:@"%@\n%@\n@end\n\n%@\n%@\n@end", interface, h, implementation, m];
    
    return extension;
}

#pragma mark Swift
- (NSString *)generateSwiftUIColor {
    NSString *start = @"\nextension UIColor {\n";
    NSString *ext = @"";
    NSString *end = @"\n}";
    
    for (int i = 0; i < self.colours.count; i++) {
        Colour *c = [self.colours objectAtIndex:i];
        NSString *name = c.name?c.name:[NSString stringWithFormat:@"color%d", i];
        NSString *func = [NSString stringWithFormat:@"\tclass func %@ () -> UIColor! { \n\n\t\treturn UIColor (red:%1.f/255.0, green:%1.f/255.0, blue:%1.f/255.0, alpha:1)\n\t}\n", name, c.r, c.g, c.b];
        
        ext = [ext stringByAppendingString:func];
    }
    
    NSString *extension = [NSString stringWithFormat:@"%@%@%@", start, ext, end];
    return extension;
}

- (NSString *)generateSwiftNSColor {
    NSString *start = @"\nextension NSColor {\n";
    NSString *ext = @"";
    NSString *end = @"\n}";
    
    for (int i = 0; i < self.colours.count; i++) {
        Colour *c = [self.colours objectAtIndex:i];
        NSString *name = c.name?c.name:[NSString stringWithFormat:@"color%d", i];
        NSString *func = [NSString stringWithFormat:@"\tclass func %@ () -> NSColor! { \n\t\treturn NSColor (red:%1.f/255.0, green:%1.f/255.0, blue:%1.f/255.0, alpha:1)\n\t}\n\n", name, c.r, c.g, c.b];
        
        ext = [ext stringByAppendingString:func];
    }
    
    NSString *extension = [NSString stringWithFormat:@"%@%@%@", start, ext, end];
    return extension;
}


#pragma mark - Utils

- (void)json:(NSString *)url success:(void(^)(id))success error:(void(^)(NSError*))error {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError)
            error (connectionError);
        
        NSError *jsonError;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError)
            error (jsonError);
        
        success (result);
    }];
}

- (BOOL)isNetworkAvailable {
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        NSLog(@"-> connection established!\n");
        return YES;
    }
}

@end
