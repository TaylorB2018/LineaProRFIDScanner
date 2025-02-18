//
//  KeyboardViewController.swift
//  LineaProRFIDScannerKeyboard
//
//  Created by Taylor Burgess on 2025/1/8.
//

import UIKit
import KeyboardKit

class KeyboardViewController: KeyboardInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(for: .LineaProRFIDScannerApp)
        // Perform custom UI setup here
        
    }
    override func viewWillSetupKeyboardView() {
        setupKeyboardView { [weak self ] controller in
            CustomKeyboardView(
                state: controller.state,
                services: controller.services
            )
            
            
        }
    }
    /*
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
     */
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        
    }

}

extension KeyboardApp{
    static var LineaProRFIDScannerApp: KeyboardApp {
            .init(
                name: "LineaProRFIDScannerApp",
                bundleId: "com.taylor.LineaProRFIDScanner.LineaProRFIDScannerKeyboard", appGroupId: "group.com.keyboardkit.demo",   // Sets up App Group data sync
                locales: .keyboardKitSupported             // Sets up the enabled locales
                 // Defines how to open the app
            )
        }
}
