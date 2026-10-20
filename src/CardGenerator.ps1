<#
.SYNOPSIS
    Local Architecture Technical Card Generator with PDF Export.
.DESCRIPTION
    Parses structural JSON microservice meta-layers and compiles them into interactive
    HTML/CSS technical architecture cards, with automatic localized PDF print exporting.
.EXAMPLE
    .\CardGenerator.ps1 -InputConfig "config/services.json"
#>

param (
    [string]\$InputConfig = "config/services.json"
)

\$ConfigFullPath = Join-Path PSScriptRoot InputConfig

if (-not (Test-Path \$ConfigFullPath)) {
    Write-Host "[!] Configuration metadata file not found. Generating default mock blueprint layout..." -ForegroundColor Yellow
    \$MockData = @(
        @{
            service_name = "Auth-Gateway-Service"
            type         = "API Gateway"
            network_port = 8081
            tier         = "Tier-1 (Critical)"
            sla_target   = "99.99%"
            dependencies = @("User-DB-Cluster", "Redis-Session-Cache")
        },
        @{
            service_name = "User-DB-Cluster"
            type         = "Database (PostgreSQL)"
            network_port = 5432
            tier         = "Tier-1 (Critical)"
            sla_target   = "99.999%"
            dependencies = @()
        },
        @{
            service_name = "Notification-Worker"
            type         = "Background Consumer"
            network_port = 9000
            tier         = "Tier-3 (Low)"
            sla_target   = "99.0%"
            dependencies = @("RabbitMQ-Broker")
        }
    ) | ConvertTo-Json -Depth 5
    
    ConfigDir = Split-Path ConfigFullPath
    if (-not (Test-Path ConfigDir)) New-Item -ItemType Directory -Path ConfigDir | Out-Null }
    MockData | Out-File -FilePath ConfigFullPath -Encoding utf8
}

Write-Host "[*] Loading engineering blueprint configurations..." -ForegroundColor Cyan
Services = Get-Content -Path ConfigFullPath -Raw | ConvertFrom-Json

\$HtmlCardsBuffer = ""

foreach (\$service in \(Services) {\)TierColor = "#ef4444" 
    if (service.tier -like "*Tier-3*") TierColor = "#10b981" } 
    elseif (service.tier -like "*Tier-2*") TierColor = "#f59e0b" } 

    \$DepsHtml = ""
    foreach (\$dep in \(service.dependencies) {\)DepsHtml += "<span class='dep-badge'>\$dep</span>"
    }
    if ([string]::IsNullOrEmpty(DepsHtml)) DepsHtml = "<span class='dep-badge none'>None</span>" }

    \$HtmlCardsBuffer += @"
    <div class="arch-card">
        <div class="card-header">
            <span class="tier-badge" style="background-color: \$TierColor;">(service.tier)</span>
            <h2 class="service-title">(service.service_name)</h2>
            <p class="service-type">(service.type)</p>
        </div>
        <div class="card-body">
            <div class="meta-row"><strong>Network Port:</strong> <code>(service.network_port)</code></div>
            <div class="meta-row"><strong>SLA Target:</strong> <span class="sla-text">(service.sla_target)</span></div>
            <div class="deps-section">
                <strong>Outbound Dependencies:</strong>
                <div class="deps-container">\$DepsHtml</div>
            </div>
        </div>
    </div>
"@
}

\$FinalHtmlDocument = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Architecture Deployment Cards</title>
    <style>
        body { font-family: 'Segoe UI', Inter, sans-serif; background-color: #0b0f19; color: #f3f4f6; margin: 40px; }
        h1 { text-align: center; color: #ffffff; margin-bottom: 10px; font-weight: 600; }
        .subtitle { text-align: center; color: #9ca3af; margin-bottom: 40px; }
        .cards-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px; max-width: 1400px; margin: 0 auto; }
        .arch-card { background-color: #111827; border: 1px solid #1f2937; border-radius: 12px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); transition: transform 0.2s, border-color 0.2s; page-break-inside: avoid; }
        .arch-card:hover { transform: translateY(-4px); border-color: #3b82f6; }
        .card-header { position: relative; border-bottom: 1px solid #1f2937; padding-bottom: 16px; margin-bottom: 16px; }
        .service-title { margin: 0; font-size: 1.3rem; color: #ffffff; font-weight: 600; padding-right: 80px; }
        .service-type { margin: 4px 0 0 0; font-size: 0.85rem; color: #60a5fa; text-transform: uppercase; letter-spacing: 0.05em; }
        .tier-badge { position: absolute; top: 0; right: 0; font-size: 0.7rem; font-weight: bold; padding: 4px 8px; border-radius: 6px; color: #ffffff; }
        .meta-row { margin-bottom: 12px; font-size: 0.9rem; color: #d1d5db; }
        .meta-row code { background-color: #1f2937; padding: 2px 6px; border-radius: 4px; font-family: Consolas, monospace; color: #f43f5e; }
        .sla-text { color: #10b981; font-weight: bold; }
        .deps-section { margin-top: 18px; font-size: 0.9rem; }
        .deps-container { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 8px; }
        .dep-badge { background-color: #374151; color: #e5e7eb; font-size: 0.75rem; padding: 4px 10px; border-radius: 9999px; border: 1px solid #4b5563; }
        .dep-badge.none { background-color: #1f2937; color: #6b7280; border-style: dashed; }
        
        /* High-fidelity CSS Print rules for the PDF engine conversion layout */
        @media print {
            body { background-color: #ffffff; color: #000000; margin: 20px; }
            h1 { color: #000000; }
            .subtitle { color: #555555; }
            .arch-card { background-color: #ffffff; border: 1px solid #dddddd; box-shadow: none; page-break-inside: avoid; margin-bottom: 20px; }
            .service-title { color: #000000; }
            .meta-row { color: #333333; }
            .dep-badge { background-color: #eeeeee; color: #000000; border: 1px solid #cccccc; }
        }
    </style>
</head>
<body>
    <h1>System Architecture Cards</h1>
    <p class="subtitle">Infrastructure topological metadata ledger generated automatically</p>
    <div class="cards-grid">
        \$HtmlCardsBuffer
    </div>
</body>
</html>
"@

HtmlOutputPath = Join-Path PSScriptRoot "architecture-cards-dashboard.html"
PdfOutputPath = Join-Path PSScriptRoot "architecture-cards-report.pdf"

FinalHtmlDocument | Out-File -FilePath HtmlOutputPath -Encoding utf8
Write-Host "[*] HTML dashboard generated at: \$HtmlOutputPath" -ForegroundColor Green

# Native Automated Headless PDF Compilation Routine via Microsoft Edge Render Core
Write-Host "[*] Initializing automated headless PDF printing engine..." -ForegroundColor Yellow

try {
    # Find Edge executable path natively in standard systems
    EdgePath = "{env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
    if (-not (Test-Path \$EdgePath)) {
        EdgePath = "{env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe"
    }

    if (Test-Path \$EdgePath) {
        # Trigger headless background process print dump stream pipeline
        \$ProcessArgs = "--headless --disable-gpu --print-to-pdf=`"$PdfOutputPath`" `"$HtmlOutputPath`""
        Start-Process -FilePath EdgePath -ArgumentList ProcessArgs -Wait -NoNewWindow
        Write-Host "[SUCCESS] Technical architecture cards compiled into PDF report: \$PdfOutputPath" -ForegroundColor Gold
    } else {
        Write-Warning "Microsoft Edge executable path not detected. Skipping automatic PDF render compilation."
    }
} catch {
    Write-Warning "PDF engine compilation fault encountered: \$_"
}
