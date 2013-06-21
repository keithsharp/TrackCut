//
//  GPXParser.h
//  trackcut
//
//  Created by Keith Sharp on 18/06/2013.
//
//

#import <Foundation/Foundation.h>

@interface GPXParser : NSObject <NSXMLParserDelegate>

- (BOOL)parseDocumentWithURL:(NSURL *)url;

@end
