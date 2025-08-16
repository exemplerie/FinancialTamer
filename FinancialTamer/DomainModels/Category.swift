import Foundation

enum Direction {
    case income
    case outcome
}

struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    let emoji: Character
    let isIncome: Bool
    
    var direction: Direction {
        isIncome ? .income : .outcome
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case emoji
        case isIncome
    }
    
    init(id: Int, name: String, emoji: Character, isIncome: Bool) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isIncome = isIncome
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.isIncome = try container.decode(Bool.self, forKey: .isIncome)
        
        let emojiRaw = try container.decode(String.self, forKey: .emoji)
        guard let firstChar = emojiRaw.first else {
            throw DecodingError.dataCorruptedError(forKey: .emoji, in: container, debugDescription: "No emoji")
        }
        self.emoji = firstChar
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(String(self.emoji), forKey: .emoji)
        try container.encode(self.direction == .income, forKey: .isIncome)
    }
}
