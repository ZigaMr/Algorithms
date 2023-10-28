import time

# Binary Search
def binary_search(arr, target):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

# Example Usage
arr = list(range(1, 10000001))  # Generate an array of size 10,000
target = 50000

start_time = time.time()
result = binary_search(arr, target)
end_time = time.time()

print(f"Binary Search: Target {target} found at index {result}")
print(f"Execution time: {end_time - start_time} seconds")
print("")
