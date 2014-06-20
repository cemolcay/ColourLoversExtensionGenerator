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


- (NSString *)generateUIColorExtension {
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

- (void)copyToClipboard:(NSString *)string {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:self];
    [pb setString:string forType:NSStringPboardType];
}


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
