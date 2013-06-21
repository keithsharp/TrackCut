//
//  TrackPoint.m
//  trackcut
//
//  Created by Keith Sharp on 18/06/2013.
//
//

#import "TrackPoint.h"

@implementation TrackPoint

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize elevation = _elevation;
@synthesize time = _time;

- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"<trkpt lat=\"%@>\" lon=\"%@\"><ele>%@</ele><time>%@></time></trkpt>", self.latitude, self.longitude, self.elevation, self.time];
}

@end
