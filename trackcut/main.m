//
//  main.m
//  trackcut
//
//  Created by Keith Sharp on 18/06/2013.
//
//

#import <Foundation/Foundation.h>
#import "GPXParser.h"

void printHelp()
{
    fprintf(stderr, "Usage: trackcut -file <GPX File> [-out <dir for output>] [-cut date|seg]\n");
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        
		// GPX file to parse
        NSString *filePath = [args stringForKey:@"file"];
        if (!filePath || [filePath length] == 0) {
            printHelp();
            return 1;
        }
        
		// Directory to use for output
        NSString *outPath = [args stringForKey:@"out"];
        
        
		// Not actually implemented yet
		// Cut track by date (new file for each day) or by <trkseg>
        NSString *cutBy = [args stringForKey:@"cut"];
        if (!cutBy) {
            cutBy = @"date";
        } else if (![cutBy isEqualToString:@"date"] || ![cutBy isEqualToString:@"seg"]) {
            printHelp();
            return 1;
        }
        
        NSURL *file = [[NSURL alloc] initFileURLWithPath:filePath];
        
        GPXParser *gpxParser = [[GPXParser alloc] init];
		if (outPath) {
            gpxParser.outputDirectory = outPath;
        }
        if (![gpxParser parseDocumentWithURL:file]) {
            fprintf(stderr, "Failed to parse file\n");
            return 1;
        }
        
    }
    return 0;
}

