import Foundation

struct Application: Identifiable, Codable, Equatable {
    var id: UUID
    var createdAt: Date
    var bedName: String
    var material: String
    var amountCups: Double
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), bedName: String = "", material: String = "", amountCups: Double = 0, notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.bedName = bedName
        self.material = material
        self.amountCups = amountCups
        self.notes = notes
    }
}
