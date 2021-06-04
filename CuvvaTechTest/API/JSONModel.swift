import Foundation

// MARK: JSONDecoder config

let apiJsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()

    // TODO: Configure
 
    return jsonDecoder

}()


// MARK: JSON Response Decodable

typealias JSONResponse = [JSONEvent]

struct JSONEvent: Decodable, Identifiable {

    let id: String

    // TODO: Add remaining properties
}
