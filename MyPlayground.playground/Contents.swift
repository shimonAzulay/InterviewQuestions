import UIKit


// https://leetcode.com/problems/expressive-words/description/

func checkStretchy(s: String, queries: [String]) -> Int {
  var sHelper = createHelper(s)
  var result = 0
  queries.forEach { query in
    let queryHelper = createHelper(query)
    if isSubArray(queryHelper, subOf: sHelper) {
      result += 1
    }
  }
  
  return result
}

func isSubArray(_ subArray: [(Character, Int)], subOf array: [(Character, Int)]) -> Bool {
  var index = 0
  array.forEach { helper in
    if helper.0 == subArray[index].0 &&
        (helper.1 != 2 && helper.1 >= subArray[index].1) ||
        (helper.1 == 2 && helper.1 == subArray[index].1) {
      index += 1
    }
  }
  
  return index == subArray.count
}

func createHelper(_ s: String) -> [(Character, Int)] {
  var sHelper = [(Character, Int)]()
  s.forEach {
    if let (helperElement, count) = sHelper.last,
       helperElement == $0 {
      sHelper[sHelper.count - 1].1 = count + 1
    } else {
      sHelper.append(($0, 1))
    }
  }
  
  return sHelper
}


print(checkStretchy(s: "heeellooo", queries: ["hello", "hi", "helo"]))

// Given a string S and a string T, find the minimum window in S which will contain all the characters in T in complexity O(n).

func window(s: String, t: String) -> ClosedRange<Int>? {
  var minWindow: ClosedRange<Int>?
  var dictT = [Character: Int]()
  var dictS = [Character: Int]()
  let sAsArray = Array(s)
  t.forEach {
    if let count = dictT[$0] {
      dictT[$0] = count + 1
    } else {
      dictT[$0] = 1
    }
  }
  
  var left = 0
  var formed = 0
  var valid = dictT.values.count
  
  for (right, element) in s.enumerated() {
    if let count = dictS[element] {
      dictS[element] = count + 1
    } else {
      dictS[element] = 1
    }
    
    if let dictTCount = dictT[element],
       let dictSCount = dictS[element],
       dictTCount == dictSCount {
      formed += 1
    }
    
    while formed == valid,
          left <= right {
      
      minWindow = minWindow?.min(left...right) ?? (left...right)
      
      let element = sAsArray[left]
      if let count = dictS[element] {
        dictS[element] = count - 1
      }
      
      if let dictTCount = dictT[element],
         let dictSCount = dictS[element],
         dictTCount > dictSCount {
        formed -= 1
      }
      
      left += 1
    }
  }
  
  return minWindow
}

extension ClosedRange<Int> {
  func min(_ other: ClosedRange<Int>) -> ClosedRange<Int> {
    upperBound - lowerBound < other.upperBound - other.lowerBound ? self : other
  }
}

print(window(s: "ABAACBAB", t: "ACB") ?? "No Window!")


// Given Sudoku solution.

let array = [
  [1, 9, 8, 7, 6, 5, 4, 3, 2],
  [7, 6, 5, 4, 3, 2, 1, 8, 9],
  [4, 3, 2, 1, 9, 8, 6, 5, 7],
  [9, 8, 1, 5, 4, 6, 2, 7, 3],
  [2, 7, 6, 9, 1, 3, 8, 4, 5],
  [5, 4, 3, 8, 2, 7, 9, 1, 6],
  [6, 1, 7, 3, 8, 9, 5, 2, 4],
  [3, 2, 4, 6, 5, 1, 7, 9, 8],
  [8, 5, 9, 2, 7, 4, 3, 6, 1]
]

func validate(array: [[Int]]) -> Bool {
  let transposedArray = transpose(array: array)
  guard checkRows(array: array, endIdx: 9),
        checkRows(array: transposedArray, endIdx: 9),
        checkSubsqueres(array: array),
        checkSubsqueres(array: transposedArray) else {
    return false
  }
  
  return true
}

func checkSubsqueres(array: [[Int]]) -> Bool {
  print("checkSubsqueres")
  for (rawIdx, arrayItem) in array.enumerated() {
    for (colIdx, _) in arrayItem.enumerated() {
      guard rawIdx % 3 == 0, colIdx % 3 == 0, rawIdx != array.count - 1, colIdx != arrayItem.count - 1 else { continue }
      let endRow = rawIdx + 2
      let endCol = colIdx + 2
      guard checkSubsquere(array: array, rowIdxRange: (rawIdx...endRow), colIdxRange: colIdx...endCol) else { return false }
    }
  }
  
  return true
}

func checkSubsquere(array: [[Int]], rowIdxRange: ClosedRange<Int>, colIdxRange: ClosedRange<Int>) -> Bool {
  print("createSubsquere")
  let correctionRowIdx = rowIdxRange.first!
  let correctionColIdx = rowIdxRange.first!
  
  var helpArray = Array(repeating: false, count: 9)
  for rowIdx in rowIdxRange {
    for colIdx in colIdxRange {
      let idx = array[rowIdx][colIdx]
      guard helpArray[idx - 1] == false else { return false }
      helpArray[idx - 1] = true
    }
  }
  
  return true
}

func transpose(array: [[Int]]) -> [[Int]] {
  print("transpose")
  var toTranspose = array
  for (rowIdx, arrayItem) in toTranspose.enumerated() {
    for (colIdx, item) in arrayItem.enumerated() {
      guard rowIdx < colIdx else { continue }
      toTranspose[rowIdx][colIdx] = toTranspose[colIdx][rowIdx]
      toTranspose[colIdx][rowIdx] = item
    }
  }
  
  return toTranspose
}

func checkRows(array: [[Int]], endIdx: Int) -> Bool {
  print("checkRows")
  for item in array {
    guard checkArray(array: item, allowedRange: 1...endIdx) else {
      return false
    }
  }
  
  return true
}

func checkArray(array: [Int], allowedRange: ClosedRange<Int>) -> Bool {
  print("checkArray")
  let sortedArray = array.sorted()
  for idx in allowedRange {
    guard sortedArray[idx - 1] == idx else {
      return false
    }
  }
  
  return true
}

print(validate(array: array))
