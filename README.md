# Local Architecture Technical Card Generator 🎴⚙️

A professional, language-agnostic documentation compilation tool designed for software architects and DevOps engineers to translate system infrastructure configurations into interactive, highly readable structural **Technical Metadata Cards** and automated **PDF Reports**.

No complex UI layout environments, third-party heavy dependencies (like Node/Python/Puppeteer), or design overhead needed. It processes flat data streams natively via terminal pipes.

---

## 💡 Features

- **Declarative Architecture Modeling:** Define your backend services, databases, or workers inside a single lightweight JSON catalog file.
- **Responsive HTML Dashboards:** Compiles beautiful, dark-themed responsive card matrix layouts instantly.
- **Headless PDF Compilation:** Automatically leverages native operating system rendering cores to print a high-fidelity, clean vector PDF schema documentation book layout with a single command.
- **Color-Coded Severity Layering:** Dynamically attaches threat boundaries and color badges based on infrastructure Tier critical levels (Tier-1 down to Tier-3).

---

## 🚀 Quick Start Configuration Ledger

1. Download or drop the script generator execution block into your environment context directory.
2. Formulate your hardware/software architecture inventory mapping layout under `config/services.json`:

```json
[
  {
    "service_name": "Payment-Processor-V2",
    "type": "Transaction Core Service",
    "network_port": 8443,
    "tier": "Tier-1 (Critical)",
    "sla_target": "99.999%",
    "dependencies": ["Ledger-SQL-Database", "KMS-Encryption-Vault"]
  }
]
```

3. Fire the card compiler and PDF report builder inside your terminal console:

```powershell
.\CardGenerator.ps1 -InputConfig "config/services.json"
```

## 📊 Visual Cards Output Matrix

The compiler automatically outputs two production-ready documentation assets into your directory:
1. `architecture-cards-dashboard.html` -> High-fidelity responsive interactive UI overview dashboard.
2. `architecture-cards-report.pdf` -> Clean vector document asset suitable for corporate attachments, audits, or team printouts.
