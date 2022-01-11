//
//  BlockTitle.swift
//  Gradient
//
//  Created by Brent Meyer on 1/9/22.
//

import SwiftUI

struct BlockTitle: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.system(.title))
            .fontWeight(.bold)
    }
}

struct BlockTitle_Previews: PreviewProvider {
    static var previews: some View {
        BlockTitle(label: "Heading")
    }
}
