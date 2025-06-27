# Unified Smart Branch - Git Branch Creation Tool
# Usage: .\smart-branch.ps1

param(
    [string]$Prefix,
    [string]$TicketNumber,
    [string]$Description,
    [switch]$Help
)

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    White = "White"
    Cyan = "Cyan"
    Magenta = "Magenta"
    Blue = "Blue"
}

# Configuration
$ConfigPath = Join-Path $PSScriptRoot "config.json"
$Config = $null

# Function to load configuration
function Get-Configuration {
    try {
        if (Test-Path $ConfigPath) {
            $Config = Get-Content $ConfigPath | ConvertFrom-Json
            return $Config
        } else {
            Write-Host "⚠️  Không tìm thấy file config.json. Tạo file mặc định..." -ForegroundColor $Colors.Yellow
            $defaultConfig = @{
                ai_provider = "gemini"
                api_key = ""
                model = "gemini-2.0-flash-exp"
                endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent"
                max_tokens = 150
                temperature = 0.7
                enabled = $true
            }
            $defaultConfig | ConvertTo-Json -Depth 3 | Set-Content $ConfigPath
            Write-Host "📁 Đã tạo file config.json. Vui lòng cập nhật API key trong file này." -ForegroundColor $Colors.Green
            return $defaultConfig
        }
    }
    catch {
        Write-Host "❌ Lỗi khi đọc config: $_" -ForegroundColor $Colors.Red
        return $null
    }
}

# Function to show usage
function Show-Usage {
    Write-Host "🚀 === Smart Branch Creator ===" -ForegroundColor $Colors.Cyan
    Write-Host ""
    Write-Host "Sử dụng:" -ForegroundColor $Colors.Yellow
    Write-Host "  .\smart-branch.ps1                              # Interactive mode với menu chọn"
    Write-Host "  .\smart-branch.ps1 [prefix] [ticket] [desc]     # Command line mode với ticket"
    Write-Host "  .\smart-branch.ps1 [prefix] [desc]              # Command line mode không ticket"
    Write-Host ""
    Write-Host "Ví dụ:" -ForegroundColor $Colors.Yellow
    Write-Host "  .\smart-branch.ps1"
    Write-Host "  .\smart-branch.ps1 feat 123 ""implement user authentication"""
    Write-Host "  .\smart-branch.ps1 feat ""add new dashboard"""
    Write-Host ""
    Write-Host "Branch format:" -ForegroundColor $Colors.Yellow
    Write-Host "  Với ticket: feat/username-123_description"
    Write-Host "  Không ticket: feat/username_description"
    Write-Host ""
    Write-Host "Prefix được hỗ trợ:" -ForegroundColor $Colors.Yellow
    Write-Host "  feat, bug, hotfix, sync, refactor, docs, test, chore"
}

# Function to show mode selection menu
function Show-ModeSelection {
    Write-Host "🚀 === Smart Branch Creator ===" -ForegroundColor $Colors.Green
    Write-Host ""
    Write-Host "Chọn mode:" -ForegroundColor $Colors.Cyan
    Write-Host "  [1] 🤖 AI Mode - Smart suggestions với Google Gemini" -ForegroundColor $Colors.White
    Write-Host "  [2] ⚡ Traditional Mode - Classic naming" -ForegroundColor $Colors.White
    Write-Host "  [3] ❌ Thoát" -ForegroundColor $Colors.White
    Write-Host ""

    do {
        $choice = Read-Host "Lựa chọn (1-3)"
        if ($choice -match '^[1-3]$') {
            return [int]$choice
        }
        Write-Host "❌ Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến 3" -ForegroundColor $Colors.Red
    } while ($true)
}

# Function to validate prefix
function Test-ValidPrefix {
    param([string]$Prefix)
    $ValidPrefixes = @("feat", "fix", "hotfix", "docs", "style", "refactor", "test", "chore")
    return $ValidPrefixes -contains $Prefix
}

# Function to get git username
function Get-GitUsername {
    try {
        $username = git config user.name
        if ([string]::IsNullOrEmpty($username)) {
            Write-Host "❌ Lỗi: Không tìm thấy git username. Vui lòng cấu hình git config user.name" -ForegroundColor $Colors.Red
            exit 1
        }
        # Convert to lowercase and replace spaces
        return $username.ToLower() -replace '\s+', ''
    }
    catch {
        Write-Host "❌ Lỗi: Không thể lấy git username. Đảm bảo git đã được cài đặt và cấu hình." -ForegroundColor $Colors.Red
        exit 1
    }
}

# Function to sanitize description
function Get-SanitizedDescription {
    param([string]$Description)
    # Convert to lowercase, replace spaces and special chars with hyphens
    $sanitized = $Description.ToLower() -replace '[^a-z0-9]', '-'
    $sanitized = $sanitized -replace '-+', '-'
    $sanitized = $sanitized -replace '^-|-$', ''
    return $sanitized
}

# Function to check if branch exists
function Test-BranchExists {
    param([string]$BranchName)
    try {
        $result = git show-ref --verify --quiet "refs/heads/$BranchName"
        return $LASTEXITCODE -eq 0
    }
    catch {
        return $false
    }
}

# Function to call Gemini API for branch name suggestions
function Get-AIBranchSuggestions {
    param(
        [string]$Prefix,
        [string]$TicketNumber,
        [string]$Description,
        [string]$Username,
        [object]$Config
    )

    if (-not $Config -or -not $Config.enabled -or [string]::IsNullOrEmpty($Config.api_key)) {
        Write-Host "⚠️  AI không được cấu hình hoặc tắt. Sử dụng tên nhánh truyền thống." -ForegroundColor $Colors.Yellow
        return @()
    }

    Write-Host "🤖 Đang gọi AI để tạo gợi ý tên nhánh..." -ForegroundColor $Colors.Cyan

    # Create prompt based on whether ticket number exists
    $branchFormat = if ([string]::IsNullOrEmpty($TicketNumber)) {
        "{prefix}/{username}_{description}"
    } else {
        "{prefix}/{username}-{ticket}_{description}"
    }

    $exampleFormats = if ([string]::IsNullOrEmpty($TicketNumber)) {
        @"
feat/username_add-user-auth
feat/username_implement-login-system
feat/username_create-auth-module
"@
    } else {
        @"
feat/username-123_add-user-auth
feat/username-123_implement-login-system
feat/username-123_create-auth-module
"@
    }

    $ticketInfo = if ([string]::IsNullOrEmpty($TicketNumber)) {
        "- Ticket: Không có (optional)"
    } else {
        "- Ticket: $TicketNumber"
    }

    $prompt = @"
Bạn là AI chuyên gia đặt tên nhánh Git. Hãy tạo CHÍNH XÁC 5 tên nhánh phù hợp với thông tin sau, mỗi dòng 1 tên, KHÔNG thêm bất kỳ giải thích, text hoặc ký tự nào khác ngoài 5 tên nhánh:
- Prefix: $Prefix
$ticketInfo
- Mô tả task: $Description
- Username: $Username

Định dạng: $branchFormat

Ví dụ:
$exampleFormats
"@

    try {
        $requestBody = @{
            contents = @(
                @{
                    parts = @(
                        @{
                            text = $prompt
                        }
                    )
                }
            )
            generationConfig = @{
                temperature = $Config.temperature
                maxOutputTokens = $Config.max_tokens
            }
        } | ConvertTo-Json -Depth 5

        $headers = @{
            'Content-Type' = 'application/json'
        }

        $uri = $Config.endpoint + "?key=" + $Config.api_key

        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $requestBody -Headers $headers

        if ($response.candidates -and $response.candidates[0].content.parts[0].text) {
            $suggestions = $response.candidates[0].content.parts[0].text.Trim().Split("`n") |
                          Where-Object { $_ -and $_.Trim() -ne "" } |
                          ForEach-Object { $_.Trim() } |
                          Select-Object -First 5

           if ($suggestions.Count -eq 5) {
               return $suggestions
           } else {
               Write-Host "⚠️  AI trả về số lượng gợi ý không đúng. Fallback về tên truyền thống." -ForegroundColor $Colors.Yellow
               return @()
           }
        } else {
            Write-Host "⚠️  AI không trả về kết quả hợp lệ. Fallback về tên truyền thống." -ForegroundColor $Colors.Yellow
            return @()
        }
    }
    catch {
        Write-Host "❌ Lỗi khi gọi AI API: $_" -ForegroundColor $Colors.Red
        Write-Host "💡 Fallback về tên nhánh truyền thống..." -ForegroundColor $Colors.Yellow
        return @()
    }
}

# Function to display and select branch option
function Select-BranchOption {
    param(
        [array]$Suggestions,
        [string]$TraditionalName
    )

    Write-Host ""
    Write-Host "🎯 Chọn tên nhánh:" -ForegroundColor $Colors.Green
    Write-Host ""

    $options = @()
    $index = 1

    # Add AI suggestions
    foreach ($suggestion in $Suggestions) {
        Write-Host "  [$index] $suggestion" -ForegroundColor $Colors.White
        $options += $suggestion
        $index++
    }

    # Add traditional option
    Write-Host "  [$index] $TraditionalName (truyền thống)" -ForegroundColor $Colors.Yellow
    $options += $TraditionalName
    $index++

    # Add manual input option
    Write-Host "  [$index] Nhập tên nhánh khác" -ForegroundColor $Colors.Cyan
    Write-Host ""

    $maxOption = $index

    do {
        $choice = Read-Host "Lựa chọn (1-$maxOption)"
        if ($choice -match '^\d+$') {
            $choiceNum = [int]$choice
            if ($choiceNum -ge 1 -and $choiceNum -le $maxOption) {
                if ($choiceNum -eq $maxOption) {
                    # Manual input
                    do {
                        $customName = Read-Host "Nhập tên nhánh"
                        if (-not [string]::IsNullOrEmpty($customName)) {
                            return $customName
                        }
                        Write-Host "❌ Tên nhánh không được để trống" -ForegroundColor $Colors.Red
                    } while ($true)
                } else {
                    # Selected from options
                    return $options[$choiceNum - 1]
                }
            }
        }
        Write-Host "❌ Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến $maxOption" -ForegroundColor $Colors.Red
    } while ($true)
}

# Function to get input interactively
function Get-InteractiveInput {
    Write-Host "📝 Nhập thông tin nhánh:" -ForegroundColor $Colors.Yellow

    # Get prefix
    do {
        $Prefix = Read-Host "Prefix (feat/fix/hotfix/docs/style/refactor/test/chore)"
        if (-not (Test-ValidPrefix $Prefix)) {
            Write-Host "❌ Prefix không hợp lệ. Vui lòng chọn: feat, fix, hotfix, docs, style, refactor, test, chore" -ForegroundColor $Colors.Red
        }
    } while (-not (Test-ValidPrefix $Prefix))

    # Get ticket number (optional)
    $TicketNumber = Read-Host "Ticket number (optional, nhấn Enter để skip)"
    # Remove validation - ticket number is now optional

    # Get description
    do {
        $Description = Read-Host "Mô tả chi tiết task (VD: implement user authentication system)"
        if ([string]::IsNullOrEmpty($Description)) {
            Write-Host "❌ Mô tả không được để trống" -ForegroundColor $Colors.Red
        }
    } while ([string]::IsNullOrEmpty($Description))

    return @{
        Prefix = $Prefix
        TicketNumber = $TicketNumber
        Description = $Description
    }
}

# Function to run AI mode
function Invoke-AIMode {
    param(
        [string]$Prefix,
        [string]$TicketNumber,
        [string]$Description,
        [string]$Username
    )

    Write-Host ""
    Write-Host "🤖 AI Mode được chọn!" -ForegroundColor $Colors.Green
    Write-Host ""

    # Load configuration
    $Config = Get-Configuration

    # Create traditional branch name as fallback
    $sanitizedDesc = Get-SanitizedDescription $Description
    $traditionalBranchName = if ([string]::IsNullOrEmpty($TicketNumber)) {
        "$Prefix/$Username`_$sanitizedDesc"
    } else {
        "$Prefix/$Username-$TicketNumber`_$sanitizedDesc"
    }

    $selectedBranchName = $traditionalBranchName

    # Get AI suggestions if enabled
    if ($Config -and $Config.enabled) {
        $aiSuggestions = Get-AIBranchSuggestions -Prefix $Prefix -TicketNumber $TicketNumber -Description $Description -Username $Username -Config $Config

        if ($aiSuggestions.Count -eq 5) {
            $selectedBranchName = Select-BranchOption -Suggestions $aiSuggestions -TraditionalName $traditionalBranchName
        } else {
            Write-Host "💡 Sử dụng tên nhánh truyền thống: $traditionalBranchName" -ForegroundColor $Colors.Yellow
        }
    } else {
        Write-Host "💡 Tên nhánh truyền thống: $traditionalBranchName" -ForegroundColor $Colors.Yellow
    }

    return $selectedBranchName
}

# Function to run traditional mode
function Invoke-TraditionalMode {
    param(
        [string]$Prefix,
        [string]$TicketNumber,
        [string]$Description,
        [string]$Username
    )

    Write-Host ""
    Write-Host "⚡ Traditional Mode được chọn!" -ForegroundColor $Colors.Green
    Write-Host ""

    # Sanitize description
    $sanitizedDesc = Get-SanitizedDescription $Description
    $branchName = if ([string]::IsNullOrEmpty($TicketNumber)) {
        "$Prefix/$Username`_$sanitizedDesc"
    } else {
        "$Prefix/$Username-$TicketNumber`_$sanitizedDesc"
    }

    Write-Host "💡 Tên nhánh truyền thống: $branchName" -ForegroundColor $Colors.Yellow

    return $branchName
}

# Function to create branch
function New-GitBranch {
    param([string]$BranchName)

    Write-Host ""
    Write-Host "🎯 Tên nhánh được chọn: " -ForegroundColor $Colors.Green -NoNewline
    Write-Host $BranchName -ForegroundColor $Colors.White
    Write-Host ""

    # Confirm before creating
    $confirm = Read-Host "✅ Xác nhận tạo nhánh? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "❌ Đã hủy tạo nhánh" -ForegroundColor $Colors.Yellow
        return
    }

    # Check if branch already exists
    if (Test-BranchExists $BranchName) {
        Write-Host "❌ Lỗi: Nhánh '$BranchName' đã tồn tại" -ForegroundColor $Colors.Red
        exit 1
    }

    # Create and checkout new branch
    Write-Host "🔄 Đang tạo nhánh..." -ForegroundColor $Colors.Green
    try {
        git checkout -b $BranchName
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Đã tạo và chuyển sang nhánh '$BranchName' thành công!" -ForegroundColor $Colors.Green
            Write-Host ""
            Write-Host "📋 Lưu ý:" -ForegroundColor $Colors.Yellow
            Write-Host "- Một PR chỉ làm đúng 1 việc của 1 ticket duy nhất"
            Write-Host "- Sử dụng git rebase khi merge code từ staging/master"
            Write-Host "- File không được quá 400 dòng code"
            Write-Host "- Folder name phải ở dạng số nhiều (trừ app/pages)"
            Write-Host ""
            Write-Host "🎉 Happy coding!" -ForegroundColor $Colors.Magenta
        }
        else {
            Write-Host "❌ Lỗi: Không thể tạo nhánh '$BranchName'" -ForegroundColor $Colors.Red
            exit 1
        }
    }
    catch {
        Write-Host "❌ Lỗi: Không thể tạo nhánh '$BranchName'. $_" -ForegroundColor $Colors.Red
        exit 1
    }
}

# Main script logic
function Main {
    # Show help if requested
    if ($Help) {
        Show-Usage
        return
    }

    # Get git username
    $username = Get-GitUsername
    Write-Host "👤 Git username: " -ForegroundColor $Colors.Green -NoNewline
    Write-Host $username
    Write-Host ""

    # Language selection (đồng bộ với bash)
    if (-not $env:SB_LANG) {
        Write-Host "Please select a language / Vui lòng chọn ngôn ngữ:"
        Write-Host "  [1] English"
        Write-Host "  [2] Vietnamese"
        do {
            $lang_choice = Read-Host "Choice (1-2)"
            if ($lang_choice -eq "1") { $LANG = "en"; break }
            elseif ($lang_choice -eq "2") { $LANG = "vi"; break }
            else { Write-Host "Invalid choice. Please enter 1 or 2." }
        } while ($true)
    } else {
        $LANG = $env:SB_LANG
    }

    # Auto-detect command line arguments format
    if (-not [string]::IsNullOrEmpty($Prefix) -and -not [string]::IsNullOrEmpty($TicketNumber)) {
        # Check if second param is actually a ticket number (numeric) or description
        if ($TicketNumber -match '^\d+$') {
            # Format: sb feat 123 "description"
            # TicketNumber is actually a ticket number
            if ([string]::IsNullOrEmpty($Description)) {
                Write-Host "❌ Lỗi: Thiếu description khi sử dụng format có ticket number" -ForegroundColor $Colors.Red
                Show-Usage
                exit 1
            }
        } else {
            # Format: sb feat "description" (no ticket)
            # TicketNumber is actually description, shift parameters
            $Description = $TicketNumber
            $TicketNumber = ""
        }
    }

    # Check if arguments provided
    if ([string]::IsNullOrEmpty($Prefix) -or [string]::IsNullOrEmpty($Description)) {
        # Interactive mode - show mode selection
        $modeChoice = Show-ModeSelection

        if ($modeChoice -eq 3) {
            Write-Host "👋 Tạm biệt!" -ForegroundColor $Colors.Cyan
            return
        }

        # Get input interactively
        $input = Get-InteractiveInput
        $Prefix = $input.Prefix
        $TicketNumber = $input.TicketNumber
        $Description = $input.Description
    } else {
        # Command line mode - ask for mode selection
        Write-Host "🚀 === Smart Branch Creator ===" -ForegroundColor $Colors.Green
        Write-Host ""
        Write-Host "Chọn mode cho thông tin đã nhập:" -ForegroundColor $Colors.Cyan
        Write-Host "  Prefix: $Prefix" -ForegroundColor $Colors.White

        if ([string]::IsNullOrEmpty($TicketNumber)) {
            Write-Host "  Ticket: Không có" -ForegroundColor $Colors.White
        } else {
            Write-Host "  Ticket: $TicketNumber" -ForegroundColor $Colors.White
        }

        Write-Host "  Description: $Description" -ForegroundColor $Colors.White
        Write-Host ""
        Write-Host "  [1] 🤖 AI Mode - Smart suggestions" -ForegroundColor $Colors.White
        Write-Host "  [2] ⚡ Traditional Mode - Classic naming" -ForegroundColor $Colors.White
        Write-Host "  [3] ❌ Thoát" -ForegroundColor $Colors.White
        Write-Host ""

        do {
            $modeChoice = Read-Host "Lựa chọn (1-3)"
            if ($modeChoice -match '^[1-3]$') {
                $modeChoice = [int]$modeChoice
                break
            }
            Write-Host "❌ Lựa chọn không hợp lệ. Vui lòng chọn từ 1 đến 3" -ForegroundColor $Colors.Red
        } while ($true)

        if ($modeChoice -eq 3) {
            Write-Host "👋 Tạm biệt!" -ForegroundColor $Colors.Cyan
            return
        }

        # Validate prefix when using command line arguments
        if (-not (Test-ValidPrefix $Prefix)) {
            Write-Host "❌ Lỗi: Prefix '$Prefix' không hợp lệ" -ForegroundColor $Colors.Red
            Show-Usage
            exit 1
        }
    }

    # Execute based on mode choice
    $selectedBranchName = ""
    if ($modeChoice -eq 1) {
        # AI Mode
        $selectedBranchName = Invoke-AIMode -Prefix $Prefix -TicketNumber $TicketNumber -Description $Description -Username $username
    } elseif ($modeChoice -eq 2) {
        # Traditional Mode
        $selectedBranchName = Invoke-TraditionalMode -Prefix $Prefix -TicketNumber $TicketNumber -Description $Description -Username $username
    }

    # Create the branch
    New-GitBranch -BranchName $selectedBranchName
}

# Run main function
Main