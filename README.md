#  CI/CD Pipeline for Dockerized Node.js App Using Jenkins

This project demonstrates a complete CI/CD pipeline for a simple Node.js application using Jenkins and Docker. Infrastructure is provisioned using Terraform on AWS, and Jenkins automates the build and deployment process of a Dockerized app.

---

##  Project Structure

```
ci-cd-nodejs-jenkins/
│
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── terraform.tfvars
│ ├── outputs.tf
│ ├── ci-cd-nodejs-key
│ └── ci-cd-nodejs-key.pub
│
├── app/
│ ├── index.js
│ ├── package.json
│ ├── Dockerfile
│ └── Jenkinsfile
│
├── .gitignore
└── README.md 
```


---

## Tools & Services Used

- **Terraform** – Infrastructure as Code
- **AWS EC2** – Host Jenkins and the app
- **Jenkins** – CI/CD Automation
- **Docker** – Containerize the Node.js app
- **GitHub** – Source Code Management

---

## Infrastructure Setup with Terraform

**Clone the repo**:

```bash
git clone https://github.com/Shravani3001/ci-cd-nodejs-jenkins.git
cd ci-cd-nodejs-jenkins
```

**SSH key pair generated using**:

```bash
ssh-keygen -t rsa -b 4096 -f ci-cd-nodejs-key
```

**Provision an EC2 instance in a public subnet using**:

```bash
- terraform init
- terraform plan
- terraform apply
```

Output includes the public IP of the EC2 instance.

### Jenkins & Docker Installation (Run on EC2)

**SSH into the EC2 instance using**:

```bash
ssh -i ./ci-cd-nodejs-key ubuntu@public-ip
```

### Run the following to install Docker and Jenkins:

```bash
# Update
sudo apt update -y
sudo apt upgrade -y

# Install Docker
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# Update & Install Java & Jenkins
sudo apt update -y
sudo apt install -y curl gnupg2 fontconfig openjdk-17-jdk

# Add Jenkins GPG key
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repo
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update APT again with Jenkins repo
sudo apt update -y

# Install Jenkins
sudo apt install -y jenkins

# Start & enable Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check status
sudo systemctl status jenkins

# Jenkins Docker permission
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

## Jenkins Configuration

**Access Jenkins**:

Open http://public-ip:8080 in your browser.

### Unlock Jenkins

After opening Jenkins in your browser at http://<public-ip>:8080, you will see a screen asking for the Administrator password.

Run the following command on the instance

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Copy the password and paste it into the Jenkins setup screen.

### Create Admin User

Once unlocked, Jenkins will prompt you to:

Set up a new admin username and password

Provide full name and email

Then click Save and Continue

This step ensures secure access and completes Jenkins’ initial setup.

### Install the following plugins:

- **Docker Pipeline**
- **Docker Commons**
- **GitHub Integration**
- **Blue Ocean**
- **Git Parameter Plugin**
- **NodeJS Plugin**
- **Pipeline: GitHub or Git**
- **Pipeline: Stage View**

## Create a Docker Hub Personal Access Token**

- Log in to Docker Hub
- Click on your profile icon Go to "Account Settings"
- click on "Personal cccess tokens"
- Now click on "Generate new token"
- Provide "Access token description", such as jenkins-deploy-token
- Select "Expiration date"
- Set "Access permissions to "Read, Write, Delete"
- Click "Generate"
- Copy the generated token and save it securely
- Use this token as the password when adding DockerHub credentials in Jenkins

### Add DockerHub credentials:

- Username: your DockerHub username
- Password: DockerHub Personal Access Token
- ID: dockerhub-credentials

## GitHub Integration & Pipeline Setup

**Push the project to GitHub**

- Create a Public GitHub Repository
- Go to GitHub and create a new public repository named ci-cd-nodejs-jenkins

**Push Your Project Folder to GitHub**

In your terminal, navigate to the root of your project folder and run:

```bash
git init
git remote add origin https://github.com/your-username/ci-cd-nodejs-jenkins.git
git add .
git commit -m "Initial commit for CI/CD Node.js app with Jenkins and Terraform"
git push -u origin main
```

**Make sure to replace your-username with your actual GitHub username**

### Set up the Jenkins pipeline

- Go to Jenkins → New Item → Enter a name → Select Pipeline
- Under Pipeline script from SCM:
- SCM: Git
- Repository URL: your GitHub repo URL
- In the "Branch Specifier" field under Pipeline script from SCM, change the default value from */master to */main to match your GitHub branch name.
- Script Path: app/Jenkinsfile
- Click Save, then Build Now

## Outcome

- Jenkins pulls the Node.js app from GitHub.
- Builds a Docker image.
- Pushes the image to Docker Hub.
- You now have a full CI/CD flow with Infrastructure as Code.

### Author
Shravani K

LinkedIn: www.linkedin.com/in/shravani-k-25953828a

DevOps Learner
