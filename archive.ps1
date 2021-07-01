$wiki = '..\diary.wiki'
$repo = '.\'

class Log {
    [string]$Commit = $null
    [string]$Author = $null
    [datetime]$Date = [datetime]::MinValue
    [string]$Message= $null
}

function Get-Log($log) {
    $l = $null
    $msg = @()
    $log | ForEach-Object {
        if($_ -match '^commit [0-9a-f]+$') {
            if($null -ne $l) {
                $l.Message = ($msg -join "`n").Trim()
                $l
            }
            $msg = @()
            $l = [Log]::new()
            $c = $_.SubString(7)
            $l.Commit = $c
            return
        }
        if($_ -match '^Author: ') {
            $a = $_ -replace '^Author: *(.+?)', '$1'
            $l.Author = $a
            return
        }
        if($_ -match '^Date: *') {
            $d = $_ -replace '^Date: *(.+?)', '$1'
            $l.Date = Get-Date $d
            return
        }
        $msg += $_
    }
    $l.Message = ($msg -join "`n").Trim()
    return $l
}

Get-ChildItem $wiki -File -Filter '*-*-*.md' | ForEach-Object {
    $name = $_.Name
    $logs = git -C $wiki log --follow --date=iso $_.Name
    [PSCustomObject]@{
        'Name' = $name
        'Logs' = [Log[]](Get-Log $logs)
    }
} | ForEach-Object {
    $cont = Get-Content "$wiki\$($_.Name)"
    $cont += ''
    $cont += '変更履歴:  '
    $_.Logs | Sort-Object -Property Date | ForEach-Object {
        $cont += "$($_.Date): $($_.Message)  "
    }

    $n = $name -split '-'
    $dir = "$($n[0])\$($n[1])"
    if(!(Test-Path $dir)) {
        $null = New-Item -ItemType Directory "$repo\$dir" -Force
    }
    $cont | Set-Content "$repo\$dir\$($n[2])"
    Remove-Item "$wiki\$($_.Name)"
}

$t = @(
    '# diary'
    '日記を書きます'
    ''
)

Get-ChildItem -Directory $repo | Where-Object {$_.Name -match '^\d{4}$'} | ForEach-Object {
    $year = $_.name
    $t += "[${year}年](./$year/README.md)  "

    $y = @(
        "# ${year}年"
        ''
    )
    Get-ChildItem -Directory $repo\$year | ForEach-Object {
        $month = $_.Name
        [int]$n = $month
        $y += "[${n}月](./$month/README.md)  "

        $m = @(
            "# ${year}年${n}月"
            ''
            '|日|月|火|水|木|金|土|'
            '|--|--|--|--|--|--|--|'
        )

        [datetime]$d = Get-Date "$year-$month-01"
        $w = @()
        for($i = 0; $i -lt $d.DayOfWeek; $i++) {
            $w += ''
        }
        while($true) {
            $dd = '{0:D2}' -f $d.Day

            if(Test-Path "$repo\$year\$month\$dd.md") {
                $w += "[$($d.Day)](./$dd.md)"
            } else {
                $w += $d.Day
            }

            if($w.Length -ge 7) {
                $m += "|" + ($w -join '|') + "|"
                $w = @()
            }

            $d = $d.AddDays(1.0)
            if($d.Month -ne $n) {
                break
            }
        }
        for($i = $w.Length; $i -le 7; $i++) {
            $w += ''
        }
        $m += "|" + ($w -join '|') + "|"

        $m += ''
        $m += "[${year}年](../README.md)"
        $m | Set-Content "$repo\$year\$month\README.md"
    }
    $y += ''
    $y += '[Top](../README.md)'
    $y | Set-Content "$repo\$year\README.md"
}

$t = $t -join "`r`n"
$t.Trim() | Set-Content "$repo\README.md"
