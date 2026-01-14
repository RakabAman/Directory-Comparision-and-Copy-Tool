$source = "C:\D Drive\PRIVATE\TEST\Compare_Copy_test\SRC"
$destination = "C:\D Drive\PRIVATE\TEST\Compare_Copy_test\DEST"
$skipList = Get-Content "C:\D Drive\PRIVATE\TEST\Compare_Copy_test\DEST\Dir.txt"

Get-ChildItem $source -Recurse | ForEach-Object {
    $item = $_.FullName
    $relativePath = $item.Substring($source.Length)
   # write-host "relativepath: $relativepath"

    $skip = "false"
    foreach ($path in $skipList) {
        $trimmedPath = $path -replace [regex]::Escape($destination), ""
        if ($trimmedPath -eq $relativePath) {
         #   Write-Host "Skipping file/folder: $relativePath"
            $skip = "true"
         # Read-Host "Skiplist done"
            break
        }
    }
  # Read-Host "Checking Skip Flag"
    if ($skip -eq "true" ) {
    Write-Host "Skipping file/folder: $relativePath"
  # Read-Host " File skippped"
    } else {
  #  Read-Host "Starting to copy file"
    $dest = Join-Path $destination $relativePath

    if (-not (Test-Path $dest)) {
        Copy-Item -Path $item -Destination $dest
    } else {
        Write-Host "File already exists in destination: $relativePath"
    }
   # read-host "Next file"
    }
}