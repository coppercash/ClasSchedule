//  HtmTdAnalyzer20111008.m
//  HtmTdAnalyzer20111008.m
//  HtmTdAnalyzer20111016.m GB2312 = 0x80000632

#import "HtmTdParser.h"

@implementation HtmTdParser
@synthesize sourseData,stringsArray,cuttersArray,encoding;

+(BOOL)parseAndSeparateByLineFrom:(NSData*)aSourceData into:(NSMutableArray*)aTargetArray encoding:(NSStringEncoding)anEncoding{
	BOOL success;
	NSArray* cutters = [[NSArray alloc] initWithObjects:@"\n",nil];
	HtmTdParser* parser = [[HtmTdParser alloc] initWithSourceData:aSourceData targetArray:aTargetArray cuttersArray:cutters encoding:anEncoding];
	success = [parser parse];
	[cutters release];
	[parser release];
	return success;
}

+(BOOL)parseAndSeparateByCutters:(NSArray*)aCuttersArray from:(NSData*)aSourceData into:(NSMutableArray*)aTargetArray encoding:(NSStringEncoding)anEncoding{
	BOOL success;
	HtmTdParser* parser = [[HtmTdParser alloc] initWithSourceData:aSourceData targetArray:aTargetArray cuttersArray:aCuttersArray encoding:anEncoding];
	success = [parser parse];
	[parser release];
	return success;
}

-(BOOL)parse{
	if (sourseData && stringsArray) {
		[self getAtomsArray:atomsArray from:sourseData];
		[self getTDContentArray:contentArray from:sourseData locateBy:atomsArray];
		[self replaceIllegalBytesOfStringsIn:contentArray];
		[self translateWithEncoding:encoding from:contentArray into:stringsArray];
		[self separateByCuttersArray:cuttersArray into:stringsArray];
		[self removeVoidHeadOfStringsInArray:stringsArray];
		[self nonreduplicateStringsArray:stringsArray];
		
		return YES;
	}
	return NO;
}

#pragma mark GetAtoms
-(void)getAtomsArray:(NSMutableArray*)anAtomsArray from:(NSData*)aSourceData {
	const unsigned char* dataPointer = [aSourceData bytes];
	NSUInteger currentLength = 0;
	NSUInteger currentLocation = 0;
	
	for (;currentLocation < [aSourceData length]; ) {
		if (*(dataPointer + currentLocation) == '<') {
			currentLength = [self putAtomIntoAllocArray:anAtomsArray from:aSourceData at:currentLocation];
			currentLocation += currentLength;
		}else {
			currentLocation++;
		}
	}
}

-(NSUInteger)putAtomIntoAllocArray:(NSMutableArray*)aMutableArray from:(NSData*)aSourceData at:(NSUInteger)aLocation{
	if (!(aMutableArray && aSourceData)) return 0;
	
	int switcher = 0;
	NSUInteger startLocation = aLocation;
	NSUInteger endLocation = startLocation;
	const unsigned char* dataPointer = [aSourceData bytes];
	
	for (;;) {
		endLocation++;
		if (*(dataPointer + endLocation) == ' ') {
			switcher = 1;
			break;
		}
		if (*(dataPointer + endLocation) == '\n') {
			switcher = 1;
			break;
		}
		if (*(dataPointer + endLocation) == '>') {
			break;
		}
	}
	NSString* type = [[NSString alloc] initWithBytes:(dataPointer + startLocation + 1)
											  length:(endLocation - startLocation - 1)
											encoding:NSASCIIStringEncoding];
	
	if (switcher) {
		for (;;) {
			endLocation++;
			if (*(dataPointer + endLocation) == '>') {
				break;
			}
		}
	}
	
	NSDictionary* atomDic = [[NSDictionary alloc] initWithObjectsAndKeys:
							 [NSNumber numberWithUnsignedInteger:startLocation],@"<",
							 [NSNumber numberWithUnsignedInteger:endLocation],@">",
							 type,@"Type",
							 nil];
	[type release];
	
	[aMutableArray addObject:atomDic];
	[atomDic release];
	
	return endLocation - startLocation +1;
	
}

#pragma mark GetContent
-(void)getTDContentArray:(NSMutableArray*)aContentArray from:(NSData*)aSourceData locateBy:(NSMutableArray*)aSourceArray{
	if (!(aSourceArray && aSourceData)) return;
	
	NSUInteger currentStart = 0;
	NSUInteger currentEnd = 0;
	NSMutableDictionary* currentAtom = nil;
	NSMutableData* currentContent = nil;
	BOOL readyToWrite = NO;
	
	for (int i = 0; i < [aSourceArray count]; i++) {
		currentAtom = [aSourceArray objectAtIndex:i];
		if ([self isHeadOfTD:currentAtom]) {
			if (readyToWrite) {
				[currentContent release];
			}
			currentContent = [[NSMutableData alloc] init];

			currentStart = [[currentAtom objectForKey:@">"] unsignedIntegerValue];
			currentStart += 1;
			
			readyToWrite = YES;
			continue;
		}
		if ([self isTailOfTD:currentAtom] && readyToWrite){
			currentEnd = [[currentAtom objectForKey:@"<"] unsignedIntegerValue];
			
			[currentContent appendData:[aSourceData subdataWithRange:NSMakeRange(currentStart, currentEnd - currentStart)]];
			[aContentArray addObject:currentContent];
			[currentContent release];
			
			readyToWrite = NO;
			continue;
		}
		if(readyToWrite){
			currentEnd = [[currentAtom objectForKey:@"<"] unsignedIntegerValue];
			[currentContent appendData:[aSourceData subdataWithRange:NSMakeRange(currentStart, currentEnd - currentStart)]];
			 
			currentStart = [[currentAtom objectForKey:@">"] unsignedIntegerValue];
			currentStart += 1;
			continue;
		}
	}
}

-(BOOL)isHeadOfTD:(NSMutableDictionary*)anAtomDic{
	NSString* type = [anAtomDic objectForKey:@"Type"];
	if ([type isEqualToString:@"td"] || [type isEqualToString:@"TD"]) {
		return YES;
	}
	return NO;
}

-(BOOL)isTailOfTD:(NSMutableDictionary*)anAtomDic{
	NSString* type = [anAtomDic objectForKey:@"Type"];
	if ([type isEqualToString:@"/td"] || [type isEqualToString:@"/TD"]) {
		return YES;
	}
	return NO;
}

#pragma mark replaceIllegalStrings
-(void)replaceIllegalBytesOfStringsIn:(NSMutableArray*)aSourceArray{
	NSData* sourceData = nil;
	NSMutableData* targetData = nil;
	NSUInteger count = [aSourceArray count];
	NSUInteger counter = 0;
	
	for (;counter < count;counter++) {
		sourceData = [aSourceArray objectAtIndex:counter];
		targetData = [[NSMutableData alloc] init];
		if ([self findIllegalBytesIn:sourceData target:targetData]) {
			[aSourceArray replaceObjectAtIndex:counter withObject:targetData];
			[targetData release];
		}else {
			[targetData release];
		}
	}
}

-(BOOL)findIllegalBytesIn:(NSData*)aSourceData target:(NSMutableData*)aTargetData{
	if (!(aSourceData && aTargetData)) return NO;	
	
	NSUInteger counter = 0;
	NSUInteger currentStart = 0;
	NSUInteger addCounter = 0;
	NSUInteger length = [aSourceData length];
	NSData* replacingData = nil;
	BOOL changed = NO;
	
	while (counter < length) {
		replacingData = [self replaceIllegalBytesIn:aSourceData at:counter addedCounter:&addCounter];
		if (replacingData) {
			changed = YES;
			[aTargetData appendData:[aSourceData subdataWithRange:NSMakeRange(currentStart, counter - currentStart)]];
			[aTargetData appendData:replacingData];
			counter += addCounter;
			currentStart = counter;
		}
		else if (counter == (length - 1)) {
			[aTargetData appendData:[aSourceData subdataWithRange:NSMakeRange(currentStart, counter - currentStart + 1)]];
			counter++;
		}else {
			counter++;
		}
	}
	
	return changed;
}

-(NSData*)replaceIllegalBytesIn:(NSData*)aSourceData at:(NSUInteger)aLocation addedCounter:(NSUInteger*)aCounterP{
	if (!(aLocation < [aSourceData length])) return nil;	
	
	NSUInteger replacingStrLen = 0;
	const char* replacedString = nil;
	NSUInteger replacedStrLen = 0;
	NSData* replacedData = nil;
	
	if ([self isStringEqual:"&nbsp;" from:aSourceData at:aLocation]) {
		replacingStrLen = 6;
		replacedString = " ";
	}
	else if ([self isStringEqual:"&nbsp" from:aSourceData at:aLocation]) {
		replacingStrLen = 5;
		replacedString = " ";
	}
	
	if (replacedString) {
		*aCounterP = replacingStrLen;

		replacedStrLen = strlen(replacedString);
		replacedData = [NSData dataWithBytes:replacedString length:replacedStrLen];
	}
	return replacedData;
}

-(BOOL)isStringEqual:(const char*)aString from:(NSData*)aSourceData at:(NSUInteger)aLocation{
	NSUInteger length = [aSourceData length];
	NSUInteger strLength = strlen(aString);
	if (!(aLocation <= length - strLength)) return NO;
	
	const unsigned char* dataPointer = [aSourceData bytes];
	dataPointer += aLocation;
	for (int i = 0; i < strLength; i++) {
		if (aString[i] ^ dataPointer[i]) {
			return NO;
		}
	}
	return YES;
}

#pragma mark ImplementationOfNSXMLParserDelegate
-(void)translateFrom:(NSArray*)aContentArray into:(NSMutableArray*)aStringsArray{
	NSMutableString* firstString = [[NSMutableString alloc] init];
	[stringsArray addObject:firstString];
	[firstString release];
	
	for (NSMutableData* data in aContentArray) {
		[self translateHTMlUTFPureContent:data];
	}
}

-(void)translateHTMlUTFPureContent:(NSMutableData*)pureContent{
	if (!pureContent) return;
	NSMutableData* reformatContent = [[NSMutableData alloc] init];
	[reformatContent appendBytes:"<td>" length:4];
	[reformatContent appendData:pureContent];
	[reformatContent appendBytes:"</td>" length:5];
	
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:reformatContent];
	[parser setDelegate:self];
	[parser parse];
	
	[reformatContent release];
	[parser release];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	if ([[stringsArray lastObject] length] != 0 ) {
		NSMutableString* newString = [[NSMutableString alloc] init];
		[stringsArray addObject:newString];
		[newString release];
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	NSMutableString* lastString = [stringsArray lastObject];
	[lastString appendString:string];
}

-(void)translateWithEncoding:(NSStringEncoding)anEncoding from:(NSArray*)aContentArray into:(NSMutableArray*)aStringsArray{
	if (anEncoding) {
		NSString* currentStr = nil;
		for (NSData* data in aContentArray) {
			currentStr = [[NSString alloc] initWithData:data encoding:anEncoding];
			[aStringsArray addObject:currentStr];
			[currentStr release];
		}
	}else {
		[self translateFrom:aContentArray into:aStringsArray];
	}
}

#pragma mark SeparateByLineFeedAndNonreduplicate
-(void)separateByCuttersArray:(NSArray*)aCutterArray into:(NSMutableArray*)aStringsArray{
	if (!aCutterArray) return;
	if ([aCutterArray count] == 0) return;
	for (NSString* str in aCutterArray) {
		[self separateByString:str intoStringsArray:aStringsArray];
	}
}

-(void)separateByString:(NSString*)cuter intoStringsArray:(NSMutableArray*)aMutableArray{
	if (!aMutableArray) return;
	
	NSUInteger count = [aMutableArray count];
	NSString* currentString = nil;
	NSArray* currentComponents = nil;
	int i = 0;
	for (i = 0; i < count;){
		currentString = [aMutableArray objectAtIndex:i];
		currentComponents = [currentString componentsSeparatedByString:cuter];
		[self replaceObjectAtIndex:i withArray:currentComponents inMutableArray:aMutableArray];
		i += [currentComponents count];
		count = [aMutableArray count];
	}
}

-(void)replaceObjectAtIndex:(NSInteger)index withArray:(NSArray*)anArray inMutableArray:(NSMutableArray*)aMutableArray{
	if (!(anArray && aMutableArray)) return;
	
	NSInteger i = index;
	
	[aMutableArray removeObjectAtIndex:index];
	for (NSString* str in anArray) {
		if ([str length] == 0) {
			continue;
		}
		[aMutableArray insertObject:str atIndex:i];
		i++;
	}
}

#pragma mark removeVoidHeadOfStringsInArray
-(void)removeVoidHeadOfStringsInArray:(NSMutableArray*)aSourceArray{
	if (!aSourceArray) return;
	NSUInteger counter = 0;
	NSUInteger count = [aSourceArray count];
	NSString* oldString = nil;
	NSString* newString = nil;
	
	while (counter < count) {
		oldString = [aSourceArray objectAtIndex:counter];
		if ((newString = [self subStringWithoutHeadSpaceOfString:oldString])) {
			[aSourceArray replaceObjectAtIndex:counter withObject:newString];
		}
		counter++;
	}
	
}

-(NSString*)subStringWithoutHeadSpaceOfString:(NSString*)aString{
	if (!aString) return nil;
	
	NSUInteger startCharacter = 0;
	unichar currentChar;
	for (; startCharacter < [aString length]; startCharacter++) {
		currentChar = [aString characterAtIndex:startCharacter];
		if (currentChar != '\n' && currentChar != ' ' && currentChar != '\t' && currentChar != '\r') {
			break;
		}
	}
	if (startCharacter != 0) {
		NSString* newString = [aString substringFromIndex:startCharacter];
		return newString;
	}
	return nil;
}

#pragma mark nonreduplicateStringsArray
-(void)nonreduplicateStringsArray:(NSMutableArray*)aMutableArray{
	if (!aMutableArray) return;
	
	NSUInteger count = [aMutableArray count];
	NSString* currentString = nil;
	NSString* comparingString = nil;
	int i = 0;
	int j = 0;
	while (i < count) {
		currentString = [aMutableArray objectAtIndex:i];
		if ([currentString length] == 0) {
			[aMutableArray removeObjectAtIndex:i];
			count--;
		}
		else {
			j = i + 1;
			while (j < count) {
				comparingString = [aMutableArray objectAtIndex:j];
				if ([comparingString isEqualToString:currentString]) {
					[aMutableArray removeObjectAtIndex:j];
					count--;
				}else {
					j++;
				}
			}
			i++;
		}
	}
}

#pragma mark InitAndDealloc
-(id)initWithSourceData:(NSData*)aSourceData targetArray:(NSMutableArray*)aTargetArray cuttersArray:(NSArray*)aCutterArray encoding:(NSStringEncoding)anEncoding{
	if (self = [super init]) {
		sourseData = aSourceData;
		
		stringsArray = aTargetArray;
				
		cuttersArray = aCutterArray;
		
		atomsArray = [[NSMutableArray alloc] init];
		contentArray = [[NSMutableArray alloc] init];
		
		encoding = anEncoding;
	}
	return self;
}

-(void)dealloc{
	[self setSourseData:nil];
	[self setStringsArray:nil];
	cuttersArray = nil;
	
	[atomsArray release];
	atomsArray = nil;
	
	[contentArray release];
	contentArray = nil;
	
	[super dealloc];
}

@end
