package main

import (
	"fmt"
	"time"
)

// Binary Search
func binarySearch(arr []int, target int) int {
	low, high := 0, len(arr) - 1
	for low <= high {
		mid := (low + high) / 2
		if arr[mid] == target {
			return mid
		} else if arr[mid] < target {
			low = mid + 1
		} else {
			high = mid - 1
		}
	}
	return -1
}

func main() {
	arr := make([]int, 10000000)  // Generate an array of size 10,000
	for i := 0; i < 10000000; i++ {
		arr[i] = i + 1
	}
	target := 50000

	startTime := time.Now()
	result := binarySearch(arr, target)
	endTime := time.Now()

	fmt.Printf("Binary Search: Target %d found at index %d\n", target, result)
	fmt.Printf("Execution time: %s\n", endTime.Sub(startTime))
	fmt.Println("")
}
