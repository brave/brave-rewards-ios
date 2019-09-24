// MIT License

// Copyright (c) 2019, LongShot. https://github.com/Brandon-T

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

// This file has been modified specifically to suit Brave-iOS & Brave-Rewards needs!
// IE: Anchor tag modifications, paragraph style added.

import Foundation
import UIKit

public class MiniHTMLTagParser {
	private let tags: [Tag]
	
	public init(string: String) {
		tags = Compiler.compile(tokens: Lexer.parse(string: string))
	}
	
	public func toString(with attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
		func recurse(tag: Tag) -> NSMutableAttributedString {
			if case .string(let text) = tag.value {
				return NSMutableAttributedString(string: text)
			}
			
			let result = NSMutableAttributedString()
			if case .tags(let tags) = tag.value {
				for innerTag in tags {
					let text = recurse(tag: innerTag)
					text.beginEditing()
					
					let range = NSRange(location: 0, length: text.length)
					
					switch tag.tag.lowercased() {
					case "b":
						if let font = attributes[.font] as? UIFont {
							if let descriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
								let boldFont = UIFont(descriptor: descriptor, size: font.pointSize)
								text.addAttribute(.font, value: boldFont, range: range)
							}
						}
						
					case "a":
						if var href = tag.attributes["href"] {
							if href.first == "'" || href.first == "\"" {
								href = String(href.dropFirst())
							}
							
							if href.last == "'" || href.last == "\"" {
								href = String(href.dropLast())
							}
							
							text.addAttribute(.link, value: URL(string: href) ?? "__blank__", range: range)
							break
						}
						text.addAttribute(.link, value: "__blank__", range: range)
						
					case "u":
						text.addAttribute(.underlineStyle, value: NSUnderlineStyle.single, range: range)
						
					case "p":
						text.addAttribute(.paragraphStyle, value: attributes[.paragraphStyle] ?? NSParagraphStyle.default, range: range)
						
					default:
						break
					}
					
					text.endEditing()
					result.append(text)
				}
			}
			return result
		}
		
		let result = NSMutableAttributedString()
		tags.map({ recurse(tag: $0) }).forEach({ result.append($0) })
		result.addAttributes(attributes, range: NSRange(location: 0, length: result.length))
		return result
	}
	
	private struct Token {
		let kind: Kind
		let attributes: [String: String]
		let value: String
		
		enum Kind {
			case tag
			case text
		}
	}

	private struct Tag {
		let tag: String
		let value: Value
		let attributes: [String: String]
		
		indirect enum Value {
			case string(String)
			case tags([Tag])
		}
	}
	
	private class Lexer {
		public static func parse(string: String) -> [Token] {
			var tokensFound = [Token]()
			var currentText = ""
			var count = -1
			var parsingTag = false
			var tagDepth = 0
			
			for c in string {
				count += 1
				if parsingTag {
					if c == "<" {
						tagDepth += 1
					}
					
					if tagDepth == 0 {
						currentText += String(c)
					}
					
					if c == ">" && tagDepth == 0 {
						currentText = String(currentText.dropFirst().dropLast())
						
						var attributes = [String: String]()
						for c in currentText.components(separatedBy: " ") {
							let components = c.components(separatedBy: "=")
							if components.count > 1 {
								attributes[components[0]] = components[1]
							}
						}
						
						tokensFound.append(Token(kind: .tag,
												 attributes: attributes,
												 value: currentText.components(separatedBy: " ")[0].components(separatedBy: "=")[0]))
						parsingTag = false
						currentText = ""
						continue
					} else if c == ">" {
						tagDepth -= 1
					}
				} else {
					let n1 = string[string.index(string.startIndex, offsetBy: count)]
					let n2 = string[string.index(string.startIndex, offsetBy: count)]
					if c == "<" && (!(n1 == "<" && n2 == ">")) {
						tagDepth = 0
						tokensFound.append(Token(kind: .text,
												 attributes: [:],
												 value: currentText))
						currentText = "<"
						parsingTag = true
						continue
					}
					
					currentText += String(c)
				}
			}
			tokensFound.append(Token(kind: .text,
									 attributes: [:],
									 value: currentText))
			return tokensFound
		}
	}
	
	private class Compiler {
		static func compile(tokens: [Token]) -> [Tag] {
			return Compiler.compile(tokens: tokens).tags
		}
		
		private struct Output {
			let tags: [Tag]
			let count: Int
		}
		
		private static func compile(tokens: [Token], depth: Int = 0) -> Output {
			var output = [Tag]()
			var counted = 0
			var skip = 0
			let name = depth > 0 ? tokens[0].value : ""
			var bump = [Token(kind: .text, attributes: [:], value: "")] + tokens
			
			for token in tokens {
				counted += 1
				bump = Array(bump[1..<bump.count])
				
				if skip > 0 {
					skip -= 1
					continue
				}
				
				if depth > 0 && bump.count == tokens.count {
					continue
				}
				
				if depth > 0 && token.value == "/" + name {
					break
				}
				
				if token.kind == .text {
					output.append(Tag(tag: "",
									  value: .string(token.value),
									  attributes: [:]))
				} else {
					let result = compile(tokens: bump, depth: depth + 1)
					skip = result.count
					output.append(Tag(tag: token.value,
									  value: .tags(result.tags),
									  attributes: token.attributes))
				}
			}
			
			return depth > 0 ? Output(tags: output, count: counted - 1) : Output(tags: output, count: 0)
		}
	}
}
