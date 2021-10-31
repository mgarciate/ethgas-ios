//
//  FrequencySelectionView.swift
//  ethgas-ios
//
//  Created by mgarciate on 30/10/21.
//

import SwiftUI

struct FrequencySelectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var frequency: AlertGasFrequency
    
    var body: some View {
        NavigationView {
            List([AlertGasFrequency.once,
                  AlertGasFrequency.daily,
                  AlertGasFrequency.always], id: \.self) { item in
                Button(action: {
                    frequency = item
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(item.localized)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(Resources.Strings.Alerts.Frequency.title)
            .toolbar {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "multiply")
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(15)
                    
                }
                .padding(.horizontal)
                .frame(height: 30)
            }
        }
    }
}

struct FrequencySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FrequencySelectionView(frequency: .constant(.once))
    }
}
