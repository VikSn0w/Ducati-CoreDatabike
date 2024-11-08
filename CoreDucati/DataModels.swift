import Foundation

struct ModelData: Codable {
    let name: String
    let introductionYear: Int
    let deprecationYear: Int // Use `Int?` for optional deprecation year
    let logo: String
    let logourl: String
    let variants: [VariantData] // Array of models for the family
}

struct VariantData: Codable {
    let name: String
    let introductionYear: Int
    let deprecationYear: Int // Use `Int?` for optional deprecation year
    let logo: String
    let logourl: String
    let power: Float
    let engine: String
    let displacement: Float
    let cooling_system: String
    let induction: String
    let clutch: String
    let fuel_capacity: Float
    let top_speed: Float
    let dry_weight: Float
}

struct FamilyData: Codable {
    let name: String
    let logo: String
    let logourl: String
    let models: [ModelData] // Array of models for the family
}
