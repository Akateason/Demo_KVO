//
//  ViewController.m
//  Demo_KVO
//
//  Created by TuTu on 16/9/23.
//  Copyright © 2016年 teason. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic)               NSString    *testData;
@property (nonatomic, readwrite)    BOOL        testBoolean;
@property (weak, nonatomic) IBOutlet UITextView *resultText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self addObserver:self
//           forKeyPath:@"testData"
//              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld |         NSKeyValueObservingOptionPrior
//              context:&self->_testData] ;

    [self addObserver:self
           forKeyPath:@"testData"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:&self->_testData] ;

    
    
    [self addObserver:self
           forKeyPath:@"testBoolean"
              options:0
              context:&self->_testBoolean] ;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeObserver:self forKeyPath:@"testData" context:&self->_testData];
    [self removeObserver:self forKeyPath:@"testBoolean"context:&self->_testBoolean];
}


#pragma mark - action

- (IBAction)changeData:(UIButton *)sender
{
    static int times = 0;
    times ++;
    [self appendToResult: [NSString stringWithFormat: @"\n--- click %i ---\n", times]];
    if (!_testData) {
        self.testData = @"newData";
    } else {
        self.testData = @"newData2";
    }
    self.testBoolean = YES;
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == &self->_testData)
    {
        assert([NSThread isMainThread]);
        [self appendToResult: [NSString stringWithFormat:@"--- testData ---\noptions: %@\n", change]];
    }
    else if (context == &self->_testBoolean)
    {
        assert([NSThread isMainThread]);
        [self appendToResult: [NSString stringWithFormat:@"--- testBoolean ---\noptions: %@\n", change]];
        [self appendToResult: [NSString stringWithFormat:@"new boolean: %i\n", self.testBoolean]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    [self appendToResult: @"--- end ---\n\n"];
}

- (void)appendToResult: (NSString *) result
{
    self.resultText.text = [self.resultText.text stringByAppendingString: result];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"testBoolean"])
    {
        // 返回NO会使得不能接受testBoolean的通知
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
