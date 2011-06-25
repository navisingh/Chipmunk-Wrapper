//
//  Utils.h
//  CheckersKingFree
//
//  Created by Navi Singh on 3/4/11.
//  Copyright 2011 TheSinghs.org. All rights reserved.
//

#import <Foundation/Foundation.h>

//======================================================================
//ALog / DLog from Karl Kraft @ http://www.karlkraft.com/index.php/2009/03/23/114/
//don't forget to set "Other C Flags" and "Other C++ Flags" to -DDEBUG in "GCC 4.2 - Language" for the active target.
#ifdef DEBUG

#define DLog(args...) _DebugLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
#define DLog(x...) do{}while(0)
#endif
#define ALog(...) NSLog(_VA_ARGS__)

void _DebugLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);


//======================================================================
/*sample usage of the logging class.
 {
 SaveNSLog s;
 NSLog(@"hello world dfadsf");
 }
 */

class SaveNSLog
{
	int stdErrSave;
public:
	SaveNSLog(bool append = false, NSString *path = nil);
	~SaveNSLog();
};

class DeleteNSLog
{
public:
	DeleteNSLog(NSString *path = nil);	
};

void saveNSLogToFile();

//======================================================================

bool isIPad();
NSString *pathInDocumentDirectory(NSString *fileName);

#define MAKELONG(a, b) (long)(((long)a << 16) | (long) b)
#define HISHORT(a) (short)(((long)a) >> 16)
#define LOSHORT(b) (short)(((long)b) & 0xffff)
