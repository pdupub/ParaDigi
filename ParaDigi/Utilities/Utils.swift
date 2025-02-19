//
//  Utils.swift
//  ParaDigi
//
//  Created by Peng Liu on 2025/2/19.
//

func printQContents(cs : [QContent]?) {
    
    print("BEGIN PRINT CONTENTS +++++++++++++++++++++++++++++++")
    guard let contents = cs else {
        print("QContents is Empty")
        return
    }
    for index in 0..<contents.count{
        let content = contents[index]
        print("index: \(index) format :\(content.format)")
        if content.displayText.count > 50 {
            print("Image")
        } else {
            print(content.displayText)
        }
        
    }
    
    print("END PRINT CONTENTS +++++++++++++++++++++++++++++++")
    print("--------------------------------------------------")
}
