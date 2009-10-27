//
//  SMSSender.m
//	Cocoa Touch API SMSSender
//

#import "SMSSender.h"


@implementation SMSSender

- (NSString *) SendMessage: (NSString *) login pass: (NSString *) password destination: (NSString *) number text: (NSString *) message {

	NSString * result;
	
	CFHTTPMessageRef requestmsg;
	NSURL * urlsmssender = [NSURL URLWithString:@"https://opensms.movistar.es/aplicacionpost/loginEnvio.jsp"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urlsmssender, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("gzip, deflate"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("opensms.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	NSString * bodyData = [NSString stringWithFormat:@"TM_ACTION=AUTHENTICATE&TM_LOGIN=%@&TM_PASSWORD=%@&to=%@&message=%@",login, password, number, message];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	
	streamSMS = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, requestmsg);
	CFRelease(requestmsg);
	
	if (!streamSMS) {
		result = [NSString stringWithFormat:@"Error to create the stream"];
		CFRelease(streamSMS);
		streamSMS=NULL;
		return result;
	}
	
	if (!CFReadStreamOpen(streamSMS)) {
		CFReadStreamSetClient(streamSMS, 0, NULL, NULL);
		CFReadStreamUnscheduleFromRunLoop(streamSMS, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFRelease(streamSMS);
		streamSMS = NULL;
		result = [NSString stringWithFormat:@"Error at open the stream"];
		return result;
	}
	
	BOOL done = FALSE;
	
	while (!done) {
		if (CFReadStreamHasBytesAvailable(streamSMS)) {
			UInt8 buf[1024];
			CFIndex bytesRead = CFReadStreamRead(streamSMS, buf, sizeof(buf));
			if (bytesRead < 0) {
				CFStreamError error = CFReadStreamGetError(streamSMS);
				result = [NSString stringWithFormat:@"An error occurred -> Domain: %d Code: %d",error.domain, error.error];
				done = TRUE;
			} else {
				result = [NSString stringWithCString: (char*)buf length: bytesRead];
				done = TRUE;
			}
		}
	}
	
	
 return result;


}

@end
