import Foundation

// MARK: JSONDecoder config

let apiJsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

    return jsonDecoder
}()


// MARK: JSON Response Decodable

typealias JSONResponse = [JSONEvent]

struct JSONEvent: Decodable, Identifiable {

    var id: String {
        payload.policyId
    }

    struct PolicyPayload: Decodable {
        let timestamp: Date
        let policyId: String
        let originalPolicyId: String?
        let startDate: Date?
        let endDate: Date?
        let vehicle: Vehicle?
        let cancellationType: CancellationType?
        let newEndDate: Date?
    }

    struct Vehicle: Decodable {
        let prettyVrm: String
        let make: String
        let model: String
        let variant: String?
        let color: String
        let notes: String
    }

    enum PolicyType: String, Decodable {
        case policyCreated = "policy_created"
        case policyExtension = "policy_extension"
        case policyCancelled = "policy_cancelled"
    }

    enum CancellationType: String, Decodable {
        case void
    }

    let type: PolicyType
    let payload: PolicyPayload
}
