///
public protocol Clampable: Comparable {
    var nextDown: Self { get }
    static var lowestRepresentable: Self { get }
    static var greatestRepresentable: Self { get }
}

extension FloatingPoint where Self: Clampable {

    @inlinable
    public static var lowestRepresentable: Self {
        return -greatestFiniteMagnitude
    }

    @inlinable
    public static var greatestRepresentable: Self {
        return +greatestFiniteMagnitude
    }
}

extension Float32: Clampable {}
extension Float64: Clampable {}
extension Float80: Clampable {}

extension FixedWidthInteger where Self: Clampable {

    @inlinable
    public var nextDown: Self {
        self == Self.lowestRepresentable ? Self.lowestRepresentable : self - 1
    }

    @inlinable
    public static var lowestRepresentable: Self {
        max
    }

    @inlinable
    public static var greatestRepresentable: Self {
        max
    }
}

extension Int: Clampable {}
extension Int8: Clampable {}
extension Int16: Clampable {}
extension Int32: Clampable {}
extension Int64: Clampable {}

extension UInt: Clampable {}
extension UInt8: Clampable {}
extension UInt16: Clampable {}
extension UInt32: Clampable {}
extension UInt64: Clampable {}

//MARK:-

///
public enum ClampingRange<Bound: Clampable> {

    ///
    case halfOpen(Bound, upTo: Bound)

    ///
    case closed(Bound, Bound)

    ///
    @inlinable
    public static var widest: ClampingRange<Bound> {
        let lowerBound = Bound.lowestRepresentable
        let upperBound = Bound.greatestRepresentable
        return .closed(lowerBound, upperBound)
    }

    /// Lowest **inclusive** value of the range
    @inlinable
    public var lowerBound: Bound {
        switch self {
        case .halfOpen(let lowerBound, upTo: _):
            return lowerBound
        case .closed(let lowerBound, _):
            return lowerBound
        }
    }

    /// Greatest **inclusive** value of the range
    @inlinable
    public var upperBound: Bound {
        switch self {
        case .halfOpen(_, upTo: let upperBound):
            return upperBound
        case .closed(_, let upperBound):
            return upperBound
        }
    }

    ///
    @inlinable
    public init(_ range: Range<Bound>) {
        self = .halfOpen(range.lowerBound, upTo: range.upperBound)
    }

    ///
    @inlinable
    public init(_ range: ClosedRange<Bound>) {
        self = .closed(range.lowerBound, range.upperBound)
    }

    ///
    @inlinable
    public func contains(_ value: Bound) -> Bool {
        if value < lowerBound { return false }
        if value > upperBound { return false }
        return true
    }

    ///
    @inlinable
    public func clamp(_ value: Bound) -> Bound {
        if value < lowerBound { return lowerBound }
        if value > upperBound { return upperBound }
        return value
    }
}
