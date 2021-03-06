//
//  ViewController.swift
//  Git Branch Naming Creator
//
//  Created by Galushka on 3/21/19.
//  Copyright © 2019 Galushka. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var enteringTextField: NSTextField!
    @IBOutlet weak var copiedTextField: NSTextField!
    @IBOutlet weak var resultTextField: NSTextField!
    
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    private let branchNameConvertor: BranchNameConvertorType = BranchNameConvertor()
    private let pasteboardAssistant = PasteboardAssistant.general
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
        
    private func setupUI() {
        copiedTextField.alphaValue = 0.0
        self.enteringTextField.becomeFirstResponder()
        
        if let currentScreenSize = Screen.currentScreenResolution() {
            viewWidthConstraint.constant = round(currentScreenSize.width * 0.4)
            viewHeightConstraint.constant = round(currentScreenSize.height * 0.4)
        }
    }
    
    @IBAction func enteringTextFieldEnterActionHandler(_ sender: Any) {
        
        if !enteringTextField.stringValue.isEmpty {
            
            do {
                resultTextField.stringValue = try self.branchNameConvertor.convert(text: enteringTextField.stringValue)
            } catch (let error) {
                resultTextField.stringValue = error.localizedDescription
            }
            
            textCopied()
        }
    }
    
    func textCopied() {
    
        if pasteboardAssistant.writeText(resultTextField.stringValue) {
            NSAnimationContext.runAnimationGroup({ (animationContext) in
                animationContext.duration = 1.25
                copiedTextField.animator().alphaValue = 1.0
            }, completionHandler: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                    NSAnimationContext.runAnimationGroup({ (animationContext) in
                        animationContext.duration = 0.25
                        self.copiedTextField.animator().alphaValue = 0.0
                    },  completionHandler: nil)
                })
            })
        }
        
        
    }
}

