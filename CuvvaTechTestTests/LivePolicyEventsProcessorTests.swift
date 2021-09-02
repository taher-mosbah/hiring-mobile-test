//
//  PolicyEventsProcessorTests.swift
//  PolicyEventsProcessorTests
//
//  Created by Mohamed Mosbah on 02/09/2021.
//

import Foundation
import XCTest
@testable import CuvvaTechTest

class LivePolicyEventsProcessorTests: XCTestCase {
    let df: DateFormatter = {
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

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testRetrieveAnActivePolicy() {
        let processor = LivePolicyEventProcessor()

        let events = try! decoder.decode([JSONEvent].self, from: fixture.data(using: .utf8)!)
        processor.store(json: events)

        let policyData = processor.retrieve(for: df.date(from: "2021-09-02T17:09:43.612Z")!)
        XCTAssertEqual(policyData.activePolicies.count, 1)
        XCTAssertEqual(policyData.activePolicies.first!.term.startDate, df.date(from: "2021-09-02T17:09:43.612Z")!)
    }

    func testRetrieveWhenNoActivePolicy() {
        let processor = LivePolicyEventProcessor()

        let events = try! decoder.decode([JSONEvent].self, from: fixture.data(using: .utf8)!)
        processor.store(json: events)

        let policyData = processor.retrieve(for: df.date(from: "2022-09-02T19:09:43.612Z")!)
        XCTAssertEqual(policyData.activePolicies.count, 0)
    }

    func testRetrieveHistoricVehicles() {
        let processor = LivePolicyEventProcessor()

        let events = try! decoder.decode([JSONEvent].self, from: fixture.data(using: .utf8)!)
        processor.store(json: events)

        let policyData = processor.retrieve(for: df.date(from: "2022-09-02T19:09:43.612Z")!)
        XCTAssertEqual(policyData.historicVehicles.count, 3)
        XCTAssertEqual(policyData.historicVehicles.first!.displayVRM, "MA77 GRO")
    }

    func testExtendingAPolicyShouldUpdateTheExistingPolicy() {
        let processor = LivePolicyEventProcessor()

        let events = try! decoder.decode([JSONEvent].self, from: extensionFixture.data(using: .utf8)!)
        processor.store(json: events)

        let policyData = processor.retrieve(for: df.date(from: "2022-09-02T19:09:43.612Z")!)
        XCTAssertEqual(policyData.historicVehicles.count, 1)
        XCTAssertEqual(policyData.historicVehicles[0].displayVRM, "HA15 SIN")
        XCTAssertNil(policyData.historicVehicles[0].activePolicy)
        XCTAssertEqual(policyData.historicVehicles[0].historicalPolicies.count, 1)
        XCTAssertEqual(policyData.historicVehicles[0].historicalPolicies[0].term.duration, 5*3600*2)
        XCTAssertEqual(policyData.historicVehicles[0].historicalPolicies[0].term.startDate, df.date(from: "2020-04-19T19:15:30.000Z")!)
        XCTAssertEqual(policyData.historicVehicles[0].historicalPolicies[0].term.endDate, df.date(from: "2020-04-20T05:15:30.000Z")!)
    }

    func testCancellingAPolicyShouldUpdateTheExistingPolicy() {
        let processor = LivePolicyEventProcessor()

        let events = try! decoder.decode([JSONEvent].self, from: cancellationFixture.data(using: .utf8)!)
        processor.store(json: events)

        let policyData = processor.retrieve(for: df.date(from: "2022-09-02T19:09:43.612Z")!)
        XCTAssertEqual(policyData.historicVehicles.count, 1)
        XCTAssertEqual(policyData.historicVehicles[0].displayVRM, "RA64 ELA")
        XCTAssertNil(policyData.historicVehicles[0].activePolicy)
        XCTAssertEqual(policyData.historicVehicles[0].historicalPolicies.count, 1)
        XCTAssertEqual(policyData.historicVehicles[0].historicalPolicies.first!.term.duration, 0)
    }
}

let fixture =
"""
[
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2021-09-02T17:09:43.612Z",
      "policy_id": "dev_pol_0000003",
      "start_date": "2021-09-02T17:09:43.612Z",
      "end_date": "2021-09-02T20:09:43.612Z",
      "vehicle": {
        "prettyVrm": "MA77 GRO",
        "make": "Volkswagen",
        "model": "Polo",
        "variant": "SE 16V",
        "color": "Silver",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non."
      }
    }
  },
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2019-04-17T10:15:29.979Z",
      "policy_id": "dev_pol_0000001",
      "start_date": "2019-04-17T10:15:30.000Z",
      "end_date": "2019-04-17T11:15:30.000Z",
      "vehicle": {
        "prettyVrm": "MA77 GRO",
        "make": "Volkswagen",
        "model": "Polo",
        "variant": "SE 16V",
        "color": "Silver",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non."
      }
    }
  },
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2019-04-19T19:15:29.979Z",
      "policy_id": "dev_pol_0000002",
      "start_date": "2019-04-19T19:15:30.000Z",
      "end_date": "2019-04-20T00:15:30.000Z",
      "vehicle": {
        "prettyVrm": "MA77 GRO",
        "make": "Volkswagen",
        "model": "Polo",
        "variant": "SE 16V",
        "color": "Silver",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non."
      }
    }
  },
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2020-03-19T19:15:29.979Z",
      "policy_id": "dev_pol_0000008",
      "start_date": "2020-03-19T19:15:30.000Z",
      "end_date": "2020-03-20T00:15:30.000Z",
      "vehicle": {
        "prettyVrm": "HA15 SIN",
        "make": "Mercedes Benz",
        "model": "A35",
        "variant": "AMG",
        "color": "Mountain Grey",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      }
    }
  },
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2020-04-19T19:15:29.979Z",
      "policy_id": "dev_pol_0000004",
      "start_date": "2020-04-19T19:15:30.000Z",
      "end_date": "2020-04-20T00:15:30.000Z",
      "vehicle": {
        "prettyVrm": "HA15 SIN",
        "make": "Mercedes Benz",
        "model": "A35",
        "variant": "AMG",
        "color": "Mountain Grey",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      }
    }
  },
  {
    "type": "policy_extension",
    "payload": {
      "timestamp": "2020-04-20T00:15:30.000Z",
      "policy_id": "dev_pol_0000005",
      "original_policy_id": "dev_pol_0000004",
      "start_date": "2020-04-20T00:15:30.000Z",
      "end_date": "2020-04-20T05:15:30.000Z"
    }
  },
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2020-05-11T10:15:29.979Z",
      "policy_id": "dev_pol_0000006",
      "start_date": "2020-05-11T10:15:30.000Z",
      "end_date": "2020-05-11T11:15:30.000Z",
      "vehicle": {
        "prettyVrm": "RA64 ELA",
        "make": "Fiat",
        "model": "Doblo",
        "variant": null,
        "color": "Red",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non. Ut lobortis maximus odio nec laoreet. Phasellus congue maximus viverra. Cras ac mauris vitae leo pretium pellentesque sit amet non leo."
      }
    }
  },
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2020-05-12T10:15:29.979Z",
      "policy_id": "dev_pol_0000007",
      "start_date": "2020-05-12T10:15:30.000Z",
      "end_date": "2020-05-12T11:15:30.000Z",
      "vehicle": {
        "prettyVrm": "RA64 ELA",
        "make": "Fiat",
        "model": "Doblo",
        "variant": null,
        "color": "Red",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non. Ut lobortis maximus odio nec laoreet. Phasellus congue maximus viverra. Cras ac mauris vitae leo pretium pellentesque sit amet non leo."
      }
    }
  },
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

let extensionFixture =
"""
[
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2020-04-19T19:15:29.979Z",
      "policy_id": "dev_pol_0000004",
      "start_date": "2020-04-19T19:15:30.000Z",
      "end_date": "2020-04-20T00:15:30.000Z",
      "vehicle": {
        "prettyVrm": "HA15 SIN",
        "make": "Mercedes Benz",
        "model": "A35",
        "variant": "AMG",
        "color": "Mountain Grey",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      }
    }
  },
  {
    "type": "policy_extension",
    "payload": {
      "timestamp": "2020-04-20T00:15:30.000Z",
      "policy_id": "dev_pol_0000005",
      "original_policy_id": "dev_pol_0000004",
      "start_date": "2020-04-20T00:15:30.000Z",
      "end_date": "2020-04-20T05:15:30.000Z"
    }
  }]
"""

let cancellationFixture =
"""
[
  {
    "type": "policy_created",
    "payload": {
      "timestamp": "2020-05-11T10:15:29.979Z",
      "policy_id": "dev_pol_0000006",
      "start_date": "2020-05-11T10:15:30.000Z",
      "end_date": "2020-05-11T11:15:30.000Z",
      "vehicle": {
        "prettyVrm": "RA64 ELA",
        "make": "Fiat",
        "model": "Doblo",
        "variant": null,
        "color": "Red",
        "notes": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed quis tortor pulvinar, lacinia leo sit amet, iaculis ligula. Maecenas accumsan condimentum lectus, posuere finibus lorem sollicitudin non. Ut lobortis maximus odio nec laoreet. Phasellus congue maximus viverra. Cras ac mauris vitae leo pretium pellentesque sit amet non leo."
      }
    }
  },
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
