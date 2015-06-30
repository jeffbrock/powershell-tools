function SortFilesIntoFoldersByDateTaken($sourcePath, $targetBasePath, $netDateFormatString, $subpath) 
{
 <#
.DESCRIPTION 
Copies picture files in $sourcePath and subdirectories into a folder 
formatted as {$taretBasePath}\{$netDateFormatString}$subpath where
$netDateFormatString is a valid format string for the DateTime type
#>
    $files = Get-ChildItem $sourcePath -Recurse | where {!$_.PsIsContainer}
    [reflection.assembly]::LoadWithPartialName("System.Drawing")
    foreach ($file in $files)
    {
        $pic = New-Object System.Drawing.Bitmap($file.FullName)
        $dtbytearray = $pic.GetPropertyItem(36867).Value # 'date taken'
        $dtstring = [System.Text.Encoding]::ASCII.GetString($dtbytearray) 
        $dt = [datetime]::ParseExact($dtstring,"yyyy:MM:dd HH:mm:ss`0",$Null)
        $dir = $targetBasePath + "\" + $dt.ToString($netDateFormatString) + "\" + $subpath

        if (!(Test-Path $dir))
        {
            New-Item $dir -type directory
        }
        $file | Copy-Item -Destination $dir
    }
}