//
//  RestItemView.swift
//  fourtoldwatch Watch App
//
//  Created by Zach Gottlieb on 3/26/24.
//

import SwiftUI

struct RestItemView: View {
    var activity: any FTActivity

    var moodChange: Int {
        activity.endMood.differentThan(mood: activity.startMood)
    }

    var activityCategory: (title: String, systemImage:String) {
        if activity is FTMeditate {
            return ("Meditate", meditateSystemImage)
        } else if activity is FTRead {
            return ("Read", readSystemImage)
        } else if activity is FTBreath {
            return ("Breathe", breathSystemImage)
        } else {
            return ("Unknown", "")
        }
    }

    var duration: Int {
        var d = 0

        if activity is FTMeditate {
            if let meditate = activity as? FTMeditate {
                d = meditate.duration
            }
        } else if activity is FTRead {
            if let read = activity as? FTRead {
                d = read.duration
            }
        } else if activity is FTBreath {
            if let breath = activity as? FTBreath {
                d = breath.duration
            }
        }

        return d
    }

    var activityTitle: String {
        var title = ""

        if activity is FTMeditate {
            title = "Meditated for"
        } else if activity is FTRead {
            if let read = activity as? FTRead {
                if read.type == .other && read.genre == .other {
                    title = "Read for"
                } else if read.type == .other {
                    title = "Read \(read.genre.rawValue) for"
                } else if read.genre == .other {
                    title = "Read \(read.type == .article ? "an" : "a") \(read.type.rawValue) for"
                } else {
                    title = "Read a \(read.genre.rawValue) \(read.type.rawValue) for"
                }
            }
        } else if activity is FTBreath {
            if let breath = activity as? FTBreath {
                title = "\(breath.rounds) rounds of \(breath.type.rawValue) breathing"
            }
        } else {
            title = "Unkown"
        }

        return title
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: activityCategory.systemImage)
                    Text(activityCategory.title)
                }
                .foregroundStyle(.rest)

                Spacer()

                Image(systemName: activity.timeOfDay.systemImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                    .foregroundStyle(.secondary)

            }
            .font(.footnote.bold())

            HStack {
                VStack(alignment: .leading) {
                    if activity is FTBreath {
                        Text(activityTitle)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    } else {
                        Text("\(activityTitle) \(TimeInterval(duration).secondsAsTime(units: .full))")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }

                    HStack {
                        Text(activity.startMood.emoji())
                        Image(systemName: arrowSystemImage)
                        Text(activity.endMood.emoji())
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .foregroundStyle(.primary)
            }
            .padding(.top, 4)
        }
    }
}

#Preview {
    RestItemView(activity: FTActivityData.all.first!)
}
