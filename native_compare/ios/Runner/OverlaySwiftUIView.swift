// Copied from https://github.com/flutter/platform_tests/blob/master/ios_widget_catalog_compare/ios/Runner/OverlaySwiftUIView.swift

// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import SwiftUI
import UIKit

@available(iOS 16.0, *)
struct OverlaySwiftUIView: View {
    @ObservedObject var controller: OverlayFlutterViewController

    var controlDictionary: [String: (String, AnyView)] {
        [
            "Item": (
                "Item",
                AnyView(SingleItemView(variant: .item))
            ),
            "ItemWithIcon": (
                "ItemWithIcon",
                AnyView(SingleItemView(variant: .itemWithIcon))
            ),
            "ItemOverflow": (
                "ItemOverflow",
                AnyView(SingleItemView(variant: .itemOverflow))
            ),
            "ItemWithIconOverflow": (
                "ItemWithIconOverflow",
                AnyView(SingleItemView(variant: .itemWithIconOverflow))
            ),
            "Dividers": (
                "Dividers",
                AnyView(DividersView())
            ),
            "Pickers": (
                "Pickers",
                AnyView(PickerView())
            ),
        ]
    }

    var body: some View {
        (controlDictionary[controller.controlKey]?.1 ?? AnyView(Text("Nothing Selected")))
            .frame(maxWidth: .infinity, maxHeight: .infinity).edgesIgnoringSafeArea(.all)
    }
}

// MARK: Single item menus

enum SingleItemViewVariant {
    case item, itemOverflow, itemWithIcon, itemWithIconOverflow
}

@available(iOS 16.0, *)
struct SingleItemView: View {
    let variant: SingleItemViewVariant

    var body: some View {
        Menu("Button") {
            button
        }
        .buttonStyle(.borderedProminent)

    }

    @ViewBuilder
    var button: some View {
        switch variant {
        case .item:
            Button("Item", action: {})
        case .itemOverflow:
            Button("012345678901234657890123456789012345678901234657890123456789", action: {})
        case .itemWithIcon:
            Button(action: {}, label: {
                Label("ItemWithIcon", systemImage: "star")
            })
        case .itemWithIconOverflow:
            Button(action: {}, label: {
                Label("012345678901234657890123456789", systemImage: "star")
            })
        }
    }
}


@available(iOS 16.0, *)
struct DividersView: View {
    var body: some View {
        Menu("Button") {
            Button("Item", action: {})
            Button("Item", action: {})
            Divider()
            Button("Item", action: {})
        }
        .buttonStyle(.borderedProminent)
    }
}

@available(iOS 16.0, *)
struct PickerView: View {
    @State private var selection = "Item1"
    let values = ["Value1", "Value2", "Value3"]
    
    var body: some View {
        Picker("Picker", selection: $selection) {
            ForEach(values, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .buttonStyle(.borderedProminent)
    }
}
