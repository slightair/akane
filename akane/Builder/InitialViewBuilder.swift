import UIKit

struct InitialViewBuilder {
    static func build() -> UIViewController {
        let wireframe = InitialWireframe()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? InitialViewController else {
            fatalError("Invalid storyboard setting")
        }
        let interactor = InitialInteractor(
            service: RedditDefaultService.shared,
            authorization: RedditDefaultAuthorization.shared
        )
        let presenter = InitialPresenter(
            view: viewController,
            interactor: interactor,
            wireframe: wireframe
        )

        viewController.inject(presenter: presenter)
        wireframe.viewController = viewController

        return viewController
    }
}
