# Define the paths to the script folders
$pythonFolder = "Python"
$rustFolder = "rust"
$goFolder = "Golang"
$cppFolder = "C++"

# Run Python script
Write-Host "Running Python script..."
python "$pythonFolder\binary_search.py"

# Run Rust script
Write-Host "Running Rust script..."
cd $rustFolder
cargo run
cd ..

# Run Go script
Write-Host "Running Go script..."
cd $goFolder
go run binary_search.go
cd ..

# Recompile and run C++ script
Write-Host "Recompiling and running C++ script..."
cd $cppFolder
g++ -o binary_search.exe binary_search.cpp
./binary_search.exe
cd ..

Write-Host "All scripts have been executed."
