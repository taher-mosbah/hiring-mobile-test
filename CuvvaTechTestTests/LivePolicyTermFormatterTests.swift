//
//  LivePolicyTermFormatterTests.swift
//  LivePolicyTermFormatterTests
//
//  Created by Mohamed Mosbah on 02/09/2021.
//

import Foundation
import XCTest
@testable import CuvvaTechTest

class LivePolicyTermFormatterTests: XCTestCase {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter
    }()

    var policyFormatter: LivePolicyTermFormatter!

    override func setUpWithError() throws {
        policyFormatter = LivePolicyTermFormatter()
    }

    override func tearDownWithError() throws {
        policyFormatter = nil
    }

    func testDurationString() {
        XCTAssertEqual(policyFormatter.durationString(for: 3600), "1 Hour Policy")
        XCTAssertEqual(policyFormatter.durationString(for: 3600 * 2), "2 Hour Policy")
        XCTAssertEqual(policyFormatter.durationString(for: 3600 * 2 + 100), "3 Hour Policy")
        XCTAssertEqual(policyFormatter.durationString(for: 3600 * 5), "6 Hour Policy")
        XCTAssertEqual(policyFormatter.durationString(for: 3600 * 12), "12 Hour Policy")
        XCTAssertEqual(policyFormatter.durationString(for: 3600 * 23), "1 Day Policy")
        XCTAssertEqual(policyFormatter.durationString(for: 3600 * 24), "2 Day Policy")
        XCTAssertEqual(policyFormatter.durationString(for: 3600 * 24 * 2), "3 Day Policy")
    }

    func testDurationRemainingString() {
        let start = dateFormatter.date(from: "2020-05-01T11:15:20.000Z")!
        let end = dateFormatter.date(from: "2020-05-31T11:15:20.000Z")!
        let term = PolicyTerm(startDate: start, duration: end - start)

        XCTAssertEqual(policyFormatter.durationRemainingString(for: term, relativeTo: dateFormatter.date(from: "2020-05-31T11:14:19.000Z")!), "1 minute")
        XCTAssertEqual(policyFormatter.durationRemainingString(for: term, relativeTo: dateFormatter.date(from: "2020-05-01T11:15:20.000Z")!), "4 weeks, 2 days")
        XCTAssertEqual(policyFormatter.durationRemainingString(for: term, relativeTo: dateFormatter.date(from: "2020-05-11T11:14:20.000Z")!), "2 weeks, 6 days")
        XCTAssertEqual(policyFormatter.durationRemainingString(for: term, relativeTo: dateFormatter.date(from: "2020-05-30T11:14:20.000Z")!), "1 day, 1 minute")
        XCTAssertEqual(policyFormatter.durationRemainingString(for: term, relativeTo: dateFormatter.date(from: "2020-05-30T12:14:20.000Z")!), "23 hours, 1 minute")
        XCTAssertEqual(policyFormatter.durationRemainingString(for: term, relativeTo: dateFormatter.date(from: "2020-06-12T11:15:10.000Z")!), "0 minutes")
    }


    func testDurationRemainingPercent() {
        let start = dateFormatter.date(from: "2020-05-12T11:15:20.000Z")!
        let end = dateFormatter.date(from: "2020-06-12T11:15:20.000Z")!

        let term = PolicyTerm(startDate: start, duration: end - start)

        XCTAssertEqual(policyFormatter.durationRemainingPercent(for: term, relativeTo: dateFormatter.date(from: "2020-06-12T11:15:20.000Z")!), 0.0)
        XCTAssertEqual(policyFormatter.durationRemainingPercent(for: term, relativeTo: dateFormatter.date(from: "2020-05-12T11:15:20.000Z")!), 1.0)
        XCTAssertEqual(policyFormatter.durationRemainingPercent(for: term, relativeTo: dateFormatter.date(from: "2020-05-22T11:15:20.000Z")!), 0.67, accuracy: 0.01)
    }

    func testPolicyDateString() {
        XCTAssertEqual(policyFormatter.policyDateString(for: dateFormatter.date(from: "2021-08-01T08:50:10.000Z")!), "Sun, 1st Aug 2021 at 9:50am")
        XCTAssertEqual(policyFormatter.policyDateString(for: dateFormatter.date(from: "2021-08-27T08:50:10.000Z")!), "Fri, 27th Aug 2021 at 9:50am")
        XCTAssertEqual(policyFormatter.policyDateString(for: dateFormatter.date(from: "2021-08-27T18:50:10.000Z")!), "Fri, 27th Aug 2021 at 7:50pm")
    }
}
