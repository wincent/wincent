[CmdletBinding()]

param (
    [Parameter(Position = 0, Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Path -Path $_})]
    [string]
    $ConfigPath = $env:APPDATA + "\ConEmu.xml",

    [Parameter(Position = 1, Mandatory = $true)]
    [ValidateSet("Add", "Remove")]
    [string]
    $Operation = "Add",

    [Parameter(Position = 2, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({($Operation -eq "Remove") -or (Test-Path -Path $_)})]
    [string]
    $ThemePathOrName
)

try {
    [Xml]$config = Get-Content -Path $ConfigPath -Encoding UTF8
    $config.Save([System.IO.Path]::ChangeExtension($ConfigPath, ".backup.xml"))

    $vanilla = $config.key.key.key | Where-Object { $_.name -eq ".Vanilla" }
    $colors = $vanilla.key | Where-Object { $_.name -eq "Colors" }

    switch ($Operation) {
        "Add" {
            [Xml]$theme = Get-Content -Path $ThemePathOrName

            if ($colors -eq $null) {
                [Xml]$emptyColors = "<key name='Colors'><value name='Count' type='long' data='0'/></key>"
                $vanilla.AppendChild($config.ImportNode($emptyColors.DocumentElement, $true)) | Out-Null
                $colors = $vanilla.key | Where-Object { $_.name -eq "Colors" }
            } else {
                $themeName = ($theme.key.value | Where-Object { $_.name -eq "Name" }).data
                $existingTheme = $colors.key | Where-Object { $_.value | Where-Object { $_.name -eq "Name" -and $_.data -eq $themeName } }

                if ($existingTheme -ne $null) {
                    throw "Theme was already added to config"
                }
            }

            $colors.AppendChild($config.ImportNode($theme.DocumentElement, $true)) | Out-Null
        }
        "Remove" {
            if ($colors -eq $null -or $colors.key -eq $null) {
                throw "No themes in config"
            }

            $theme = $colors.key | Where-Object { $_.value | Where-Object { $_.name -eq "Name" -and $_.data -eq $ThemePathOrName } }

            if ($theme -eq $null) {
                throw "Theme not found in config"
            }

            $colors.RemoveChild($theme) | Out-Null
        }
    }

    if ($colors.key -eq $null) {
        $colors.value.data = "0"
    } elseif ($colors.key -is [System.Array]) {
        $colors.value.data = $colors.key.Count.ToString()
        for ($i = 0; $i -lt $colors.key.Count; $i++) {
            $colors.key[$i].name = "Palette$($i + 1)"
        }
    } else {
        $colors.value.data = "1"
        $colors.key.name = "Palette1"
    }

    $config.Save($ConfigPath)
} catch {
    Write-Error -Message $_
}
