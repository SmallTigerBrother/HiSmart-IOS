//
//  HIRHttpRequest.m
//  Utility
//
//  Created by Steve Jobs on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HIRHttpRequest.h"
#import "Reachability.h"

@implementation NSString (URLEncode)

////如果这个不能用，就用原来的
- (NSString *)URLEncodeString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("\" <>!$&'()*+,-./:;=?@_~%#[]"), kCFStringEncodingUTF8));
	
    return result;
}


@end


@implementation HIRHttpRequest

@synthesize requestDelegate;
@synthesize resultData;
@synthesize requestReponse;
@synthesize connection;


- (id)initWithDelegate:(id)delegate{
	if(self = [super init]){
		self.requestDelegate = delegate;
		return self;
	}
	return NULL;
}

- (void)dealloc{
    [connection cancel];
    self.connection = nil;
    self.requestDelegate = nil;
    self.resultData = nil;
    self.requestReponse = nil;
}

- (void)cancel{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[connection cancel];
}

- (BOOL)requestGet:(NSString *)url{
	if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
		[requestDelegate requestFailed:self response:requestReponse error:nil];
		return FALSE;
	}
	self.resultData = [NSMutableData data];
    
    NSString *theUrl = url;
    
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:theUrl]];
	self.connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	return TRUE;
}



- (BOOL)requestPost:(NSString *)url Parameters:(NSDictionary *)parameters{
   	if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
		[requestDelegate requestFailed:self response:requestReponse error:nil];
		return FALSE;
	}
    NSString *theUrl = url;
	self.resultData = [NSMutableData data];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:theUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                       timeoutInterval:60.0]; 
    [request setHTTPMethod:@"POST"]; 
	NSMutableString *bodyStr = [NSMutableString string];
	
	NSMutableDictionary *newParamaters = [NSMutableDictionary dictionaryWithDictionary:parameters];
	NSArray *keys = [newParamaters allKeys];
	long len = [keys count];
	for (int i = 0; i < len; i++){
		NSString *key = [keys objectAtIndex:i];
		id value = [newParamaters valueForKey:key];
        if ([key isKindOfClass:[NSString class]]) {
            key = [key URLEncodeString];
        }
		if ([value isKindOfClass:[NSString class]]) {
            value = [value URLEncodeString];
		}
		[bodyStr appendFormat:@"%@=%@", key, value];
		if(i != len -1){
            [bodyStr appendString:@"&"];
		}
	}
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	return TRUE;
}

- (BOOL)requestPost:(NSString *)url bodyData:(NSData *)data
{
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        [requestDelegate requestFailed:self response:requestReponse error:nil];
        return FALSE;
    }
    
    NSString *theUrl = url;
    
    self.resultData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:theUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return TRUE;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
	[resultData resetBytesInRange:NSMakeRange(0, [resultData length])];
	self.requestReponse = response;
	return request;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	self.requestReponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[resultData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:nil];
	[requestDelegate requestSucceed:self response:requestReponse result:resultJSON];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[requestDelegate requestFailed:self response:requestReponse error:error];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


+ (BOOL)sendAsynchronousRequest:(NSURLRequest*) request queue:(NSOperationQueue*) queue completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))handle {
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        return FALSE;
    }
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handle];
    return YES;
}







@end
