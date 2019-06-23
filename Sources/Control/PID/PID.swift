///
public protocol PIDSignal: BinaryFloatingPoint & Clampable {
}

extension Float32: PIDSignal {}
extension Float64: PIDSignal {}
extension Float80: PIDSignal {}

//MARK:-

///
@dynamicMemberLookup
public struct PID<Signal: PIDSignal, Context> {

    ///
    public typealias Limit = ClampingRange<Signal>

    ///
    public var Kp: Signal

    ///
    public var Ki: Signal

    ///
    public var Kd: Signal

    /// Last used error (`e(t)`)
    public private(set) var error: Signal

    /// Last used target setpoint (`SP(t)`)
    public private(set) var target: Signal

    /// Last used input process variable (`PV(t)`)
    public private(set) var input: Signal

    ///
    public let limit: Limit

    ///
    public var context: Context

    /// Proportional output (control) signal
    public var proportional: Signal { P }

    /// Integral output (control) signal
    public var integral: Signal { I }

    /// Derivative output (control) signal
    public var derivative: Signal { D }

    /// Total output (control) signal
    public var output: Signal { P + I + D }

    //[Private] output (control) signal terms
    private var P: Signal
    private var I: Signal
    private var D: Signal

    ///
    @inlinable
    public subscript<T>(dynamicMember keyPath: KeyPath<Context, T>) -> T {
        return self.context[keyPath: keyPath]
    }

    ///
    @inlinable
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Context, T>) -> T {
        get { self.context[keyPath: keyPath] }
        set { self.context[keyPath: keyPath] = newValue }
    }

    ///
    @inlinable
    public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Context, T>) -> T {
        get { self.context[keyPath: keyPath] }
        set { self.context[keyPath: keyPath] = newValue }
    }

    ///
    public init(
        Kp _Kp: Signal, P _P: Signal?=nil,
        Ki _Ki: Signal, I _I: Signal?=nil,
        Kd _Kd: Signal, D _D: Signal?=nil,
        limit _limit: Limit?=nil,
        context _context: Context
    ) {
        precondition(_Kp >= 0, "Proportional coefficient must be non-negative")
        precondition(_Ki >= 0, "Integral coefficient must be non-negative")
        precondition(_Kd >= 0, "Derivative coefficient must be non-negative")

        Kp = _Kp
        Ki = _Ki
        Kd = _Kd

        P = _P ?? .zero
        I = _I ?? .zero
        D = _D ?? .zero

        input = .zero
        error = .zero
        target = .zero
        limit = _limit ?? .widest
        context = _context
    }

    ///
    @discardableResult
    public mutating func update<TimeInterval: BinaryFloatingPoint>(_ _input: Signal, target _target: Signal, dt _timeInterval: TimeInterval) -> Signal {
        precondition(_timeInterval > 0, "Time interval must be positive")

        let _dt = Signal(_timeInterval)
        defer { input = _input }

        error = _target - _input

        P = Kp * error
        I = Ki * _dt * (error + I)
        D = Kd / _dt * (_input - input)

        return output
    }
}

//MARK:-

extension PID where Context == Void {

    public init(
        Kp: Signal, P: Signal?=nil,
        Ki: Signal, I: Signal?=nil,
        Kd: Signal, D: Signal?=nil,
        limit: Limit?=nil
    ) {
        self.init(
            Kp: Kp, P: P,
            Ki: Ki, I: I,
            Kd: Kd, D: D,
            limit: limit,
            context: ()
        )
    }
}
