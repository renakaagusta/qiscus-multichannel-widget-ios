//
//  String+Extension.swift
//  QiscusMultichannelWidget
//
//  Created by Rahardyan Bisma on 30/06/20.
//

import Foundation

extension String {
    var isPDF: Bool {
        guard let urlFileExtension = self.split(separator: ".").last, urlFileExtension.lowercased() == "pdf" else {
            return false
        }
        
        return true
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
