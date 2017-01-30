//
// https://github.com/ReactiveX/RxSwift/pull/839#issuecomment-250941995
// from: https://github.com/ReactiveX/RxSwift/blob/0b66f666ba6955a51cba1ad530311b030fa4db9c/Tests/RxSwiftTests/TestImplementations/EquatableArray.swift
//

struct EquatableArray<Element: Equatable> : Equatable {
    let elements: [Element]
    init(_ elements: [Element]) {
        self.elements = elements
    }
}

func == <E: Equatable>(lhs: EquatableArray<E>, rhs: EquatableArray<E>) -> Bool {
    return lhs.elements == rhs.elements
}
