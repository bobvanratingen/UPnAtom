//
//  SAXXMLParserElementObservation.swift
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

public class SAXXMLParserElementObservation {
    // internal
    private(set) var didStartParsingElement: ((elementName: String, attributeDict: [NSObject : AnyObject]!) -> Void)? // TODO: Should ideally be a constant, see Github issue #10
    let didEndParsingElement: ((elementName: String) -> Void)?
    let foundInnerText: ((elementName: String, text: String) -> Void)?
    let elementPath: [String]
    private(set) var innerText: String?
    
    public init(elementPath: [String], didStartParsingElement: ((elementName: String, attributeDict: [NSObject : AnyObject]!) -> Void)?, didEndParsingElement: ((elementName: String) -> Void)?, foundInnerText: ((elementName: String, text: String) -> Void)?) {
        self.elementPath = elementPath
        
        self.didEndParsingElement = didEndParsingElement
        self.foundInnerText = foundInnerText
        
        self.didStartParsingElement = {[unowned self] (elementName: String, attributeDict: [NSObject : AnyObject]!) -> Void in
            // reset _innerText at the start of the element parse
            self.innerText = nil
            
            if let didStartParsingElement = didStartParsingElement {
                didStartParsingElement(elementName: elementName, attributeDict: attributeDict)
            }
        }
    }
    
    func appendInnerText(innerText: String?) {
        if self.innerText == nil {
            self.innerText = ""
        }
        
        if let innerText = innerText {
            self.innerText! += innerText
        }
    }
}
