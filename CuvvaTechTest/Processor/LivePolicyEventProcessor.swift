import Foundation

class LivePolicyEventProcessor: PolicyEventProcessor {
    private var allPolicies: [Policy] = []
    private var allVehicles: [Vehicle] = [] // We can use a set for better performances
    private var historicVehicles: [Vehicle] = []

    func store(json: JSONResponse) {
        for jsonEvent in json {
            let payload = jsonEvent.payload

            switch jsonEvent.type {
            case .policyCreated:
                allPolicies.append(createPolicy(payload))
            case .policyExtension:
                //   - extension : start date stays same, duration is extended to the new end time
                // Needs improvement, this supposes that Policies are unique in the array
                let policy = createPolicy(payload)
                if let index = allPolicies.firstIndex(where: { $0.id == payload.originalPolicyId }) {
                    let oldPolicy = allPolicies[index]
                    let extendedDuration = oldPolicy.term.duration + policy.term.duration
                    let extendedTerm = PolicyTerm(startDate: oldPolicy.term.startDate, duration: extendedDuration)
                    let extendedPolicy = Policy(id: policy.id, term: extendedTerm, vehicle: policy.vehicle)
                    allPolicies[index] = extendedPolicy
                }
            case .policyCancelled:
                //   - cancellation : start date stays same - duration is zero
                let policyId = payload.policyId
                if let index = allPolicies.firstIndex(where: { $0.id == policyId }) {
                    let oldPolicy = allPolicies[index]
                    let policy = createPolicy(payload, cancelledStartDate: oldPolicy.term.startDate)
                    let canceledTerm = PolicyTerm(startDate: oldPolicy.term.startDate, duration: 0)
                    let canceledPolicy = Policy(id: policy.id, term: canceledTerm, vehicle: oldPolicy.vehicle)
                    allPolicies[index] = canceledPolicy
                }
            }
        }
    }
    
    func retrieve(for: Date) -> PolicyData {
        for policy in allPolicies {
            if policy.isActive(at: `for`) {
                policy.vehicle.activePolicy = policy
                print("Active policy \(policy.id) for policy.vehicle \(policy.vehicle.displayVRM)")
            } else {
                policy.vehicle.historicalPolicies.append(policy)
                print("Added policy \(policy.id) for policy.vehicle \(policy.vehicle.displayVRM)")
            }
            if let index = allVehicles.firstIndex(where: { $0.displayVRM == policy.vehicle.displayVRM }) {
                allVehicles[index] = policy.vehicle
            }
        }

        let matchingPolicies = allPolicies.filter({ $0.isActive(at: `for`) })
        return PolicyData(activePolicies: matchingPolicies, historicVehicles: allVehicles)
    }

    // TODO: this method is not pure and is doing more than one responsibility, refactor me !
    private func createPolicy(_ payload: JSONEvent.PolicyPayload, cancelledStartDate: Date? = nil) -> Policy {
        var term: PolicyTerm?
        if let startDate = payload.startDate, let endDate = payload.endDate {
            term = PolicyTerm(startDate: startDate, duration: endDate - startDate)
        }
        if let cancelledStartDate = cancelledStartDate {
            term = PolicyTerm(startDate: cancelledStartDate, duration: 0)
        }
        var vehicle: Vehicle?
        var existingVehicles: [Vehicle] = []
        if let originalPolicyId = payload.originalPolicyId,
        let originalPolicy = allPolicies.filter({ $0.id == originalPolicyId }).first {
            existingVehicles = allVehicles.filter({ $0.displayVRM == originalPolicy.vehicle.displayVRM })
        } else {
            existingVehicles = allVehicles.filter({ $0.displayVRM == payload.vehicle?.prettyVrm ?? "-" })
        }
        if existingVehicles.count > 0 {
            vehicle = existingVehicles.first!
        } else {
            if let v = payload.vehicle {
                vehicle = Vehicle(id: v.prettyVrm, displayVRM: v.prettyVrm, makeModel: v.model)
                allVehicles.append(vehicle!)
            }
        }
        // TODO: handle nil term and nil vehicle by throwing maybe ..
        return Policy(id: payload.policyId,
                      term: term ?? PolicyTerm(startDate: Date(), duration: 0),
                      vehicle: vehicle ?? Vehicle(id: "", displayVRM: "", makeModel: ""))
    }
}
