class DrinkInfo {
    [string]$Name
    [int]$Volume = -1
    [int]$Quantity = 1
    [decimal]$Caffeine = 0
    [datetime]$Date
}

#$year = Read-Host -Prompt 'Year'
$year = 2024
$files = Get-ChildItem -LiteralPath $year -Recurse -File
$list = [System.Collections.ArrayList]::new()
$files | Where-Object {$_.BaseName -match '^[0-9]{2}$'} | ForEach-Object {
    $file = $_
    $date = Get-Date ($file.Directory.Parent.Name + '-' + $file.Directory.Name + '-' + $file.BaseName)
    $isDrink = $false
    $cont = Get-Content -LiteralPath $_.FullName | Where-Object {
        if ($_ -match '^## ドリンク') {
            $isDrink = $true
            return $false
        } elseif($_ -match '^##') {
            $isDrink = $false
            return $false
        }
        return $isDrink
    }
    [DrinkInfo]$info = $null
    foreach($l in $cont) {
        if ($l.StartsWith('- ')) {
            if ($null -ne $info) {
                $null = $list.Add($info)
            }
            $info = [DrinkInfo]::new()
            $d = $l.Substring(2)
            if ($d.StartsWith('[')) {
                $d = $d.Substring(1, $d.IndexOf(']') - 1)
            }
            $d = $d.Trim()
            if ($d -eq 'レッドブル') {
                $info.Volume = 250
            }
            $e = $d -split ' '
            $hasQuantity = $false
            if ($e[$e.Length - 1] -match '^[0-9]+$') {
                $info.Quantity = $e[$e.Length - 1]
                $hasQuantity = $true
            }
            $len = $e.Length
            if ($hasQuantity) {
                $len = $len - 1
            }
            $name = @()
            for ($i = 0; $i -lt $len; $i++) {
                if ($e[$i] -match '(?<Volume>[0-9]+)ml') {
                    $info.Volume = $Matches['Volume']
                    if ($i -eq $len - 1) {
                        break
                    }
                }
                $name += $e[$i]
            }
            $info.Name = $name -join ' '
            $info.Date = $date
        }
        if ($l -match '^カフェイン\s*(?<Caffeine>[0-9]+(\.[0-9])?)mg$') {
            $info.Caffeine = $Matches['Caffeine']
        } elseif ($l -match '^カフェイン.*mg$') {
            $info.Caffeine = -1
        }
    }
    if ($null -ne $info) {
        $null = $list.Add($info)
    }
}

$list | ConvertTo-Csv | Set-Content -LiteralPath "caffeine${year}.csv"
