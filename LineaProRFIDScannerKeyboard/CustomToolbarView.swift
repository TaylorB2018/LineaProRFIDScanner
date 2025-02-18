//
//  CustomToolbarView.swift
//
//
//  Created by Taylor Burgess on 2025/02/05.
//
import KeyboardKit

import SwiftUI
    
struct CustomToolbarView: View {
    @EnvironmentObject
    var keyboardContext: KeyboardContext
    
    @State private var scanner = ScannerHelper()
    
    @State private var barcode = ""
    
    @State private var uhfScanData = ""
    
    @State private var rfidScanData = ""
    
    @State private var rfidButtonIsActive = false
    
    @State private var uhfButtonIsActive = false
    @State private var barcodeButtonIsActive = false
    @State private var scannerNotConnected: Bool = true
    var body: some View {
        VStack{
            HStack{
                
                Button("RFID Scan"){
                    scanner.initializeRFID()
                    rfidButtonIsActive.toggle()
                }
                .disabled(scannerNotConnected)
                .padding(5)
                //.background(Color(red: 0, green: 0, blue: 0.5))
                .foregroundStyle(rfidButtonIsActive ? .white : .black)
                .animation(.easeInOut.delay(0.4), value: rfidButtonIsActive)
                .buttonStyle(.borderedProminent)
                .tint(rfidButtonIsActive ? .green : .white)
                .cornerRadius(10)
                .shadow(
                    color: Color.gray,
                    radius: 10,
                    x: -10,
                    y: 10
                )
                .onReceive(scanner.$rfidCardData){ newValue in
                    if !newValue.isEmpty{
                        rfidScanData = newValue
                        rfidButtonIsActive = false
                        keyboardContext.textDocumentProxy.insertText(newValue)
                    }
                        
                }
                
                Divider()
                
                Button("UHF Scan"){
                    
                        
                            uhfButtonIsActive = true
                            scanner.startUHFScan()
                           //try await Task.sleep(nanoseconds: 1000000000)
                          uhfButtonIsActive = false
                        
                        
                        //  keyboardContext.textDocumentProxy.insertText(scanner.uhfTagData)
                    
                }
                .disabled(scannerNotConnected)                //
                .padding(5)
                .foregroundStyle(uhfButtonIsActive ? .white : .black)
                .animation(.easeInOut.delay(0.4), value: uhfButtonIsActive)
                .buttonStyle(.borderedProminent)
                .tint(uhfButtonIsActive ? .green : .white)
                .animation(.easeInOut.delay(0.4), value: uhfButtonIsActive)
                .cornerRadius(10)
                .shadow(
                    color: Color.gray,
                    radius: 10,
                    x: -10,
                    y: 10
                )
                .onReceive(scanner.$uhfTagData){newValue in
                    
                        if !newValue.isEmpty{
                            
                            uhfButtonIsActive = false
                            uhfScanData = newValue
                            keyboardContext.textDocumentProxy.insertText(newValue)
                            
                    }
                }
                
                Divider()
                
                 Button("Barcode") {
                 Task {
                 do {
                     barcodeButtonIsActive.toggle()
                     while(barcodeButtonIsActive == true){
                         try await scanner.startBarcodeScanning()
                         try await Task.sleep(nanoseconds: 9000000000)
                         try scanner.ipc.barcodeStopScan()
                         barcodeButtonIsActive = false
                     }
                 } catch {
                 print("Scanning error: \(error.localizedDescription)")
                 }
                 }
                 }
                 .disabled(scannerNotConnected)
                 .padding(5)
                 .foregroundStyle(barcodeButtonIsActive ? .white : .black)
                 .animation(.easeInOut.delay(0.4), value: barcodeButtonIsActive)
                 .buttonStyle(.borderedProminent)
                 .tint(barcodeButtonIsActive ? .green : .white)
                 .animation(.easeInOut.delay(0.4), value: barcodeButtonIsActive)
                 .cornerRadius(10)
                 .shadow(
                     color: Color.gray,
                     radius: 10,
                     x: -10,
                     y: 10
                 )
                 .onChange(of: barcodeButtonIsActive){
                     if barcodeButtonIsActive == true {
                         
                     } else {
                         do{
                             try scanner.ipc.barcodeStopScan()
                         } catch {
                             print("Didn't stop the barcode module correctly")
                         }
                         
                     }
                 }
                 .onReceive(scanner.$barcodeString) { newValue in
                     if !newValue.isEmpty {
                         barcode = newValue
                         barcodeButtonIsActive = false
                         keyboardContext.textDocumentProxy.insertText(newValue)
                         
                     }
                     
                 }
                
            }
            .onChange(of: rfidButtonIsActive){
                if rfidButtonIsActive == true{
                    
                } else {
                    do{
                        try scanner.ipc.rfClose()
                    }catch{
                        print("Did not close rfid scanner")
                    }
                }
            }
            Divider()
            
        }
        .onReceive(scanner.$deviceNotConnected){ value in
            scannerNotConnected = value
            
        }
        .onAppear{
           scanner.scannerSetup()
        }
        }
        
    }
    
/*#Preview {
    unowned var thing: testing
    CustomToolbarView(coolbeans: thing)
}*/
