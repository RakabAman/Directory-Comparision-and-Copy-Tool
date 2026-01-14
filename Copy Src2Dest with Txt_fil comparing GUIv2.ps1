Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Directory Comparison and Copy Tool'
$form.Size = New-Object System.Drawing.Size(600, 415)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false

$sourceLabel = New-Object System.Windows.Forms.Label
$sourceLabel.Location = New-Object System.Drawing.Point(20, 25)
$sourceLabel.Size = New-Object System.Drawing.Size(100, 20)
$sourceLabel.Text = 'Source Directory:'

$destinationLabel = New-Object System.Windows.Forms.Label
$destinationLabel.Location = New-Object System.Drawing.Point(20, 60)
$destinationLabel.Size = New-Object System.Drawing.Size(100, 25)
$destinationLabel.Text = 'Destination Directory:'

$skipListLabel = New-Object System.Windows.Forms.Label
$skipListLabel.Location = New-Object System.Drawing.Point(20, 105)
$skipListLabel.Size = New-Object System.Drawing.Size(100, 20)
$skipListLabel.Text = 'Skip List File:'

$sourceTextBox = New-Object System.Windows.Forms.TextBox
$sourceTextBox.Location = New-Object System.Drawing.Point(130, 20)
$sourceTextBox.Size = New-Object System.Drawing.Size(350, 20)

$destinationTextBox = New-Object System.Windows.Forms.TextBox
$destinationTextBox.Location = New-Object System.Drawing.Point(130, 60)
$destinationTextBox.Size = New-Object System.Drawing.Size(350, 20)

$skipListTextBox = New-Object System.Windows.Forms.TextBox
$skipListTextBox.Location = New-Object System.Drawing.Point(130, 100)
$skipListTextBox.Size = New-Object System.Drawing.Size(350, 20)

$sourceButton = New-Object System.Windows.Forms.Button
$sourceButton.Location = New-Object System.Drawing.Point(490, 20)
$sourceButton.Size = New-Object System.Drawing.Size(75, 23)
$sourceButton.Text = 'Browse'
$sourceButton.Add_Click({
    $folder = [System.Windows.Forms.FolderBrowserDialog]::new()
    if ($folder.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $sourceTextBox.Text = $folder.SelectedPath
    }
})

$destinationButton = New-Object System.Windows.Forms.Button
$destinationButton.Location = New-Object System.Drawing.Point(490, 60)
$destinationButton.Size = New-Object System.Drawing.Size(75, 23)
$destinationButton.Text = 'Browse'
$destinationButton.Add_Click({
    $folder = [System.Windows.Forms.FolderBrowserDialog]::new()
    if ($folder.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $destinationTextBox.Text = $folder.SelectedPath
    }
})

$skipListButton = New-Object System.Windows.Forms.Button
$skipListButton.Location = New-Object System.Drawing.Point(490, 100)
$skipListButton.Size = New-Object System.Drawing.Size(75, 23)
$skipListButton.Text = 'Browse'
$skipListButton.Add_Click({
    $openFileDialog = [System.Windows.Forms.OpenFileDialog]::new()
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $skipListTextBox.Text = $openFileDialog.FileName
    }
})

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(20, 180)
$outputBox.Size = New-Object System.Drawing.Size(550, 200)
$outputBox.ReadOnly = $true
$outputBox.Multiline = $true
$outputBox.Scrollbars = "Vertical" 

$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(250, 140)
$startButton.Size = New-Object System.Drawing.Size(100, 25)
$startButton.Text = 'Start Copy'
$startButton.Add_Click({
    $source = $sourceTextBox.Text
    $destination = $destinationTextBox.Text
    $skipList = Get-Content $skipListTextBox.Text

    Function Add-OutputBoxLine {
        Param ($Message)
        $outputBox.AppendText("`r`n$Message")
        $outputBox.Refresh()
        $outputBox.ScrollToCaret()
    }

    Get-ChildItem $source -Recurse | ForEach-Object {
        $item = $_.FullName
        $relativePath = $item.Substring($source.Length)

        $skip = "false"
        foreach ($path in $skipList) {
            $trimmedPath = $path -replace [regex]::Escape($destination), ""
            if ($trimmedPath -eq $relativePath) {
                Add-OutputBoxLine "Skipping file/folder: $relativePath"
                $skip = "true"
                break
            }
        }

        if ($skip -eq "false") {
            $dest = Join-Path $destination $relativePath

            if (-not (Test-Path $dest)) {
                Copy-Item -Path $item -Destination $dest
                Add-OutputBoxLine "Copied: $relativePath"
            } else {
                Add-OutputBoxLine "File already exists in destination: $relativePath"
            }
        }
    }
})

$form.Controls.Add($sourceLabel)
$form.Controls.Add($destinationLabel)
$form.Controls.Add($skipListLabel)
$form.Controls.Add($sourceTextBox)
$form.Controls.Add($destinationTextBox)
$form.Controls.Add($skipListTextBox)
$form.Controls.Add($sourceButton)
$form.Controls.Add($destinationButton)
$form.Controls.Add($skipListButton)
$form.Controls.Add($outputBox)
$form.Controls.Add($startButton)

[void]$form.ShowDialog()