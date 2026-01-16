**☁️ Automated AWS Resource Auditor(LocalStack Edition)**

**📌 Project Overview**

This project is a Bash-based automation tool designed toaudit and track AWS resources (EC2, S3, IAM, Lambda) without incurring anycloud costs.

It leverages **LocalStack** (a cloud service emulator) tosimulate an AWS environment locally inside Docker. The system generates atimestamped **CSV report** suitable for management review (Excel) ordownstream automation (e.g., auto-cleanup scripts). The entire auditing processis fully automated using **Cron jobs**.

**🛠️ Tech Stack**

*   **Infrastructure:** Docker, LocalStack (AWS Emulator)
    

*   **Scripting:** Bash (Shell Scripting)
    

*   **Automation:** Linux Crontab
    

*   **Tools:** AWS CLI v2, WSL 2 (Ubuntu)
    

**🚀 Key Features**

*   **Zero-Cost Simulation:** Fully mimics AWS APIs locally; no credit card required.
    

*   **Manager-Friendly Reporting:** Outputs data in structured CSV format (Service, ResourceID, Status, Details), making it readable in Excel.
    

*   **Automation Ready:** Designed to be parsed by other scripts (e.g., "Find all running EC2s and stop them").
    

*   **Scheduled Execution:** Runs automatically at set intervals using system Cron daemons.
    

**⚙️ Setup & Installation**

**1. Prerequisites**

*   Docker Desktop installed & running.
    

*   AWS CLI v2 installed.
    

*   WSL 2 (if using Windows).
    

**2. Start LocalStack**

Run the LocalStack container in the background:

```Bash

docker run --rm -it -d -p 4566:4566 -p 4510-4559:4510-4559localstack/localstack
```

**3. Configure AWS CLI (Safety Profile)**

To ensure we never accidentally connect to real AWS, weconfigure a dummy profile:

```Bash

aws configure --profile local

# AWS Access Key ID: test

# AWS Secret Access Key: test

# Region: us-east-1

# Output: json
```

**4. Create the awslocal Alias**

To avoid typing the endpoint URL repeatedly, add this aliasto ~/.bashrc:

```Bash

alias awslocal="aws--endpoint-url=http://localhost:4566"
```

```bash

source ~/.bashrc
```

**📝 Usage**

**Manual Execution**

1.  Make the script executable:
    

```Bash

chmod +x audit_script.sh
```

2.  Run the script:
    

```Bash

./audit_script.sh
```

3.  View the generated report:
    

```Bash

column -t -s, aws-resource-usage.csv
```

**Automated Execution (Cron Job)**

To schedule the audit to run **every minute**:

1.  Open the crontab editor: crontab -e
2.  Add the following line (ensure you use absolute paths):
    

```Bash

* * * * * /home/user/devops/audit\_script.sh
```

**🧠 What I Learned (TheDevOps Journey)**

**1. Cost-Effective Cloud Practice**

I learned that you don't need a corporate budget to masterAWS. By using **LocalStack**, I replicated a production-like environment(EC2, S3, IAM) locally. This allowed me to fail fast and iterate on my scriptswithout fear of billing alarms.

**2. Infrastructure as Code (IaC) Principles**

Instead of manually checking the AWS Console, I wrote ascript to "describe" the infrastructure. I learned that CLI output (JSON)is hard for humans to read, but CSV is perfect because it bridges the gapbetween **Human Readability** (Excel) and **Machine Readability** (Scriptparsing).

**3. Linux Automation**

I moved from manually running scripts to "set it andforget it" using **Cron**. I learned how system daemons work and theimportance of environment variables when running background jobs.

**⚠️ Challenges & Resolutions**

**Challenge 1: The "Real Cloud" Risk**

**Problem:** There was a risk of accidentally runningcommands against my real AWS root account, which could incur costs. **Resolution:**I configured a specific AWS CLI profile (--profile local) with dummycredentials (test/test). If I forget to point to LocalStack, the real AWSauthentication rejects the dummy keys, acting as a "Dead Man'sSwitch" to prevent accidental charges.

**Challenge 2: Data Formatting**

**Problem:** The default aws --output table looked goodin the terminal but broke when exported to a file for Excel. **Resolution:**I utilized --query to filter specific fields and standard Bash loops to formatthe output into clean **CSV**. I learned to strictly use read -r to handleraw input safely.

**Challenge 3: Cron Job Failures**

**Problem:** The script worked manually but failed whenrunning via Cron. **Resolution:** I discovered that Cron runs in a minimalenvironment and doesn't know my current directory. I fixed this by using **AbsolutePaths** (e.g., /home/afsar/script.sh) instead of relative paths.

---

**🔮 Future Scope**

*   **Alerting:** Add a feature to send an email or Slack notification if an EC2 instance is left running for more than 24 hours.
    
*   **Visualization:** Use a Python script to convert the CSV report into a visual graph.