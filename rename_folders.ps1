# Set base directory
$base = "D:\JPN-AirPollution\jpn_airpollution_rawdata09-22\unzipped_data"

# Romaji mapping dictionary
$map = @{
    "01" = "Hokkaido";    "02" = "Aomori";     "03" = "Iwate";       "04" = "Miyagi"
    "05" = "Akita";       "06" = "Yamagata";   "07" = "Fukushima";   "08" = "Ibaraki"
    "09" = "Tochigi";     "10" = "Gunma";      "11" = "Saitama";     "12" = "Chiba"
    "13" = "Tokyo";       "14" = "Kanagawa";   "15" = "Niigata";     "16" = "Toyama"
    "17" = "Ishikawa";    "18" = "Fukui";      "19" = "Yamanashi";   "20" = "Nagano"
    "21" = "Gifu";        "22" = "Shizuoka";   "23" = "Aichi";       "24" = "Mie"
    "25" = "Shiga";       "26" = "Kyoto";      "27" = "Osaka";       "28" = "Hyogo"
    "29" = "Nara";        "30" = "Wakayama";   "31" = "Tottori";     "32" = "Shimane"
    "33" = "Okayama";     "34" = "Hiroshima";  "35" = "Yamaguchi";   "36" = "Tokushima"
    "37" = "Kagawa";      "38" = "Ehime";      "39" = "Kochi";       "40" = "Fukuoka"
    "41" = "Saga";        "42" = "Nagasaki";   "43" = "Kumamoto";    "44" = "Oita"
    "45" = "Miyazaki";    "46" = "Kagoshima";  "47" = "Okinawa"
}

# Traverse all year folders
Get-ChildItem $base -Directory | ForEach-Object {
    $yearPath = $_.FullName

    # Traverse each jXX_YYYY folder
    Get-ChildItem $yearPath -Directory | ForEach-Object {
        $jxxPath = $_.FullName

        # Find the one folder inside it (e.g., '01北海道')
        Get-ChildItem $jxxPath -Directory | ForEach-Object {
            $current = $_
            $code = $current.Name.Substring(0,2)
            if ($map.ContainsKey($code)) {
                $newName = "$code" + "_" + $map[$code]
                $newPath = Join-Path -Path $current.DirectoryName -ChildPath $newName

                if ($current.FullName -ne $newPath) {
                    Rename-Item -Path $current.FullName -NewName $newName
                    Write-Host "✅ Renamed: $($current.Name) → $newName"
                }
            } else {
                Write-Host "⚠️ Unknown code: $($current.Name)"
            }
        }
    }
}
