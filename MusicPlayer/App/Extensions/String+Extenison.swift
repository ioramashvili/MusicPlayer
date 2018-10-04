
extension String {
    public static func makeRandomCharacter() -> String {
        let randomCharCode = (97...122).randomElement()!
        return String(UnicodeScalar(randomCharCode)!)
    }
}

