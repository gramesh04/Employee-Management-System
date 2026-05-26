# Employee Management System - Complete Guide

## 📋 PROJECT OVERVIEW

### What This Project Does

This is a **3-Tier Web Application** for managing employees. Think of it like a company's employee database system.

#### **Key Features:**
- ✅ Add new employees
- ✅ View all employees
- ✅ Search/filter employees
- ✅ Update employee details
- ✅ Delete employee records
- ✅ Get employee count and statistics
- ✅ Search by department

#### **Real-World Use Case:**
- HR departments managing employee records
- Track employee information centrally
- Access from any browser
- Secure database storage

---

## 🏗️ ARCHITECTURE EXPLANATION

### 3-Tier Architecture (Separation of Concerns)

```
┌─────────────────────────────────────────────┐
│        PRESENTATION TIER (Frontend)         │
│  HTML/CSS/JavaScript - What User Sees       │
│  Runs in: Browser (Chrome, Firefox, etc)    │
└────────────────┬────────────────────────────┘
                 │ HTTP Requests/Responses
                 ↓
┌─────────────────────────────────────────────┐
│      APPLICATION TIER (Backend API)         │
│  Spring Boot Java - Business Logic          │
│  Runs in: Server/Computer                   │
└────────────────┬────────────────────────────┘
                 │ SQL Queries
                 ↓
┌─────────────────────────────────────────────┐
│        DATA TIER (Database)                 │
│  MySQL - Stores Employee Information        │
│  Runs in: Database Server                   │
└─────────────────────────────────────────────┘
```

### Technologies Used

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | HTML/CSS/JavaScript | User Interface |
| **Backend** | Java Spring Boot | REST API & Business Logic |
| **Database** | MySQL | Persistent Data Storage |
| **Build Tool** | Maven | Compile & Package |
| **Web Server** | Tomcat (embedded) | Serve HTTP Requests |

---

## 🚀 DEPLOYMENT OPTIONS (NON-AWS)

### Option 1: **LOCAL MACHINE** (Free, Learning)
- Deploy on your own computer
- Good for: Development, testing, learning
- Cost: FREE
- Effort: ⭐⭐ Easy

### Option 2: **HEROKU** (Easy, Free Tier Available)
- Cloud platform, very beginner-friendly
- Cost: FREE (with limitations) or $7/month
- Effort: ⭐⭐⭐ Easy
- **Recommended for beginners**

### Option 3: **RAILWAY** (Simple, Affordable)
- Similar to Heroku, modern platform
- Cost: Pay as you go ($5-10/month for hobby)
- Effort: ⭐⭐⭐ Easy
- **Good alternative to Heroku**

### Option 4: **RENDER** (Simple, Free Tier)
- Easy deployment for small projects
- Cost: FREE (with auto-pause) or paid plans
- Effort: ⭐⭐⭐ Medium
- Good for: Portfolio projects

### Option 5: **AZURE** (Enterprise, Free Trial)
- Microsoft's cloud platform
- Cost: FREE trial ($200), then paid
- Effort: ⭐⭐⭐⭐ Medium
- Good for: Enterprise environments

### Option 6: **DIGITAL OCEAN** (Affordable, Reliable)
- VPS-based deployment
- Cost: $4/month (Droplet)
- Effort: ⭐⭐⭐⭐ Medium
- Good for: Full control and customization

### Option 7: **LINODE** (Affordable, Linux-based)
- Similar to DigitalOcean
- Cost: $4-6/month
- Effort: ⭐⭐⭐⭐ Medium
- Good for: Linux environments

### Option 8: **DOCKER + ANY HOSTING** (Advanced)
- Containerize application
- Deploy anywhere that supports Docker
- Effort: ⭐⭐⭐⭐⭐ Advanced
- Cost: Varies by platform

---

## 💻 DEPLOYMENT METHODS (Step-by-Step)

---

## **METHOD 1: Deploy on Local Machine**

### Requirements:
- Java 11+ installed
- MySQL installed and running
- 10 minutes

### Steps:

#### **Step 1: Set Up Database**
```bash
# Open MySQL Command Line
mysql -u root -p

# Create database
CREATE DATABASE employee_db;
USE employee_db;

# Run schema
source "c:\Users\gande\Downloads\Project_WPEP\database\schema.sql";
```

#### **Step 2: Build Application**
```bash
cd c:\Users\gande\Downloads\Project_WPEP\java-app

# Build using Maven
mvn clean package
```

#### **Step 3: Run Application**
```bash
# Run the JAR file
java -jar target/employee-management-1.0.0.jar
```

#### **Step 4: Access Application**
- Open browser and go to: **http://localhost:8080**

---

## **METHOD 2: Deploy on HEROKU** ⭐ RECOMMENDED FOR BEGINNERS

### Why Heroku?
- One-click deployment
- Free tier available
- Minimal configuration
- Great for learning

### Requirements:
- Heroku account (free signup)
- Git installed
- Heroku CLI installed

### Steps:

#### **Step 1: Create Heroku Account**
1. Visit: https://www.heroku.com
2. Sign up (free)
3. Install Heroku CLI

#### **Step 2: Initialize Git**
```bash
cd c:\Users\gande\Downloads\Project_WPEP

# Initialize git repository
git init
git add .
git commit -m "Initial commit"
```

#### **Step 3: Create Heroku App**
```bash
# Login to Heroku
heroku login

# Create new app
heroku create your-app-name

# Replace 'your-app-name' with something unique like 'employee-mgmt-2024'
```

#### **Step 4: Add MySQL Database**
```bash
# Add ClearDB MySQL to Heroku
heroku addons:create cleardb:ignite

# Get database connection URL
heroku config | grep CLEARDB_DATABASE_URL
```

#### **Step 5: Configure Application**
Create file: `Procfile` (no extension)
```
web: java -Dserver.port=$PORT $JAVA_OPTS -jar target/employee-management-1.0.0.jar
```

Create file: `system.properties`
```
java.runtime.version=11
maven.version=3.8.1
```

#### **Step 6: Update Database Configuration**
Edit: `java-app/src/main/resources/application.properties`
```properties
# For Heroku
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Will use CLEARDB_DATABASE_URL environment variable
```

#### **Step 7: Deploy**
```bash
# Push to Heroku
git push heroku main

# OR if using master branch
git push heroku master

# View logs
heroku logs --tail

# Open application
heroku open
```

#### **Step 8: Access Application**
Your app will be live at: `https://your-app-name.herokuapp.com`

---

## **METHOD 3: Deploy on RAILWAY**

### Why Railway?
- Modern alternative to Heroku
- Better free tier
- Easier setup
- More affordable

### Requirements:
- Railway account (free signup)
- Git installed

### Steps:

#### **Step 1: Create Railway Account**
1. Visit: https://railway.app
2. Sign up with GitHub
3. Connect your GitHub account

#### **Step 2: Connect GitHub Repository**
```bash
# Push project to GitHub first
git remote add origin https://github.com/YOUR_USERNAME/project-wpep.git
git push -u origin main
```

#### **Step 3: Create Railway Project**
1. Go to https://railway.app
2. Click "New Project"
3. Select "Deploy from GitHub"
4. Choose your repository
5. Railway auto-detects it's Java/Spring Boot

#### **Step 4: Add MySQL Database**
1. In Railway dashboard
2. Click "Add Service"
3. Select "MySQL"
4. Railway provides connection string automatically

#### **Step 5: Configure Environment Variables**
Railway automatically sets:
- `DATABASE_URL` - MySQL connection string

#### **Step 6: Deploy**
- Railway auto-deploys when you push to GitHub
- Check deployment logs in dashboard

#### **Step 7: Access Application**
Railway provides a public URL automatically

---

## **METHOD 4: Deploy on DIGITAL OCEAN (VPS)**

### Why DigitalOcean?
- Full control
- Very affordable ($4/month)
- Reliable infrastructure
- Great for production

### Requirements:
- DigitalOcean account ($5 credit free)
- SSH knowledge (or use their console)

### Steps:

#### **Step 1: Create DigitalOcean Account**
1. Visit: https://www.digitalocean.com
2. Sign up and create account

#### **Step 2: Create Droplet**
1. Click "Create" → "Droplets"
2. Choose "Ubuntu 22.04"
3. Select $4/month plan
4. Choose region closest to you
5. Click "Create"

#### **Step 3: Connect to Droplet**
```bash
# SSH into your droplet (get IP from DO dashboard)
ssh root@YOUR_DROPLET_IP

# Update system
apt update && apt upgrade -y

# Install Java
apt install openjdk-11-jdk -y

# Install MySQL
apt install mysql-server -y

# Start MySQL
mysql_secure_installation
```

#### **Step 4: Upload Project**
```bash
# From your local machine
# Copy project to server
scp -r java-app root@YOUR_DROPLET_IP:/home/java-app

# SSH into server
ssh root@YOUR_DROPLET_IP

# Navigate to project
cd /home/java-app

# Install Maven
apt install maven -y

# Build project
mvn clean package
```

#### **Step 5: Set Up Database**
```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE employee_db;

# Exit
exit

# Import schema
mysql -u root -p employee_db < /home/java-app/database/schema.sql
```

#### **Step 6: Run Application**
```bash
# Run application
java -jar /home/java-app/target/employee-management-1.0.0.jar &

# The & runs it in background
# Access at: http://YOUR_DROPLET_IP:8080
```

#### **Step 7: Keep Running (Optional)**
```bash
# Install systemd service to auto-start

cat > /etc/systemd/system/employee-app.service << EOF
[Unit]
Description=Employee Management System
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/home/java-app
ExecStart=/usr/bin/java -jar /home/java-app/target/employee-management-1.0.0.jar
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
systemctl daemon-reload
systemctl enable employee-app
systemctl start employee-app
```

---

## **METHOD 5: Deploy with DOCKER** (Advanced)

### Create Dockerfile

Create file: `Dockerfile` in project root
```dockerfile
# Build stage
FROM maven:3.8.1-openjdk-11 AS build
WORKDIR /app
COPY java-app .
RUN mvn clean package

# Runtime stage
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/employee-management-1.0.0.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

### Build Docker Image
```bash
docker build -t employee-app:1.0.0 .
```

### Run Locally
```bash
docker run -p 8080:8080 --name employee-app employee-app:1.0.0
```

### Push to Docker Hub
```bash
# Tag image
docker tag employee-app:1.0.0 YOUR_USERNAME/employee-app:1.0.0

# Push
docker push YOUR_USERNAME/employee-app:1.0.0

# Deploy anywhere with Docker support
```

---

## 🔧 TROUBLESHOOTING

### Application won't start?
```bash
# Check logs
heroku logs --tail                    # For Heroku
docker logs container-name           # For Docker

# Common issue: Database not connected
# Solution: Check DATABASE_URL environment variable
```

### Port already in use?
```bash
# Change port in application.properties
server.port=8090
```

### MySQL connection error?
```bash
# Verify MySQL is running
mysql -u root -p -e "SELECT VERSION();"

# Check connection string format
spring.datasource.url=jdbc:mysql://HOST:3306/DATABASE
```

---

## 📊 DEPLOYMENT COMPARISON

| Method | Cost | Difficulty | Best For |
|--------|------|-----------|----------|
| **Local** | FREE | ⭐ Easy | Learning, testing |
| **Heroku** | FREE/month | ⭐⭐ Easy | Quick deployment |
| **Railway** | ~$5/month | ⭐⭐ Easy | Modern alternative |
| **DigitalOcean** | $4/month | ⭐⭐⭐ Medium | Full control |
| **Azure** | $200 trial | ⭐⭐⭐ Medium | Enterprise |
| **Docker** | Varies | ⭐⭐⭐⭐ Hard | Containerization |

---

## 📱 API ENDPOINTS REFERENCE

```
GET    /api/employees              - Get all employees
GET    /api/employees/{id}         - Get single employee
GET    /api/employees/search?name=John    - Search employees
GET    /api/employees/department/IT       - Get by department
POST   /api/employees              - Create employee
PUT    /api/employees/{id}         - Update employee
DELETE /api/employees/{id}         - Delete employee
GET    /api/employees/health       - Health check
```

---

## ✅ QUICK START RECOMMENDATION

**For Beginners:** Start with **Local Deployment** → then **Heroku**

**For Learning:** **Railway** (easiest modern option)

**For Production:** **DigitalOcean** (most affordable reliable option)

---

## 📞 NEED HELP?

- Check project logs for errors
- Verify database is connected
- Ensure Java 11+ is installed
- Make sure MySQL is running

