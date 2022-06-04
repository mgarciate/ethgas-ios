//
//  HotView.swift
//  ethgas-ios
//
//  Created by mgarciate on 23/03/2021.
//

import SwiftUI

struct HotView<ViewModel>: View where ViewModel: HotViewModelProtocol {
    @Binding var actionSheet: MainActionSheet?
    @StateObject var viewModel: ViewModel
    
    @State private var isPopupPresented = false
    @State private var selectedEntry: HotEntry?
    
    let rows = [
        GridItem(.fixed(50)),
        GridItem(.fixed(50))
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text(Resources.Strings.Common.appName)
                        .font(Font.title3.bold())
                    Spacer()
                    Button(action: {
                        actionSheet = nil
                    }) {
                        Image(systemName: "multiply")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(Color("White"))
                            .background(Color("Black"))
                            .cornerRadius(15)
                    }
                    .frame(height: 30)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                Picker(selection: $viewModel.typeSelected.onChange(viewModel.valueSelected), label: Text(Resources.Strings.Alerts.gasType)) {
                    Text(AlertGasType.fastest.localized.uppercased()).tag(0)
                    Text(AlertGasType.fast.localized.uppercased()).tag(1)
                    Text(AlertGasType.standard.localized.uppercased()).tag(2)
                }
                .padding(.horizontal)
                .padding(.top, -5)
                .padding(.bottom, 0)
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                if !viewModel.hotEntries.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 1) {
                            HStack(spacing: 1) {
                                Text("")
                                    .frame(width: 60)
                                Text("\(startDate())")
                                Rectangle()
                                    .frame(height: 1)
                                    .padding(.horizontal, 5)
                                Text(Resources.Strings.Hot.today)
                            }
                            ForEach(0..<24, id: \.self) { index in
                                HStack(spacing: 1) {
                                    Text("\(String(format: "%02d", index)):00")
                                        .frame(width: 60)
                                    ForEach((0..<7).reversed(), id: \.self) { j in
                                        Button(action: {
                                            if let value = viewModel.hotEntries[IndexPath(row: index, section: j)] {
                                                selectedEntry = value
                                                isPopupPresented = true
                                            }
                                        }) {
                                            ZStack {
                                                if let value = viewModel.hotEntries[IndexPath(row: index, section: j)], let hotEntry = value {
                                                    Color.red.opacity(hotEntry.alpha)
                                                    Text("\(hotEntry.value)")
                                                        .foregroundColor(Color("Black"))
                                                } else {
                                                    Color.clear
                                                    Text("")
                                                }
                                            }
                                            .cornerRadius(4.0)
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                                        }
                                    }
                                }
                            }
                            HStack(spacing: 1) {
                                Text("")
                                    .frame(width: 60)
                                Text("\(startDate())")
                                Rectangle()
                                    .frame(height: 1)
                                    .padding(.horizontal, 5)
                                Text(Resources.Strings.Hot.today)
                            }
                        }
                        .padding([.horizontal, .bottom], 10)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
            if $isPopupPresented.wrappedValue {
                ZStack {
                    Color("White")
                    VStack {
                        HStack {
                            Text("\(selectedEntry?.entry.dateString ?? "")")
                            Spacer()
                        }
                        .foregroundColor(Color("Black"))
                        .padding(.bottom, 2)
                        HStack {
                            HStack {
                                Text(Resources.Strings.Hot.Popup.gasPrice)
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.red.opacity(selectedEntry?.alpha ?? 0.0))
                            }
                            Spacer()
                            Text(Resources.Strings.Hot.Popup.gwei)
                        }
                        .padding(.bottom, 2)
                        .foregroundColor(Color("Gray"))
                        HStack {
                            Text(Resources.Strings.Common.Speed.fastest)
                            Spacer()
                            if let value = selectedEntry?.entry.fastest {
                                Text("\(value)")
                            }
                        }
                        .foregroundColor(Color("Black"))
                        HStack {
                            Text(Resources.Strings.Common.Speed.fast)
                            Spacer()
                            if let value = selectedEntry?.entry.fast {
                                Text("\(value)")
                            }
                        }
                        .foregroundColor(Color("Black"))
                        HStack {
                            Text(Resources.Strings.Common.Speed.standard)
                            Spacer()
                            if let value = selectedEntry?.entry.average {
                                Text("\(value)")
                            }
                        }
                        .foregroundColor(Color("Black"))
                        Spacer()
                        VStack(alignment: .center) {
                            Button(action: {
                                isPopupPresented = false
                            }, label: {
                                Text(Resources.Strings.Common.close)
                            })
                        }
                    }.padding()
                }
                .frame(width: 300, height: 200)
                .cornerRadius(20).shadow(radius: 20)
            }
        }
        .onDisappear() {
            viewModel.removeObserver()
        }
    }
    
    private func startDate() -> String {
        guard let date = Calendar.current.date(byAdding: .day, value: -6, to: Date()) else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM dd" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
}

struct HotView_Previews: PreviewProvider {
    static var previews: some View {
        HotView<MockHotViewModel>(actionSheet: .constant(.hot), viewModel: MockHotViewModel())
    }
}

fileprivate extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
