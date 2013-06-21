//
//  GPXParser.m
//  trackcut
//
//  Created by Keith Sharp on 18/06/2013.
//
//

#import "GPXParser.h"
#import "TrackPoint.h"

@interface GPXParser ()
{
    // Booleans to determine which element/attribute we are in when parsing
    BOOL inName;
    BOOL inTime;
    BOOL inEle;
    BOOL inTrk;
    BOOL inTrkPt;

    // Track name and track point we're currently working on
    NSString *trackName;
    TrackPoint *tp;
    
    // Date and time handling
    NSCalendar *cal;
    NSDateFormatter *timeFormatter;
    NSDate *prev;
    
    // Handling output file
    int fileCount;
    NSFileHandle *file;
}
@end

@implementation GPXParser

- (id)init
{
    if (self = [super init]) {
        // Need to set the locale and timezone as GPX files are assumed to be
        // in UTC.  Applications should update to display in the users locale
        // as necessary.
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        
        cal = [NSCalendar currentCalendar];
    }
    return self;
}

- (void)openNextFile
{
    if (file) {
        [file writeData:[@"</gpx>" dataUsingEncoding:NSUTF8StringEncoding]];
        [file closeFile];
        prev = nil;
    }
    NSString *filePath = [[NSString alloc] initWithFormat:@"/tmp/%d.GPX", ++fileCount];
    file = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [file writeData:[@"<?xml version=\"1.0\"?>" dataUsingEncoding:NSUTF8StringEncoding]];
    [file writeData:[@"<gpx version=\"1.1\" creator=\"trackcut by Passback Consulting\">" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)parseDocumentWithURL:(NSURL *)url
{
    if (url == nil) {
        return NO;
    }
    
    [self openNextFile];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:NO];
    
    return [xmlParser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"trk"]) {
        inTrk = YES;
    } else if ([elementName isEqualToString:@"trkpt"]) {
        inTrkPt = YES;
        tp = [[TrackPoint alloc] init];
        [tp setLatitude:[attributeDict objectForKey:@"lat"]];
        [tp setLongitude:[attributeDict objectForKey:@"lon"]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (inEle && inTrkPt) {
        [tp setElevation:string];
    } else if (inTime && inTrkPt) {
        [tp setTime:string];
    } else if (inName && inTrk) {
        trackName = string;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"trk"]) {
        inTrk = NO;
        if (file) {
            [file writeData:[@"</trkseg></trk></gpx>" dataUsingEncoding:NSUTF8StringEncoding]];
            [file closeFile];
        }
    } else if ([elementName isEqualToString:@"trkpt"]) {
        inTrkPt = NO;
        if (!prev) {
            prev = [timeFormatter dateFromString:[tp time]];
        }
        
        NSDateComponents *comps = [cal components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[timeFormatter dateFromString:[tp time]]];
        
        [file writeData:[[tp description] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
