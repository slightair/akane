import Foundation
import RxSwift
import RxCocoa

final class InitialPresenter: InitialPresenterProtocol {
    private weak var view: InitialViewProtocol!
    private let interactor: InitialInteractorProtocol
    private let wireframe: InitialWireframeProtocol

    init(view: InitialViewProtocol, interactor: InitialInteractorProtocol, wireframe: InitialWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}
