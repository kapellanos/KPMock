//
//  UIViewController.swift
//  KPMock
//
//  Created by miguel olmedo on 11/3/15.
//  Copyright (c) 2015 KP. All rights reserved.
//

import UIKit

extension UIViewController
{
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UIViewController.self { return }
        
        dispatch_once(&Static.token) {
            let originalSelector = Selector("viewWillAppear:")
            let swizzledSelector = Selector("nsh_viewWillAppear:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    
    
    func nsh_viewWillAppear(animated: Bool) {
        
        var mc:CUnsignedInt = 0
        let imageView = UIImageView()
        var mlist:UnsafeMutablePointer<Method> = class_copyMethodList(object_getClass(imageView), &mc);
        println("\(mc) methods")
        
        for var i:CUnsignedInt = 0; i < mc; i++ {
            let method = mlist[Int(i)]
            println(sel_getName(method_getName(method)))
        }
        
        free(mlist)
//        unsigned int count;
//        Method *methods = class_copyMethodList(self, &count);
//        
//        NSMutableArray *array = [NSMutableArray array];
//        for(unsigned i = 0; i < count; i++)
//            [array addObject: [RTMethod methodWithObjCMethod: methods[i]]];
//        
//        free(methods);
//        return array;
    }
}