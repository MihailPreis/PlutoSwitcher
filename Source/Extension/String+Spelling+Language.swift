//
//  String+Spelling+Language.swift
//  PlutoSwitcher
//
//  Created by Mike Price on 22.04.2021.
//

import AppKit

extension String {
	private static let cyrillicSymbols = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
	private static let englishSymbols = "abcdefghijklmnopqrstuvwxyz"
	private static let cyrillicQwertySymbols = Array("йцукенгшщзхъфывапролджэёячсмитьбю")
	private static let englishQwertySymbols = Array("qwertyuiop[]asdfghjkl;'\\zxcvbnm,.")

	var isCyrillic: Bool {
		removeCharacters(from: CharacterSet.letters.inverted)
			.allSatisfy({ String.cyrillicSymbols.contains($0.lowercased()) })
	}

	var isEnglish: Bool {
		removeCharacters(from: CharacterSet.letters.inverted)
			.allSatisfy({ String.englishSymbols.contains($0.lowercased()) })
	}

	var languageCode: String? {
		if isEnglish, !isCyrillic {
			return Locale.enRaw
		} else if isCyrillic, !isEnglish {
			return Locale.ruRaw
		} else {
			return nil
		}
	}

	var isReal: Bool {
		guard let language = languageCode else { return false }
		let checker = NSSpellChecker.shared
		checker.automaticallyIdentifiesLanguages = false
		guard checker.setLanguage(language) else { return false }
		return checker.checkSpelling(of: self, startingAt: 0).location == NSNotFound
	}

	func removeCharacters(from forbiddenChars: CharacterSet) -> String {
		String(self.unicodeScalars.filter({ !forbiddenChars.contains($0) }))
	}

	func translated(toRu: Bool) -> String {
		let fromArr = toRu
			? String.englishQwertySymbols
			: String.cyrillicQwertySymbols
		let toArr = toRu
			? String.cyrillicQwertySymbols
			: String.englishQwertySymbols
		return String(self.map { char in
			return fromArr.firstIndex(of: Character(char.lowercased()))
				.flatMap { ind in
					let newChar = toArr[ind]
					return Character(char.isUppercase ? newChar.uppercased() : newChar.lowercased())
				}
				?? char
		})
	}
}
