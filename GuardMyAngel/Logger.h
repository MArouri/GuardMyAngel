// *************************************************************
// set other flags -DDEBUG=1 or 
// #define DEBUG=1
// Examples:
// DLog(@"here");
// DLog(@"value: %d", x);
// DLog(@"%@", aStringVariable);

#if DEBUG == 1
#  define DLog(fmt, ...) NSLog( (@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#  define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog( (@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);