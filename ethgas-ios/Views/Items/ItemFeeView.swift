//
//  ItemFeeView.swift
//  ethgas-ios
//
//  Created by mgarciate on 5/11/21.
//

import SwiftUI

struct ItemFeeView: View {
    let data: ItemFee
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("\(data.title) -")
                Text("\(data.gasLimit)")
                    .foregroundColor(.gray)
            }
            LazyVGrid(columns: columns, spacing: 20) {
                VStack(spacing: 5) {
                    Text(Resources.Strings.Common.Speed.fastest.uppercased())
                    Text("$\(String(format: "%.2f", (Double(data.gasLimit * data.fastest) / 1000000000) * data.ethusd))")
                        .bold()
                }
                .foregroundColor(.pink)
                VStack(spacing: 5) {
                    Text(Resources.Strings.Common.Speed.fast.uppercased())
                    Text("$\(String(format: "%.2f", (Double(data.gasLimit * data.fast) / 1000000000) * data.ethusd))")
                        .bold()
                }
                .foregroundColor(.blue)
                VStack(spacing: 5) {
                    Text(Resources.Strings.Common.Speed.standard.uppercased())
                    Text("$\(String(format: "%.2f", (Double(data.gasLimit * data.average) / 1000000000) * data.ethusd))")
                        .bold()
                }
                .foregroundColor(.green)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
        }
    }
}

struct ItemFeeView_Previews: PreviewProvider {
    static var previews: some View {
        ItemFeeView(data: ItemFee(title: "ETH Transfer", gasLimit: 21000, fastest: 100, fast: 50, average: 25, ethusd: 4000))
            .previewLayout(.fixed(width: 340, height: 100))
    }
}
