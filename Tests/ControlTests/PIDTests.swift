import XCTest
@testable import Control

final class PIDTests: XCTestCase {

    func testP() {
        var setpoint: Double
        var pid: PID<Double, Void>
        func reset() -> PID<Double, Void> { PID(Kp: 1.0, Ki: 0.0, Kd: 0.0) }

        //Positive setpoint
        pid = reset()
        setpoint = +10
        XCTAssertEqual(pid.update(+0, target: setpoint, dt: 1.0), +10)
        XCTAssertEqual(pid.update(+5, target: setpoint, dt: 1.0),  +5)
        XCTAssertEqual(pid.update(-5, target: setpoint, dt: 1.0), +15)

        //Negative setpoint
        pid = reset()
        setpoint = -10
        XCTAssertEqual(pid.update(+0,  target: setpoint, dt: 1.0), -10)
        XCTAssertEqual(pid.update(+5,  target: setpoint, dt: 1.0), -15)
        XCTAssertEqual(pid.update(-5,  target: setpoint, dt: 1.0),  -5)
        XCTAssertEqual(pid.update(-15, target: setpoint, dt: 1.0),   5)
    }

    func testI() {
        var setpoint: Double
        var pid: PID<Double, Void>
        func reset() -> PID<Double, Void> { PID(Kp: 0.0, Ki: 10.0, Kd: 0.0) }

        //Positive setpoint
        pid = reset()
        setpoint = +10
        XCTAssertEqual(pid.update(0, target: setpoint, dt: 0.1), +10)
        XCTAssertEqual(pid.update(0, target: setpoint, dt: 0.1), +20)

        //Negative setpoint
        pid = reset()
        setpoint = -10
        XCTAssertEqual(pid.update(0, target: setpoint, dt: 0.1), -10)
        XCTAssertEqual(pid.update(0, target: setpoint, dt: 0.1), -20)
    }

    func testD() {
        var setpoint: Double
        var pid: PID<Double, Void>
        func reset() -> PID<Double, Void> { PID(Kp: 0.0, Ki: 0.0, Kd: 0.1) }

        //Positive setpoint
        pid = reset()
        setpoint = +10

        //should not compute derivative when there is no previous input;
        //don't assume 0 as first input
        XCTAssertEqual(pid.update(0, target: setpoint, dt: 0.1), 0)

        XCTAssertEqual(pid.update(5,  target: setpoint, dt: 0.1),  5)
        XCTAssertEqual(pid.update(15, target: setpoint, dt: 0.1), 10)

        //Negative setpoint
        pid = reset()
        setpoint = -10

        //should not compute derivative when there is no previous input;
        //don't assume 0 as first input
        XCTAssertEqual(pid.update(0, target: setpoint, dt: 0.1), 0)

        XCTAssertEqual(pid.update(+5,  target: setpoint, dt: 0.1),   5)
        XCTAssertEqual(pid.update(-5,  target: setpoint, dt: 0.1), -10)
        XCTAssertEqual(pid.update(-15, target: setpoint, dt: 0.1), -10)
    }

    static var allTests = [
        ("testP", testP),
        ("testI", testI),
        ("testD", testD),
    ]
}
