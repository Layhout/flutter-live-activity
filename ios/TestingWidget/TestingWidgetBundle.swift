//
//  TestingWidgetBundle.swift
//  TestingWidget
//
//  Created by Layhout Chea on 16/1/25.
//

import WidgetKit
import SwiftUI

@main
struct TestingWidgetBundle: WidgetBundle {
    var body: some Widget {
        TestingWidget()
        TestingWidgetLiveActivity()
    }
}
