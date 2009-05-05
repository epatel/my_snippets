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

        NSImage *image = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%s", argv[1]]];

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

            [data writeToFile:[NSString stringWithFormat:@"%s", argv[1]]
                atomically:YES];

        } else {
            
            printf("Could not open file '%s'\n", argv[1]);
            
        }
        
    } else {
        
        printf("Usage: tagimg <filename> <text>\n");
        
    }

    [pool drain];

    return 0;
}
