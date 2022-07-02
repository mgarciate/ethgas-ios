//
//  MainMiniView.swift
//  ethgas-ios
//
//  Created by mgarciate on 2/7/22.
//

import SwiftUI

struct MainMiniView: View {
    @Binding var currentData: CurrentData
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                ZStack {
                    Color.gray.opacity(0.1)
                    VStack(spacing: 4) {
                        Text("\(currentData.fastest)")
                            .font(.title2)
                            .foregroundColor(.pink)
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(height: 1)
                        VStack {
                            Text(Resources.Strings.Common.Speed.fastest.uppercased())
                            Text(Resources.Strings.Common.Speed.fastestSubtitle)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(2)
                }
                ZStack {
                    Color.gray.opacity(0.1)
                    VStack(spacing: 4) {
                        Text("\(currentData.fast)")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(height: 1)
                        VStack {
                            Text(Resources.Strings.Common.Speed.fast.uppercased())
                            Text(Resources.Strings.Common.Speed.fastSubtitle)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(2)
                }
            }
            HStack(spacing: 2) {
                ZStack {
                    Color.gray.opacity(0.1)
                    VStack(spacing: 4) {
                        Text("\(currentData.average)")
                            .font(.title2)
                            .foregroundColor(.green)
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(height: 1)
                        VStack {
                            Text(Resources.Strings.Common.Speed.standard)
                            Text(Resources.Strings.Common.Speed.standardSubtitle)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(2)
                }
                ZStack {
                    Color.gray.opacity(0.1)
                    VStack {
                        Image(systemName: "icloud.and.arrow.down")
                        Text(currentData.date, formatter: Self.dateFormat)
                        Text(currentData.date, style: .time)
                    }
                }
            }
        }
        .font(.caption)
    }
}

struct MainMiniView_Previews: PreviewProvider {
    static var previews: some View {
        MainMiniView(currentData: .constant(CurrentData.dummyData))
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
