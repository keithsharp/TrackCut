//
//  main.m
//  trackcut
//
//  Created by Keith Sharp on 18/06/2013.
//
//

#import <Foundation/Foundation.h>
#import "GPXParser.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Should read this from argv
        NSString *filepath = @"/tmp/SUW.GPX";
        NSURL *file = [[NSURL alloc] initFileURLWithPath:filepath];
        
        GPXParser *gpxParser = [[GPXParser alloc] init];
        if (![gpxParser parseDocumentWithURL:file]) {
            return 1;
        }
        
    }
    return 0;
}

