//  HtmTdAnalyzer20111008.h
//  HtmTdAnalyzer20111009.h
//  HtmTdAnalyzer20111016.h

#import <Foundation/Foundation.h>

@interface HtmTdParser : NSObject <NSXMLParserDelegate>{
	NSData* sourseData;
	NSMutableArray* stringsArray;
	NSArray* cuttersArray;

	NSMutableArray* atomsArray;
	NSMutableArray* contentArray;
	
	NSStringEncoding encoding;
}
@property(nonatomic,assign)NSData* sourseData;
@property(nonatomic,assign)NSMutableArray* stringsArray;
@property(nonatomic,assign)NSArray* cuttersArray;
@property(nonatomic)NSStringEncoding encoding;

+(BOOL)parseAndSeparateByLineFrom:(NSData*)aSourceData into:(NSMutableArray*)aTargetArray encoding:(NSStringEncoding)anEncoding;
+(BOOL)parseAndSeparateByCutters:(NSArray*)aCuttersArray from:(NSData*)aSourceData into:(NSMutableArray*)aTargetArray encoding:(NSStringEncoding)anEncoding;
-(BOOL)parse;
-(void)replaceObjectAtIndex:(NSInteger)index withArray:(NSArray*)anArray inMutableArray:(NSMutableArray*)aMutableArray;
-(NSString*)subStringWithoutHeadSpaceOfString:(NSString*)aString;
-(void)nonreduplicateStringsArray:(NSMutableArray*)aMutableArray;
-(void)getAtomsArray:(NSMutableArray*)anAtomsArray from:(NSData*)aSourceData;
-(NSUInteger)putAtomIntoAllocArray:(NSMutableArray*)aMutableArray from:(NSData*)aSourceData at:(NSUInteger)aLocation;
-(void)getTDContentArray:(NSMutableArray*)aContentArray from:(NSData*)aSourceData locateBy:(NSMutableArray*)aSourceArray;
-(BOOL)isHeadOfTD:(NSMutableDictionary*)anAtomDic;
-(BOOL)isTailOfTD:(NSMutableDictionary*)anAtomDic;
-(id)initWithSourceData:(NSData*)aSourceData targetArray:(NSMutableArray*)aTargetArray cuttersArray:(NSArray*)aCutterArray encoding:(NSStringEncoding)anEncoding;
-(void)replaceIllegalBytesOfStringsIn:(NSMutableArray*)aSourceArray;
-(BOOL)findIllegalBytesIn:(NSData*)aSourceData target:(NSMutableData*)aTargetData;
-(void)translateFrom:(NSArray*)aContentArray into:(NSMutableArray*)aStringsArray;
-(void)translateHTMlUTFPureContent:(NSMutableData*)pureContent;
-(void)translateWithEncoding:(NSStringEncoding)encoding from:(NSArray*)aContentArray into:(NSMutableArray*)aStringsArray;
-(void)removeVoidHeadOfStringsInArray:(NSMutableArray*)aSourceArray;
-(NSData*)replaceIllegalBytesIn:(NSData*)aSourceData at:(NSUInteger)aLocation addedCounter:(NSUInteger*)aCounterP;
-(BOOL)isStringEqual:(const char*)aString from:(NSData*)aSourceData at:(NSUInteger)aLocation;
-(void)separateByString:(NSString*)cuter intoStringsArray:(NSMutableArray*)aMutableArray;
-(void)separateByCuttersArray:(NSArray*)aCutterArray into:(NSMutableArray*)aStringsArray;

@end
