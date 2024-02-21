//
//  RichTextViewComponent+Paragraph.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-01-17.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the paragraph style.
    var richTextParagraphStyle: NSMutableParagraphStyle? {
        richTextAttribute(.paragraphStyle)
    }

    /// Set the paragraph style.
    ///
    /// > Todo: The function currently can't handle multiple
    /// selected paragraphs. If many paragraphs are selected,
    /// it will only affect the first one.
    func setRichTextParagraphStyle(_ style: NSParagraphStyle) {
        defer { richTextAlignment = RichTextAlignment(style.alignment) }

        let range: NSRange
        if multipleSelectedLines() {
            range = safeRange(for: selectedRange)
        } else {
            range = lineRange(for: selectedRange)
        }
        guard range.length > 0 else {
            setRichTextAttribute(.paragraphStyle, to: style)
            return
        }
        #if os(watchOS)
        setRichTextAttribute(.paragraphStyle, to: style, at: range)
        #else
        textStorageWrapper?.addAttribute(.paragraphStyle, value: style, range: range)
        #endif
    }

    private func multipleSelectedLines() -> Bool {
        guard let selectedText = textStorageWrapper?.attributedSubstring(from: selectedRange) else { return false }
        let selectedLines = selectedText.string.components(separatedBy: .newlines)

        return selectedLines.count > 1
    }
}
