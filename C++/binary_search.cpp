#include <iostream>
#include <vector>
#include <chrono>

// Binary Search
int binary_search(const std::vector<int>& arr, int target) {
    int low = 0;
    int high = arr.size() - 1;
    while (low <= high) {
        int mid = (low + high) / 2;
        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    return -1;
}

int main() {
    std::vector<int> arr(10000000);  // Generate a vector of size 10,000
    for (int i = 0; i < 10000000; i++) {
        arr[i] = i + 1;
    }
    int target = 50000;

    auto start_time = std::chrono::high_resolution_clock::now();
    int result = binary_search(arr, target);
    auto end_time = std::chrono::high_resolution_clock::now();

    std::cout << "Binary Search: Target " << target << " found at index " << result << std::endl;
    std::cout << "Execution time: " << std::chrono::duration_cast<std::chrono::microseconds>(end_time - start_time).count() << " microseconds" << std::endl;
}
