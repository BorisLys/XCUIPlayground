import Foundation

struct ContactItem: Identifiable, Hashable {
    let id: String
    let name: String
    let details: String?
}
