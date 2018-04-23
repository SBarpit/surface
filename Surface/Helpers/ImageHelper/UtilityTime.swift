//
//  UtilityTime.swift
//  Surface
//
//  Created by Nandini Yadav on 19/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

func printTimeElapsedWhenRunningCode <T> (title: String, operation: @autoclosure () -> T) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) seconds")
}

func getStartTime() -> CFAbsoluteTime {
    return CFAbsoluteTimeGetCurrent()
}

func printElapsedTime(title: String, startTime: CFAbsoluteTime) {
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("Time elapsed for \(title): \(timeElapsed) seconds")
}
