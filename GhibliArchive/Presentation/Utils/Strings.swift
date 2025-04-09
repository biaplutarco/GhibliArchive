//
//  Strings.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Foundation

enum Strings {
    enum Onboarding {
        static let subtitle = NSLocalizedString("onboardingSubtitle", comment: "Localizable")
        static let title = NSLocalizedString("onboardingTitle", comment: "Title Localizable")
        static let buttonTitle = NSLocalizedString("onboardingButtonTitle", comment: "Localizable")
    }
    enum EmptyFavorites {
        static let title = NSLocalizedString("emptyFavoritesTitle", comment: "Localizable")
        static let message = NSLocalizedString("emptyFavoritesMessage", comment: "Localizable")
        static let buttonTitle = NSLocalizedString("emptyFavoritesButtonTitle", comment: "Localizable")
    }
    enum Favorite {
        static let addedMessage = NSLocalizedString("favoriteMessage", comment: "Localizable")
        static let removedMessage = NSLocalizedString("unfavoriteMessage", comment: "Localizable")
    }
    enum Warning {
        static let title = NSLocalizedString("warningTitle", comment: "Localizable")
        static let message = NSLocalizedString("warningMessage", comment: "Localizable")
        static let buttonTitle = NSLocalizedString("warningButtonTitle", comment: "Localizable")
    }
    enum Search {
        static let emptyMessage = NSLocalizedString("emptySearchMessage", comment: "Localizable")
    }
}
