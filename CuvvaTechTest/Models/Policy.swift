import Foundation

class Policy: Identifiable, ObservableObject {
    
    let id: String
    var term: PolicyTerm
    let vehicle: Vehicle
    
    init(id: String, term: PolicyTerm, vehicle: Vehicle) {
        self.id = id
        self.term = term
        self.vehicle = vehicle
    }
}

struct PolicyTerm {
    var startDate: Date
    var duration: TimeInterval
}

extension PolicyTerm {
    var endDate: Date {
        startDate.addingTimeInterval(duration)
    }
}

extension Policy {
    func isActive(at: Date) -> Bool {
        at.isInRange(self.term.startDate, endDate: self.term.endDate) && !isCanceled()
    }

    func isCanceled() -> Bool {
        self.term.duration == 0
    }
}
