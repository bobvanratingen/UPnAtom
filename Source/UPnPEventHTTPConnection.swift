//
//  UPnPEventHTTPConnection.swift
//
//  Copyright (c) 2015 David Robles
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

@objc class UPnPEventHTTPConnection: HTTPConnection {
    let bodyData = NSMutableData()
    
    override func supportsMethod(method: String!, atPath path: String!) -> Bool {
        return method.lowercaseString == "notify"
    }
    
    override func expectsRequestBodyFromMethod(method: String!, atPath path: String!) -> Bool {
        return true
    }
    
    override func httpResponseForMethod(method: String!, URI path: String!) -> NSObject! {
        if method.lowercaseString == "notify" && path == UPnPManager_Swift.sharedInstance.eventSubscriptionManager.eventCallBackPath {
            // TODO: this should be done via a delegate protocol however CocoaHTTPServer doesn't make this easy to do in Swift
            UPnPManager_Swift.sharedInstance.eventSubscriptionManager.handleIncomingEvent(subscriptionID: "", eventData: bodyData)
            
            return HTTPDataResponse(data: nil)
        }
        
        return super.httpResponseForMethod(method, URI: path)
    }
    
    override func processBodyData(postDataChunk: NSData!) {
        bodyData.appendData(postDataChunk)
    }
}
