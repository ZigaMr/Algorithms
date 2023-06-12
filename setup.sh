#!/bin/bash

# Check if Rust is installed
if ! command -v rustc &>/dev/null; then
    echo "Rust not found. Installing..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
else
    echo "Rust is already installed."
fi

# Check if Go is installed
if ! command -v go &>/dev/null; then
    echo "Go not found. Installing..."
    curl -sSL https://golang.org/dl/go1.17.1.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -
    export PATH=$PATH:/usr/local/go/bin
else
    echo "Go is already installed."
fi

# Check if Python is installed
if ! command -v python3 &>/dev/null; then
    echo "Python 3 not found. Installing..."
    sudo apt update
    sudo apt install -y python3 python3-pip
else
    echo "Python 3 is already installed."
fi

# Create directories if they don't exist
mkdir -p rust go python

# Generate Rust algorithm script
cat <<EOF > rust/algorithm.rs
use std::time::Instant;

fn timeit<F>(f: F) -> u128
where
    F: FnOnce(),
{
    let start = Instant::now();
    f();
    let end = Instant::now();
    end.duration_since(start).as_micros()
}

fn binary_search(arr: &[i32], target: i32) -> Option<usize> {
    let mut low = 0;
    let mut high = arr.len() - 1;

    while low <= high {
        let mid = (low + high) / 2;

        if arr[mid] == target {
            return Some(mid);
        } else if arr[mid] < target {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }

    None
}

fn ternary_search(arr: &[i32], target: i32) -> Option<usize> {
    let mut low = 0;
    let mut high = arr.len() - 1;

    while low <= high {
        let mid1 = low + (high - low) / 3;
        let mid2 = high - (high - low) / 3;

        if arr[mid1] == target {
            return Some(mid1);
        } else if arr[mid2] == target {
            return Some(mid2);
        } else if arr[mid1] > target {
            high = mid1 - 1;
        } else if arr[mid2] < target {
            low = mid2 + 1;
        } else {
            low = mid1 + 1;
            high = mid2 - 1;
        }
    }

    None
}

fn main() {
    // let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let arr: Vec<i32> = (1..=100000000).collect();
    let target = 100000000/2;
    let duration = timeit(|| {
        let binary_result = binary_search(&arr, target);
        let ternary_result = ternary_search(&arr, target);
        println!("Binary Search Result: {:?}", binary_result);
        println!("Ternary Search Result: {:?}", ternary_result);
    });

    println!("Execution time: {} microseconds", duration);

}
EOF

# Generate Go algorithm script
cat <<EOF > go/algorithm.go
package main

import (
	"fmt"
	"time"
)

func timeit(f func()) int64 {
	start := time.Now()
	f()
	end := time.Now()
	return end.Sub(start).Microseconds()
}



func binarySearch(arr []int, target int) int {
    low := 0
    high := len(arr) - 1

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

func ternarySearch(arr []int, target int) int {
    low := 0
    high := len(arr) - 1

    for low <= high {
        mid1 := low + (high - low) / 3
        mid2 := high - (high - low) / 3

        if arr[mid1] == target {
            return mid1
        } else if arr[mid2] == target {
            return mid2
        } else if arr[mid1] > target {
            high = mid1 - 1
        } else if arr[mid2] < target {
            low = mid2 + 1
        } else {
            low = mid1 + 1
            high = mid2 - 1
        }
    }

    return -1
}

func main() {
    arr := make([]int, 100000000)
    for i := 0; i < 100000000; i++ {
        arr[i] = i + 1
    }

    target := 100000000/2

    duration := timeit(func() {
        binaryResult := binarySearch(arr, target)
        ternaryResult := ternarySearch(arr, target)
    
        fmt.Println("Binary Search Result:", binaryResult)
        fmt.Println("Ternary Search Result:", ternaryResult)
    })

    fmt.Printf("Execution time: %d microseconds\n", duration)

}

EOF

# Generate Python algorithm script
cat <<EOF > python/algorithm.py
import time

def binary_search(arr, target):
    low = 0
    high = len(arr) - 1

    while low <= high:
        mid = (low + high) // 2

        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1

    return -1

def ternary_search(arr, target):
    low = 0
    high = len(arr) - 1

    while low <= high:
        mid1 = low + (high - low) // 3
        mid2 = high - (high - low) // 3

        if arr[mid1] == target:
            return mid1
        elif arr[mid2] == target:
            return mid2
        elif arr[mid1] > target:
            high = mid1 - 1
        elif arr[mid2] < target:
            low = mid2 + 1
        else:
            low = mid1 + 1
            high = mid2 - 1

    return -1

arr = list(range(1, 100000001))
target = 100000000/2

t = time.time()
binary_result = binary_search(arr, target)
ternary_result = ternary_search(arr, target)
print("Binary Search Result:", binary_result)
print("Ternary Search Result:", ternary_result)


print(f"Execution time: {time.time()-t} microseconds")
EOF

# Generate the performance comparison script
cat <<EOF > compare.sh
#!/bin/bash

# Rust
cd rust
cargo install cargo-play

# Build the Rust project
echo "Building..."

echo "Rust Performance:"
cargo play algorithm.rs

# Go
echo "Go Performance:"

cd ../go

go run algorithm.go

# Python
echo "Python Performance:"

cd ../python

python3 algorithm.py
EOF

# Make the performance comparison script executable
chmod +x compare.sh

echo "Setup completed successfully."
