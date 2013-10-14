#import "CustomNavigationBar.h"
#import "Header.h"

@implementation UINavigationBar (CustomNavigationBar)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WoodBottom" ofType:@"png"]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];    

    [self setTintColor:[UIColor brownColor]];
    
    //[self.backItem.backBarButtonItem setImage:nil];
    [image release];
}

@end
