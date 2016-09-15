//
//  StorageViewController.m
//  CBCordova
//
//  Created by gengych on 16/5/16.
//
//

#import "StorageViewController.h"

#import "CustomStorage.h"

@interface StorageViewController (){
    
    CustomStorage *customStorage;
}

@end

@implementation StorageViewController

PT_REGISTER_COMPONENT(PTComponentType_Native, 加密存储组件示例集合, 加密存储组件, StorageViewController, StorageViewController, , )

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[PTStorageManager getInstance] storageState]) {
        // 加密存储模块可用
        customStorage = [[CustomStorage alloc] init];
        [[PTStorageManager getInstance] registStorage:customStorage];
    }
    else{
        // 加密存储模块不可用，需要进行重新握手操作；
        BOOL result = [[PTFramework getInstance] handShake];
        if (result) {
            customStorage = [[CustomStorage alloc] init];
            [[PTStorageManager getInstance] registStorage:customStorage];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnBeforePage:(id)sender {
    // 执行该页面的回退；
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)systemEncryptAction:(id)sender {
    if ([[PTStorageManager getInstance] storageState]) {
        [[PTStorageManager getInstance] put:@"key1" value:@"pastry" formStorageName:@"PTSystemStorage"];
        [[PTStorageManager getInstance] commit:@"PTSystemStorage"];
    }
}

- (IBAction)systemDecrypt:(id)sender {
    if ([[PTStorageManager getInstance] storageState]) {
        NSString *result = [[PTStorageManager getInstance] getString:@"key1" formStorageName:@"PTSystemStorage"];
        PTLogDebug(@"系统解密结果 = %@", result);
    }
    
}

- (IBAction)frameCustomEncrypt:(id)sender {
    if ([[PTStorageManager getInstance] storageState]) {
        [[PTStorageManager getInstance] put:@"key1" value:@"pastry" formStorageName:@"PTPrivateStorage"];
        [[PTStorageManager getInstance] commit:@"PTPrivateStorage"];
    }
}

- (IBAction)frameCustomDecrypt:(id)sender {
    if ([[PTStorageManager getInstance] storageState]) {
        NSString *result = [[PTStorageManager getInstance] getString:@"key1" formStorageName:@"PTPrivateStorage"];
        PTLogDebug(@"私有解密结果 = %@", result);
    }
    
}

- (IBAction)clientCustomEncrypt:(id)sender {
    if ([[PTStorageManager getInstance] storageState]) {
        [[PTStorageManager getInstance] put:@"key1" value:@"pastry" formStorageName:[customStorage getName]];
        [[PTStorageManager getInstance] commit:[customStorage getName]];
    }
}

- (IBAction)clientCustomDecrypt:(id)sender {
    if ([[PTStorageManager getInstance] storageState]) {
        NSString *result = [[PTStorageManager getInstance] getString:@"key1" formStorageName:[customStorage getName]];
        PTLogDebug(@"自定义解密结果 = %@", result);
    }
    
}


#pragma mark - PTFrameworkDelegate 协议
- (void)didStorageChangeWithState:(int)result{
    if (result) {
        customStorage = [[CustomStorage alloc] init];
        [[PTStorageManager getInstance] registStorage:customStorage];
    }
}

@end
