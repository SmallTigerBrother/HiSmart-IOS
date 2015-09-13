//
//  HIRHttpRequest.h
//  Utility
//
//  Created by Steve Jobs on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HirRequestSuccess)(id result);
typedef void (^HirRequestErro)(NSError *erro);
typedef void (^HirRequestConnectFail)();

@interface NSString (URLEncode) 
- (NSString *)URLEncodeString;
@end  


@protocol HIRHttpRequestDelegate

- (void)requestSucceed:(id)request response:(NSURLResponse *)response result:(NSDictionary *)resultDic;
- (void)requestFailed:(id)request response:(NSURLResponse *)response error:(NSError *)error;

@end


@interface HIRHttpRequest : NSObject{
	NSURLConnection *connection;
	NSMutableData *resultData;
	NSURLResponse *requestReponse;
}

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, weak) id<HIRHttpRequestDelegate> requestDelegate;
@property (nonatomic, strong) NSMutableData *resultData;
@property (nonatomic, strong) NSURLResponse *requestReponse;
@property (nonatomic, assign) BOOL isNeedEncrypt;

- (id)initWithDelegate:(id)delegate;
- (BOOL)requestGet:(NSString *)url;
- (BOOL)requestPost:(NSString *)url Parameters:(NSDictionary *)parameters;//parameters其key-value必须为字符串
- (BOOL)requestPost:(NSString *)url bodyData:(NSData *)data;
- (void)cancel;


+ (BOOL)sendAsynchronousRequest:(NSURLRequest*) request queue:(NSOperationQueue*) queue completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))handle;

+(void)sendAsynchronousRequestWithParaDic:(NSDictionary *)paraDic
                                      api:(NSString *)api
                        hirRequestSuccess:(HirRequestSuccess)hirRequestSuccess
                           hirRequestErro:(HirRequestErro)hirRequestErro
                    hirRequestConnectFail:(HirRequestConnectFail)hirRequestConnectFail;

@end
