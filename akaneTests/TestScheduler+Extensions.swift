import Foundation
import RxSwift
import RxCocoa
import RxTest

extension TestScheduler {
    func record<O: ObservableConvertibleType>(source: O) -> TestableObserver<O.E> {
        let observer = self.createObserver(O.E.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }
}
