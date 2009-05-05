/*
 * Author: Edward Patel, Memention AB
 *
 * Compile with:  gcc -o tagimg tagimg.m -framework Cocoa
 *
 */

#import <Cocoa/Cocoa.h>

int main (int argc, const char * argv[]) {
    [NSApplication sharedApplication];
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if (argc == 3) {
        
        NSString *filename = [NSString stringWithFormat:@"%s", argv[1]];
        NSString *extension = [filename pathExtension]; 
        
        if ([extension caseInsensitiveCompare:@"png"] != NSOrderedSame) {           
            printf("Image file should be a .png file\n");
            return -1;
        }
        
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:filename];
        
        if (image) {
            
            [image lockFocus];
            
            NSString *string = [NSString stringWithFormat:@"%@\n%s", [NSDate date], argv[2]];
            NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
            
            shadow.shadowColor = [NSColor blackColor];
            shadow.shadowBlurRadius = 2.0;
            shadow.shadowOffset = NSMakeSize(2,-2);
            
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            [attributes setObject:[NSColor whiteColor]
                           forKey:NSForegroundColorAttributeName];
            [attributes setObject:[NSFont fontWithName:@"Andale Mono" size:14] 
                           forKey:NSFontAttributeName];
            [attributes setObject:shadow
                           forKey:NSShadowAttributeName];
            
            [string drawAtPoint:NSMakePoint(10, 10) withAttributes:attributes];
            
            [image unlockFocus];
            
            NSBitmapImageRep *bits = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
            
            NSData *data = [bits representationUsingType:NSPNGFileType 
                                              properties:nil];
            
            [data writeToFile:filename atomically:YES];
            
        } else {
            
            printf("Could not open file '%s'\n", argv[1]);
            return -1;
            
        }
        
    } else {
        
        printf("Usage: tagimg <filename.png> <text>\n");
        return -1;
        
    }
    
    [pool drain];
    
    return 0;
}
