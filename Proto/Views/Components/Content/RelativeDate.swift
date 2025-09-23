//
//  RelativeDate.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/W7x7IvJBDsSw43zcIKMJeR/%E2%9D%96-Mobile-Design-System?node-id=6544-64660&t=3gJqoSz2w5aNwUCA-11
//  https://www.figma.com/design/W7x7IvJBDsSw43zcIKMJeR/%E2%9D%96-Mobile-Design-System?node-id=4485-11134&t=3gJqoSz2w5aNwUCA-11
//

import SwiftUI

// MARK: - Relative Date Variants
enum RelativeDateVariant {
    case messages    // Full format with times for recent dates
    case abbreviated // Short format for feeds and metadata
}

struct RelativeDate: View {
    let date: Date
    let variant: RelativeDateVariant
    
    init(date: Date, variant: RelativeDateVariant = .abbreviated) {
        self.date = date
        self.variant = variant
    }
    
    var body: some View {
        Text(formattedDate)
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.secondary)
    }
    
    // MARK: - Date Formatting Logic
    
    private var formattedDate: String {
        let now = Date()
        let calendar = Calendar.current
        
        // Check if date is in the future
        if date > now {
            return formatFutureDate(now: now, calendar: calendar)
        } else {
            return formatPastDate(now: now, calendar: calendar)
        }
    }
    
    private func formatFutureDate(now: Date, calendar: Calendar) -> String {
        let timeInterval = date.timeIntervalSince(now)
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / 86400)
        let weeks = Int(timeInterval / 604800)
        
        // Check if it's in the current year
        let currentYear = calendar.component(.year, from: now)
        let dateYear = calendar.component(.year, from: date)
        let isCurrentYear = dateYear == currentYear
        
        switch variant {
        case .messages:
            // Future dates in messages variant
            if minutes < 60 {
                return "in \(minutes)m"
            } else if hours < 24 {
                return "in \(hours)h"
            } else if days <= 6 {
                return "in \(days)d"
            } else if weeks <= 3 {
                return "in \(weeks)w"
            } else {
                return formatDateString(includeYear: !isCurrentYear)
            }
            
        case .abbreviated:
            // Future dates in abbreviated variant
            if minutes < 60 {
                return "in \(minutes)m"
            } else if hours < 24 {
                return "in \(hours)h"
            } else if days <= 6 {
                return "in \(days)d"
            } else if weeks <= 3 {
                return "in \(weeks)w"
            } else {
                return formatDateString(includeYear: !isCurrentYear)
            }
        }
    }
    
    private func formatPastDate(now: Date, calendar: Calendar) -> String {
        let timeInterval = now.timeIntervalSince(date)
        let seconds = Int(timeInterval)
        let minutes = Int(timeInterval / 60)
        let hours = Int(timeInterval / 3600)
        let days = Int(timeInterval / 86400)
        let weeks = Int(timeInterval / 604800)
        
        // Check if it's in the current year
        let currentYear = calendar.component(.year, from: now)
        let dateYear = calendar.component(.year, from: date)
        let isCurrentYear = dateYear == currentYear
        
        switch variant {
        case .messages:
            // Past dates in messages variant
            if seconds < 60 {
                return "Just now"
            } else if minutes < 60 {
                return "\(minutes)m"
            } else if hours < 24 {
                return "\(hours)h"
            } else if days == 1 {
                // Yesterday with time
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                return "Yesterday, \(timeFormatter.string(from: date))"
            } else if days <= 6 {
                return "\(days)d"
            } else if weeks <= 3 {
                return "\(weeks)w"
            } else {
                return formatDateString(includeYear: !isCurrentYear)
            }
            
        case .abbreviated:
            // Past dates in abbreviated variant
            if seconds < 60 {
                return "Just now"
            } else if minutes < 60 {
                return "\(minutes)m"
            } else if hours < 24 {
                return "\(hours)h"
            } else if days <= 6 {
                return "\(days)d"
            } else if weeks <= 3 {
                return "\(weeks)w"
            } else {
                return formatDateString(includeYear: !isCurrentYear)
            }
        }
    }
    
    private func formatDateString(includeYear: Bool) -> String {
        let formatter = DateFormatter()
        if includeYear {
            formatter.dateFormat = "MMM d, yyyy"
        } else {
            formatter.dateFormat = "MMM d"
        }
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    VStack(alignment: .leading, spacing: 16) {
        // Messages variant examples
        VStack(alignment: .leading, spacing: 8) {
            Text("Messages Variant")
                .font(.headline)
            
            Group {
                RelativeDate(date: Date().addingTimeInterval(-30), variant: .messages)
                RelativeDate(date: Date().addingTimeInterval(-90), variant: .messages)
                RelativeDate(date: Date().addingTimeInterval(-3600), variant: .messages)
                RelativeDate(date: Date().addingTimeInterval(-86400), variant: .messages)
                RelativeDate(date: Date().addingTimeInterval(-172800), variant: .messages)
                RelativeDate(date: Date().addingTimeInterval(-1209600), variant: .messages)
                RelativeDate(date: Date().addingTimeInterval(-15552000), variant: .messages)
            }
        }
        
        Divider()
        
        // Abbreviated variant examples
        VStack(alignment: .leading, spacing: 8) {
            Text("Abbreviated Variant")
                .font(.headline)
            
            Group {
                RelativeDate(date: Date().addingTimeInterval(-30), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(-90), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(-3600), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(-86400), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(-172800), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(-1209600), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(-15552000), variant: .abbreviated)
            }
        }
        
        Divider()
        
        // Future dates examples
        VStack(alignment: .leading, spacing: 8) {
            Text("Future Dates")
                .font(.headline)
            
            Group {
                RelativeDate(date: Date().addingTimeInterval(300), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(3600), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(86400), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(604800), variant: .abbreviated)
                RelativeDate(date: Date().addingTimeInterval(15552000), variant: .abbreviated)
            }
        }
    }
    .padding()
}
