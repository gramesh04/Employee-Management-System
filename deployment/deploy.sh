#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
# Employee Management System - Linux Deployment Script
# ═══════════════════════════════════════════════════════════════════
# 
# Run this script on EC2 Ubuntu instance to set up the application
# Usage: bash deploy.sh
# ═══════════════════════════════════════════════════════════════════

set -e  # Exit on error

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  Employee Management System - Auto Deployment                 ║"
echo "║  Target: AWS EC2 Ubuntu Instance                              ║"
echo "╚═══════════════════════════════════════════════════════════════╝"

# ═══════════════════════════════════════════════════════════════════
# 1. UPDATE SYSTEM
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "📦 Step 1: Updating system packages..."
sudo apt update
sudo apt upgrade -y
echo "✓ System updated"

# ═══════════════════════════════════════════════════════════════════
# 2. INSTALL JAVA
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "☕ Step 2: Installing Java JDK 11..."

if command -v java &> /dev/null; then
    echo "✓ Java already installed: $(java -version 2>&1 | head -1)"
else
    sudo apt install -y openjdk-11-jdk-headless
    echo "✓ Java installed"
fi

java -version

# ═══════════════════════════════════════════════════════════════════
# 3. INSTALL GIT
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "📝 Step 3: Installing Git..."

if command -v git &> /dev/null; then
    echo "✓ Git already installed: $(git --version)"
else
    sudo apt install -y git
    echo "✓ Git installed"
fi

# ═══════════════════════════════════════════════════════════════════
# 4. INSTALL MYSQL CLIENT
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "🗄️  Step 4: Installing MySQL client..."

if command -v mysql &> /dev/null; then
    echo "✓ MySQL client already installed"
else
    sudo apt install -y mysql-client
    echo "✓ MySQL client installed"
fi

# ═══════════════════════════════════════════════════════════════════
# 5. CLONE PROJECT (OPTIONAL - if not already cloned)
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "📥 Step 5: Cloning project from GitHub..."

if [ ! -d "employee-management" ]; then
    # Replace with your GitHub URL
    # git clone https://github.com/your-username/employee-management.git
    echo "⚠️  Git clone URL not configured in script"
    echo "   Please manually clone the repository:"
    echo "   git clone https://github.com/your-username/employee-management.git"
else
    echo "✓ Project already cloned"
fi

# ═══════════════════════════════════════════════════════════════════
# 6. BUILD APPLICATION
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "🔨 Step 6: Building application with Maven..."

cd employee-management/03_JAVA_APPLICATION

# Check if mvn is installed
if command -v mvn &> /dev/null; then
    echo "✓ Maven already installed: $(mvn --version | head -1)"
else
    echo "⚠️  Maven not installed. Installing..."
    sudo apt install -y maven
fi

# Build
mvn clean package -DskipTests

if [ -f "target/employee-management-1.0.0.jar" ]; then
    echo "✓ Application built successfully"
else
    echo "❌ Build failed!"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════════
# 7. CREATE SYSTEMD SERVICE
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "🔧 Step 7: Creating systemd service..."

SERVICE_FILE="/etc/systemd/system/employee-app.service"
APP_PATH="/home/ubuntu/employee-management/03_JAVA_APPLICATION"

sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=Employee Management Application
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=$APP_PATH
ExecStart=/usr/bin/java -jar $APP_PATH/target/employee-management-1.0.0.jar
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=employee-app

[Install]
WantedBy=multi-user.target
EOF

echo "✓ Service file created"

# ═══════════════════════════════════════════════════════════════════
# 8. CONFIGURE APPLICATION
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "⚙️  Step 8: Application Configuration"
echo "   Edit src/main/resources/application.properties with:"
echo "   - RDS endpoint URL"
echo "   - Database username"
echo "   - Database password"
echo ""
echo "   Then rebuild: mvn clean package"

# ═══════════════════════════════════════════════════════════════════
# 9. ENABLE AND START SERVICE
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "🚀 Step 9: Starting application service..."

sudo systemctl daemon-reload
sudo systemctl enable employee-app
sudo systemctl start employee-app

echo "✓ Service started"

# ═══════════════════════════════════════════════════════════════════
# 10. VERIFY DEPLOYMENT
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "✅ Step 10: Verifying deployment..."

sleep 3

SERVICE_STATUS=$(sudo systemctl is-active employee-app)
echo "   Service Status: $SERVICE_STATUS"

if [ "$SERVICE_STATUS" = "active" ]; then
    echo "   ✓ Application is running!"
else
    echo "   ⚠️  Service not active yet, checking logs..."
    sudo journalctl -u employee-app -n 20
fi

# ═══════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                  DEPLOYMENT COMPLETE ✓                        ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Summary:"
echo "   • Java: $(java -version 2>&1 | grep version | head -1)"
echo "   • Git: $(git --version)"
echo "   • Build: ✓ Complete"
echo "   • Service: ✓ Running"
echo ""
echo "🌐 Next Steps:"
echo "   1. Get your EC2 public IP from AWS Console"
echo "   2. Access: http://<PUBLIC_IP>:8080"
echo "   3. API: http://<PUBLIC_IP>:8080/api/employees"
echo ""
echo "📝 Useful Commands:"
echo "   • View logs: sudo journalctl -u employee-app -f"
echo "   • Stop service: sudo systemctl stop employee-app"
echo "   • Start service: sudo systemctl start employee-app"
echo "   • Restart: sudo systemctl restart employee-app"
echo ""
echo "🔧 Configuration:"
echo "   • Config file: src/main/resources/application.properties"
echo "   • Rebuild: mvn clean package"
echo "   • Restart service after rebuild: sudo systemctl restart employee-app"
echo ""
