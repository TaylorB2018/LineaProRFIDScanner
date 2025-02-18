//
//  CustomKeyboardView.swift
//  LineaProRFIDScanner
//
//  Created by Taylor Burgess on 2025/2/17.
//

import KeyboardKit
import SwiftUI

struct CustomKeyboardView: View {


    var state: Keyboard.State
    var services: Keyboard.Services


    // State can also be accessed from the enviroment.
    @EnvironmentObject var keyboardContext: KeyboardContext


    var body: some View {
        if keyboardContext.keyboardType == .email {
            // Insert your GPT-powered email client here :)
        } else {
            KeyboardView(
                state: state,
                services: services,
                buttonContent: { $0.view
 },
        // Use $0.view to use the standard view
                buttonView: { $0.view },
           // The $0 has additional parameter data
                collapsedView: { params in params.view },
                // This is the same as $0.view
                emojiKeyboard: { $0.view },
                toolbar: {
                    _ in CustomToolbarView()
                }  // Ignores the params and returns a view
            )
        }
    }
}
