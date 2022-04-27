//
//  Strings.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/08/2021.
//

extension Resources.Strings {
    
    struct Common {
        static let appName = "common.app.name".localized
        static let widgetName = "common.widget.name".localized
        static let signOut = "common.signOut".localized
        static let close = "common.close".localized
        
        struct Speed {
            static let fastest = "common.speed.fastest".localized
            static let fast = "common.speed.fast".localized
            static let standard = "common.speed.standard".localized
            static let fastestSubtitle = "common.speed.fastest.subtitle".localized
            static let fastSubtitle = "common.speed.fast.subtitle".localized
            static let standardSubtitle = "common.speed.standard.subtitle".localized
        }
    }
    
    struct Main {
        static let header = "main.header.text".localized
        static let signinRequired = "main.signin.required".localized
        static let _24hMax = "main.24hMax".localized
        static let _24hMin = "main.24hMin".localized
    }
    
    struct Alerts {
        static let title = "alerts.title".localized
        static let gasType = "alerts.gasType".localized
        static let inputPlaceholder = "alerts.input.placeholder".localized
        static let create = "alerts.button.create".localized
        
        struct Frequency {
            static let title = "alerts.frequency.title".localized
            static let onlyOnce = "alerts.frequency.onlyOnce".localized
            static let onceADay = "alerts.frequency.onceADay".localized
            static let always = "alerts.frequency.always".localized
        }
    }
    
    struct Charts {
        static let _24h = "charts.chart24h.description".localized
        static let _7d = "charts.chart7d.description".localized
    }
    
    struct Hot {
        static let today = "hot.chart.today".localized
        
        struct Popup {
            static let gasPrice = "hot.popup.gasPrice".localized
            static let gwei = "hot.popup.gwei".localized
        }
    }
    
    struct Widget {
        static let description = "widget.configuration.description".localized
    }
    
    struct Migration {
        struct v150 {
            static let message = "migration.150.message".localized
        }
    }
}
