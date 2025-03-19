//
//  Extensions.swift
//  ParkFactorApp
//
//  Created by Jacob Ota on 2/28/25.
//

import SwiftUI

extension Color {
    static let parkFactorPrimary = Color(red: 0, green: 0.996, blue: 0.773)
    static let parkFactorSecondary = Color(.black)
    static let parkFactorAppPageBackground = Color(red: 0.117, green: 0.115, blue: 0.115)
}

extension Font {
    // Norwester fonts
    static let parkFactorFontTitle = Font.custom("norwester", size: 32)
    static let parkFactorFontSubtitleNorwester = Font.custom("norwester", size: 26)
    static let parkFactorFontBigTextNorwester = Font.custom("norwester", size: 22)
    static let parkFactorFontTextNorwester = Font.custom("norwester", size: 18)
    static let parkFactorFontSmallTextNorwester = Font.custom("norwester", size: 16)
    
    // Archivo Narrow fonts
    static let parkFactorFontUsername = Font.custom("ArchivoNarrow-Regular", size: 24)
    static let parkFactorFontSubtitleArchivo = Font.custom("ArchivoNarrow-Regular", size: 26)
    static let parkFactorFontText = Font.custom("ArchivoNarrow-Regular", size: 22)
    static let parkFactorFontSmallText = Font.custom("ArchivoNarrow-Regular", size: 18)
}
