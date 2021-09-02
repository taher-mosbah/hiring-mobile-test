//
//  ModelTests.swift
//  ModelTests
//
//  Created by Mohamed Mosbah on 02/09/2021.
//

import Foundation
import XCTest
@testable import CuvvaTechTest

class ModelTests: XCTestCase {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }()

    let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

        return jsonDecoder
    }()

    let createdFixture =
    """
        [
          {
            "type": "policy_created",
            "payload": {
              "timestamp": "2021-08-16T07:05:04.820Z",
              "policy_id": "dev_pol_0000003",
              "start_date": "2021-08-16T07:05:04.820Z",
              "end_date": "2021-08-16T08:05:04.820Z",
              "vehicle": {
                "prettyVrm": "MA77 GRO",
                "make": "Volkswagen",
                "model": "Polo",
                "variant": "SE 16V",
                "color": "Silver",
                "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non."
              }
            }
          }
        ]
    """

    let extendedFixture =
    """
        [
            {
              "type": "policy_extension",
              "payload": {
                "timestamp": "2020-04-20T00:15:30.000Z",
                "policy_id": "dev_pol_0000005",
                "original_policy_id": "dev_pol_0000004",
                "start_date": "2020-04-20T00:15:30.000Z",
                "end_date": "2020-04-20T05:15:30.000Z"
              }
            }
        ]
    """

    let cancelledFixture =
    """
        [
            {
              "type": "policy_cancelled",
              "payload": {
                "timestamp": "2020-05-11T10:45:48.669Z",
                "policy_id": "dev_pol_0000006",
                "cancellation_type": "void",
                "new_end_date": null
              }
            }
        ]
    """

    func testDecodingCreation() throws {
        let event = try decoder.decode([JSONEvent].self, from: createdFixture.data(using: .utf8)!).first!

        XCTAssertNotNil(event)
        XCTAssertNotEqual(event.id, "")
        XCTAssertEqual(event.type, .policyCreated)
        XCTAssertEqual(dateFormatter.string(from: event.payload.timestamp), "2021-08-16T07:05:04.820Z")
        XCTAssertEqual(event.payload.policyId, "dev_pol_0000003")
        XCTAssertEqual(dateFormatter.string(from: event.payload.startDate!), "2021-08-16T07:05:04.820Z")
        XCTAssertEqual(dateFormatter.string(from: event.payload.endDate!), "2021-08-16T08:05:04.820Z")
        XCTAssertEqual(event.payload.vehicle!.prettyVrm, "MA77 GRO")
        XCTAssertEqual(event.payload.vehicle!.make, "Volkswagen")
        XCTAssertEqual(event.payload.vehicle!.model, "Polo")
        XCTAssertEqual(event.payload.vehicle!.variant, "SE 16V")
        XCTAssertEqual(event.payload.vehicle!.color, "Silver")
        XCTAssertEqual(event.payload.vehicle!.notes, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non.")
    }

    func testDecodingExtension() throws {
        let event = try decoder.decode([JSONEvent].self, from: extendedFixture.data(using: .utf8)!).first!

        XCTAssertNotEqual(event.id, "")
        XCTAssertEqual(event.type, .policyExtension)
        XCTAssertEqual(dateFormatter.string(from: event.payload.timestamp), "2020-04-20T00:15:30.000Z")
        XCTAssertEqual(event.payload.policyId, "dev_pol_0000005")
        XCTAssertEqual(event.payload.originalPolicyId, "dev_pol_0000004")
        XCTAssertEqual(dateFormatter.string(from: event.payload.startDate!), "2020-04-20T00:15:30.000Z")
        XCTAssertEqual(dateFormatter.string(from: event.payload.endDate!), "2020-04-20T05:15:30.000Z")
    }

    func testDecodingCancellation() throws {
        let event = try decoder.decode([JSONEvent].self, from: cancelledFixture.data(using: .utf8)!).first!

        XCTAssertNotEqual(event.id, "")
        XCTAssertEqual(event.type, .policyCancelled)
        XCTAssertEqual(dateFormatter.string(from: event.payload.timestamp), "2020-05-11T10:45:48.669Z")
        XCTAssertEqual(event.payload.policyId, "dev_pol_0000006")
        XCTAssertEqual(event.payload.cancellationType!.rawValue, "void")
        XCTAssertNil(event.payload.newEndDate)
    }
}
