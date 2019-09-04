import Foundation

class Dynamic<T> {
    var bind: (T?) -> Void = { _ in }
    
    var value: T? {
        didSet {
            bind(value)
        }
    }
    
    init(_ defaultValue: T?) {
        value = defaultValue
    }
}
