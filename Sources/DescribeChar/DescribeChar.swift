import ArgumentParser
import TextTable

@main
struct DescribeChar: ParsableCommand {
  @Argument(help: "The character or characters to describe")
  var characters: String

  mutating func run() throws {
    let table = TextTable<(String, String)> {
      [Column("Name" <- $0.0), Column("Value" <- $0.1)]
    }

    for scalar in characters.unicodeScalars {
      var data: [(String, String)] = []

      let properties = scalar.properties

      if let name = properties.name { data.append(("Name", name)) }
      if let nameAlias = properties.nameAlias { data.append(("Name Alias", nameAlias)) }

      data.append(("Value", "Decimal: \(scalar.value), Hexadecimal: \(String(format: "%x", scalar.value))"))

      let utf8 = scalar.utf8.map { String(format: "%02x", $0) }.joined(separator: " ")
      let utf16 = scalar.utf16.map { String(format: "%04x", $0) }.joined(separator: " ")
      data.append(("Encodings", "UTF-8: \(utf8), UTF-16: \(utf16)"))

      data.append(("General Category", String(describing: properties.generalCategory)))

      let flagsString = flags(properties)
      if !flagsString.isEmpty { data.append(("Flags", flagsString)) }

      table.print(data)
    }
  }

  static let flagProperties: [(String, KeyPath<UnicodeScalar.Properties, Bool> & Sendable)] = [
    ("ASCIIHexDigit", \.isASCIIHexDigit),
    ("Alphabetic", \.isAlphabetic),
    ("BidiControl", \.isBidiControl),
    ("BidiMirrored", \.isBidiMirrored),
    ("CaseIgnorable", \.isCaseIgnorable),
    ("Cased", \.isCased),
    ("Dash", \.isDash),
    ("DefaultIgnorableCodePoint", \.isDefaultIgnorableCodePoint),
    ("Deprecated", \.isDeprecated),
    ("Diacritic", \.isDiacritic),
    ("Emoji", \.isEmoji),
    ("EmojiModifier", \.isEmojiModifier),
    ("EmojiModifierBase", \.isEmojiModifierBase),
    ("EmojiPresentation", \.isEmojiPresentation),
    ("Extender", \.isExtender),
    ("FullCompositionExclusion", \.isFullCompositionExclusion),
    ("GraphemeBase", \.isGraphemeBase),
    ("GraphemeExtend", \.isGraphemeExtend),
    ("HexDigit", \.isHexDigit),
    ("IDContinue", \.isIDContinue),
    ("IDSBinaryOperator", \.isIDSBinaryOperator),
    ("IDSTrinaryOperator", \.isIDSTrinaryOperator),
    ("IDStart", \.isIDStart),
    ("Ideographic", \.isIdeographic),
    ("JoinControl", \.isJoinControl),
    ("LogicalOrderException", \.isLogicalOrderException),
    ("Lowercase", \.isLowercase),
    ("Math", \.isMath),
    ("NoncharacterCodePoint", \.isNoncharacterCodePoint),
    ("PatternSyntax", \.isPatternSyntax),
    ("PatternWhitespace", \.isPatternWhitespace),
    ("QuotationMark", \.isQuotationMark),
    ("Radical", \.isRadical),
    ("SentenceTerminal", \.isSentenceTerminal),
    ("SoftDotted", \.isSoftDotted),
    ("TerminalPunctuation", \.isTerminalPunctuation),
    ("UnifiedIdeograph", \.isUnifiedIdeograph),
    ("Uppercase", \.isUppercase),
    ("VariationSelector", \.isVariationSelector),
    ("Whitespace", \.isWhitespace),
    ("XIDContinue", \.isXIDContinue),
    ("XIDStart", \.isXIDStart),
  ]

  func flags(_ properties: UnicodeScalar.Properties) -> String {
    var flags: [String] = []

    for (name, kp) in Self.flagProperties {
      let value = properties[keyPath: kp]
      if value {
        flags.append(name)
      }
    }

    return flags.joined(separator: ", ")
  }
}
