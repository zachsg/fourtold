//
//  SettingsUserInfoGroup.swift
//  fourtold
//
//  Created by Zach Gottlieb on 12/5/23.
//

import SwiftUI

struct SettingsUserInfoGroup: View {
    @AppStorage(userAgeKey) var userAge: Int = 30
    @AppStorage(userGenderKey) var userGender: FTGender = .female
    
    var body: some View {
        Section {
            Stepper(value: $userAge, in: 16...100) {
                Label(
                    title: {
                        HStack {
                            Text("Age:")
                            
                            Text(userAge, format: .number)
                                .bold()
                            
                            Text("yrs")
                                .font(.footnote)
                        }
                    },
                    icon: {
                        Image(systemName: userSystemImage)
                    }
                )
            }
            
            Picker("I am", selection: $userGender) {
                ForEach(FTGender.allCases, id: \.self) { gender in
                    Text(gender.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
        } header: {
            Text("My Info")
        } footer: {
            Text("This info helps us personalize recommendations and fitness scores.")
        }
    }
}

#Preview {
    SettingsUserInfoGroup()
}
