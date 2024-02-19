//
//  wheather button.swift
//  Weather Ui Test
//
//  Created by Sebastian Ternes on 10.02.24.
//

import Foundation
import SwiftUI

struct weatherButton: View {
    var text : String
    var textColor : Color
    var backroundColor : Color
    
    var body: some View {
        Text(text)
            .frame (width: 280, height: 50)
            .background(backroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold))
            .cornerRadius(10)
            .shadow(radius: 30)
    }
}


