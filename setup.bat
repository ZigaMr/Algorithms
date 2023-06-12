# Check if Rust is installed
if (-not (Get-Command rustc -ErrorAction SilentlyContinue)) {
    Write-Host "Rust not found. Installing..."
    Invoke-WebRequest -Uri https://win.rustup.rs -OutFile rustup-init.exe
    Start-Process -FilePath .\rustup-init.exe -ArgumentList '-y' -NoNewWindow -Wait
    Remove-Item -Path rustup-init.exe
    $env:PATH += ";$($env:USERPROFILE)\.cargo\bin"
    $env:RUSTUP_HOME = "$($env:USERPROFILE)\.rustup"
    $env:CARGO_HOME = "$($env:USERPROFILE)\.cargo"
} else {
    Write-Host "Rust is already installed."
}

# Check if Go is installed
if (-not (Get-Command go -ErrorAction SilentlyContinue)) {
    Write-Host "Go not found. Installing..."
    $url = "https://golang.org/dl/go1.16.7.windows-amd64.zip"
    $output = "$env:TEMP\go.zip"
    Invoke-WebRequest -Uri $url -OutFile $output
    Expand-Archive -Path $output -DestinationPath $env:ProgramFiles -Force
    Remove-Item -Path $output
    $env:PATH += ";$($env:ProgramFiles)\go\bin"
} else {
    Write-Host "Go is already installed."
}

# Check if Python is installed
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python not found. Installing..."
    $url = "https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe"
    $output = "$env:TEMP\python.exe"
    Invoke-WebRequest -Uri $url -OutFile $output
    Start-Process -FilePath $output -ArgumentList '/quiet', 'InstallAllUsers=1', 'PrependPath=1' -NoNewWindow -Wait
    Remove-Item -Path $output
} else {
    Write-Host "Python is already installed."
}

# Check if Poetry is installed
if (-not (Get-Command poetry -ErrorAction SilentlyContinue)) {
    Write-Host "Poetry not found. Installing..."
    (Invoke-WebRequest -Uri https://install.python-poetry.org/ -UseBasicParsing).Content | python
    $env:POETRY_HOME = "$($env:USERPROFILE)\.poetry"
    $env:PATH += ";$($env:POETRY_HOME)\bin"
} else {
    Write-Host "Poetry is already installed."
}

# Create folders if they don't exist
$folders = @("rust", "go", "python")
$folders | ForEach-Object {
    $folder = $_
    if (-not (Test-Path -Path $folder -PathType Container)) {
        New-Item -Path $folder -ItemType Directory | Out-Null
    }
}

# Generate Rust algorithm script
@'
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
    let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let target = 6;

    let binary_result = binary_search(&arr, target);
    let ternary_result = ternary_search(&arr, target);

    println!("Binary Search Result: {:?}", binary_result);
    println!("Ternary Search Result: {:?}", ternary_result);
}
'@ | Out-File -FilePath ".\rust\algorithm.rs" -Encoding utf8

# Generate Go algorithm script
@'
package main

import "fmt"

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
        mid1 := low + (high-low)/3
        mid2 := high - (high-low)/3

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
    arr := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    target := 6

    binaryResult := binarySearch(arr, target)
    ternaryResult := ternarySearch(arr, target)

    fmt.Println("Binary Search Result:", binaryResult)
    fmt.Println("Ternary Search Result:", ternaryResult)
}
'@ | Out-File -FilePath ".\go\algorithm.go" -Encoding utf8

# Generate Python algorithm script
@'
def binary_search(arr, target):
    low = 0
    high = len(arr) - 1

    while low <= high:
       
