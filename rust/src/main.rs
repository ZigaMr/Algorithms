use std::time::Instant;

// Binary Search
fn binary_search(arr: &[i32], target: i32) -> i32 {
    let mut low = 0;
    let mut high = arr.len() as i32 - 1;
    while low <= high {
        let mid = (low + high) / 2;
        if arr[mid as usize] == target {
            return mid;
        } else if arr[mid as usize] < target {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    -1
}

fn main() {
    let arr: Vec<i32> = (1..=10000000).collect();  // Generate a Vec of size 10,000
    let target = 50000;

    let start_time = Instant::now();
    let result = binary_search(&arr, target);
    let end_time = Instant::now();

    println!("Binary Search: Target {} found at index {}", target, result);
    println!("Execution time: {:?}", end_time.duration_since(start_time));
    println!("");
}
