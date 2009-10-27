//
//  Localizame.m
//  API Cocoa Touch Localizame
//


#import "Localizame.h"

@interface Localizame (Private)

- (BOOL) SendHttpMessageHead: (CFHTTPMessageRef) httpmessage;
- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage;

@end

@implementation Localizame

- (BOOL) Login: (NSString *) login password: (NSString *) pass {
	NSString * resultado;
	BOOL res = FALSE;
	CFHTTPMessageRef requestmsg;
	NSURL * urllocalizame = [NSURL URLWithString:@"http://www.localizame.movistar.es/login.do"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urllocalizame, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("www.localizame.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	NSString * bodyData = [NSString stringWithFormat:@"usuario=%@&clave=%@&submit.y=6",login,pass];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	
	//LOGIN
	if ([self SendHttpMessageHead:requestmsg]) {
		// GET COOKIE
		NSString * pic = @"Set-Cookie:";
		NSRange range = [dataresponse rangeOfString:pic];
		if (range.length != 0) {
			resultado = [dataresponse substringFromIndex: (range.location+12)];
			pic = @";";
			range = [resultado rangeOfString:pic];
			Cookie = [resultado substringToIndex:range.location];
			//NEW USER
			urllocalizame = [NSURL URLWithString:@"http://www.localizame.movistar.es/nuevousuario.do"];
			requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef) urllocalizame, kCFHTTPVersion1_1);
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("www.localizame.movistar.es"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
			CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
			if ([self SendHttpMessageHead:requestmsg]) {
				res = TRUE;
			}
		}
	}
	
	CFRelease(streamSMS);
	streamSMS = NULL;
	return res;
}

- (NSString *) Locate: (NSString *) number {
	NSString * resultado;
	CFHTTPMessageRef requestmsg;
	NSURL * urllocalizame = [NSURL URLWithString:@"http://www.localizame.movistar.es/buscar.do"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("POST"), (CFURLRef) urllocalizame, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("www.localizame.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
	NSString * bodyData = [NSString stringWithFormat:@"telefono=%@",number];
	NSData * body = [bodyData dataUsingEncoding:kCFStringEncodingASCII allowLossyConversion: YES];
	CFHTTPMessageSetBody(requestmsg, (CFDataRef) body);
	
	if ([self SendHttpMessageBody:requestmsg]) {
		//SEARCH LOCATION TEXT
		NSString * pic = [NSString stringWithFormat:@"%@ se",number];
		NSRange range = [dataresponse rangeOfString:pic];
		if (range.length != 0) {
			resultado = [dataresponse substringFromIndex:range.location];
			pic = @"s.";
			range = [resultado rangeOfString:pic];
			resultado = [resultado substringToIndex:(range.location+2)];
		} else {
			resultado = [NSString stringWithFormat:@"Error to locate"];
		}
	} else {
		resultado = [NSString stringWithFormat:@"Error to locate"];
	}
	return resultado;
}

- (BOOL) Authorize: (NSString*) number {
	
	CFHTTPMessageRef requestmsg;
	NSString * urlstr = [NSString stringWithFormat:@"http://www.localizame.movistar.es/insertalocalizador.do?telefono=%@&submit.x=40&submit.y=5",number];
	NSURL * urllocalizame = [NSURL URLWithString:urlstr];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef) urllocalizame, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("www.localizame.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://www.localizame.movistar.es/buscalocalizadorespermisos.do"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
	
	return ([self SendHttpMessageHead:requestmsg]);
}

- (BOOL) Unauthorize: (NSString*) number {
	CFHTTPMessageRef requestmsg;
	NSString * urlstr = [NSString stringWithFormat:@"http://www.localizame.movistar.es/borralocalizador.do?telefono=%@&submit.x=44&submit.y=8",number];
	NSURL * urllocalizame = [NSURL URLWithString:urlstr];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef) urllocalizame, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Content-type"), CFSTR("application/x-www-form-urlencoded"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("www.localizame.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Referer"), CFSTR("http://www.localizame.movistar.es/buscalocalizadorespermisos.do"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
	return ([self SendHttpMessageHead:requestmsg]);
}

- (BOOL) Logout {
	CFHTTPMessageRef requestmsg;
	NSURL * urllocalizame = [NSURL URLWithString:@"http://www.localizame.movistar.es/logout.do"];
	requestmsg = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef) urllocalizame, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Host"), CFSTR("www.localizame.movistar.es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("User-Agent"), CFSTR("Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Encoding"), CFSTR("identity"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept-Language"), CFSTR("es"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Accept"), CFSTR("image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Connection"), CFSTR("Keep-Alive"));
	CFHTTPMessageSetHeaderFieldValue(requestmsg, CFSTR("Cookie"), (CFStringRef)Cookie);
	return ([self SendHttpMessageHead:requestmsg]);
}

/* ****** PRIVATE SECTION ****** */

- (BOOL) SendHttpMessageHead: (CFHTTPMessageRef) httpmessage {
	BOOL res = FALSE;
	streamSMS = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, httpmessage);
	CFRelease(httpmessage);
	if (!streamSMS) {
		CFRelease(streamSMS);
		streamSMS=NULL;
		return res;
	}
	
	if (!CFReadStreamOpen(streamSMS)) {
		CFRelease(streamSMS);
		streamSMS = NULL;
		return res;
	}
	CFHTTPMessageRef msgRespuesta;
	NSString * cuerpo;
	BOOL done = FALSE;
	while (!done) {
		if (CFReadStreamHasBytesAvailable(streamSMS)) {
			UInt8 bufi[4096];
			CFIndex bytesRead = CFReadStreamRead(streamSMS, bufi, sizeof(bufi));
			if (bytesRead < 0) {
				done = TRUE;
			} else if (bytesRead == 0) {
				msgRespuesta = (CFHTTPMessageRef) CFReadStreamCopyProperty(streamSMS, kCFStreamPropertyHTTPResponseHeader);
				NSData * therequest = (NSData *) CFHTTPMessageCopySerializedMessage(msgRespuesta);
				statusCode = CFHTTPMessageGetResponseStatusCode(msgRespuesta);
				dataresponse = [NSString stringWithCString: [therequest bytes] length: [therequest length]];
				if (statusCode==200) {
					res = TRUE;
				} else {
					res = FALSE;
				}
				done = TRUE;
			} else {
				cuerpo = [NSString stringWithCString: (char*)bufi length: bytesRead];
			}
			
		}
	}
	
	return res;
}


- (BOOL) SendHttpMessageBody: (CFHTTPMessageRef) httpmessage {
	streamSMS = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, httpmessage);
	CFRelease(httpmessage);
	
	if (!streamSMS) {
		CFRelease(streamSMS);
		streamSMS=NULL;
		return FALSE;
	}
	
	if (!CFReadStreamOpen(streamSMS)) {
		CFRelease(streamSMS);
		streamSMS = NULL;
		return FALSE;
	}
	NSString * cuerpo = [NSString stringWithFormat:@"Cuerpo:"];
	NSString * temporal;
	BOOL done = FALSE;
	while (!done) {
		if (CFReadStreamHasBytesAvailable(streamSMS)) {
			UInt8 bufi[4096];
			CFIndex bytesRead = CFReadStreamRead(streamSMS, bufi, sizeof(bufi));
			if (bytesRead < 0) {
				return FALSE;
				done = TRUE;
			} else if (bytesRead == 0) {
				dataresponse = [NSString stringWithString:cuerpo];
				done = TRUE;
			} else {
				temporal = [NSString stringWithCString: (char*)bufi length: bytesRead];
				cuerpo = [cuerpo stringByAppendingString:temporal];
			}
			
		}
	}
	
	CFRelease(streamSMS);
	streamSMS = NULL;
	return TRUE;
}

@end

