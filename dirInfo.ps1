# dirInfo: log the count of files and sub directories for a given directory, display the types of file extensions found and the count of each, and then optionally display the directory contents to the user.
$directory = Read-Host -Prompt 'Please specify a directory'

$isValidDirectory = Test-Path -Path $directory -PathType Container -ErrorAction SilentlyContinue
if (!$isValidDirectory) {
  Write-Output "The path $directory is not a valid directory path."
  return
}

# count number of files and sub directories in the specified directory
$files = Get-ChildItem -Path $directory -File
$filesCount = ($files | Measure-Object).Count
$subDirectoriesCount = (Get-ChildItem -Path $directory -Directory | Measure-Object).Count

# find the types of file extentions found in the specified directory and their count using a hash table
$extensionCounts = @{}

foreach ($file in $files) {
  $extension = $file.Extension.ToLower()

  if ($extensionCounts.ContainsKey($extension)) {
    $extensionCounts[$extension]++
  }
  else {
    $extensionCounts[$extension] = 1
  }
}

Write-Output "Number of files: $filesCount"
Write-Output "Number of sub-directories: $subDirectoriesCount"
Write-Output 'The following file types were found:'
foreach ($extension in $extensionCounts.Keys) {
  $count = $extensionCounts[$extension]
  Write-Output "$extension : $count"
}

# prompt user if they would like to display contents of the directory
$confirmation = Read-Host "Display contents of $directory ? (yes/no)"
if ($confirmation.ToLower()[0] -eq 'y') {
  $directory | Get-ChildItem
}
