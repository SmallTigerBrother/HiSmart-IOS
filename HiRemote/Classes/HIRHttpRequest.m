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

+(void)sendAsynchronousRequestWithParaDic:(NSDictionary *)paraDic api:(NSString *)api
                        hirRequestSuccess:(HirRequestSuccess)hirRequestSuccess
                           hirRequestErro:(HirRequestErro)hirRequestErro
                    hirRequestConnectFail:(HirRequestConnectFail)hirRequestConnectFail
{
    if (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        if (hirRequestConnectFail) {
            hirRequestConnectFail();
        }
        else{
            [SGInfoAlert showInfo:@"Connect network fail"];
        }
    }
    else{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:10];
        
        NSString *currentLanguage = nil;
        NSArray *languages = [NSLocale preferredLanguages];
        if ([languages count] > 0) {
            currentLanguage = [languages objectAtIndex:0];
        }else {
            currentLanguage = @"en";
        }
        [request addValue:currentLanguage forHTTPHeaderField:@"Accept-Language"];
        [request setHTTPMethod:@"POST"];
        
        NSMutableString *dataStr = [NSMutableString string];
        NSArray *keys = [paraDic allKeys];
        for (int i = 0; i< [keys count]; i++) {
            NSString *key = [keys objectAtIndex:i];
            [dataStr appendFormat:@"%@=%@",key,[paraDic valueForKey:key]];
            if (i+1 < [keys count]) {
                [dataStr appendString:@"&"];
            }
        }
        
        [request setHTTPBody:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                
                NSError *erro;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&erro];
                if ([result count] > 0) {
                    long code = [[result valueForKey:@"code"] integerValue];
                    if (code == 0) {//成功
                        NSDictionary *infoDic = [result valueForKey:@"data"];
                        if (infoDic) {
                            NSLog(@"sosododododooddooddo:%@",infoDic);
                            hirRequestSuccess(infoDic);
                        }
                        else{
                            NSLog(@"result data infoDic: %@\n api:%@",infoDic,api);
                            if (hirRequestErro) {
                                hirRequestErro(connectionError);
                            }
                        }
                    }else {
                        NSError *erro = [NSError errorWithDomain:api code:code userInfo:nil];
                        NSLog(@"erroCode: %@",erro);
                        if (hirRequestErro) {
                            hirRequestErro(connectionError);
                        }
                    }
                }
                else{
                    NSError *erro = [NSError errorWithDomain:api code:-1 userInfo:nil];
                    NSLog(@"result empty: %@",erro);
                    if (hirRequestErro) {
                        hirRequestErro(connectionError);
                    }
                }
            }
            else{
                NSLog(@"connectionError: %@",connectionError);
                if (hirRequestErro) {
                    hirRequestErro(connectionError);
                }
            }
        }];
    }
}

@end
