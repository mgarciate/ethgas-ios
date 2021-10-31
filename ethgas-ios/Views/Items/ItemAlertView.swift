//
//  ItemAlertView.swift
//  ethgas-ios
//
//  Created by mgarciate on 13/08/2021.
//

import SwiftUI

struct ItemAlertView: View {
    let alert: AlertGas
    
    var body: some View {
        HStack {
            Image(systemName: alert.direction == .up ? "arrow.up" : "arrow.down")
                .foregroundColor(alert.direction == .up ? .green : .red)
            Text("\(alert.value)")
                .frame(minWidth: 40)
                .foregroundColor(.red)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 1)
            Text(alert.type.localized.uppercased())
                .foregroundColor(.gray)
            Spacer()
            Text(alert.frequency.localized)
                .foregroundColor(.gray)
                .padding(2)
                .border(Color.gray, width: 1)
                .font(.caption)
        }
    }
}

struct ItemAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ItemAlertView(alert: AlertGas(value: 80, direction: AlertGasDirection.down, type: .standard, frequency: .once))
            .previewLayout(.fixed(width: 340, height: 50))
    }
}
