#Operation cannot be completed without additional quota. 
#Additional details - Location:  
#Current Limit (Free VMs): 0 
#Current Usage: 0
#Amount required for this deployment (Free VMs): 1 
#(Minimum) New Limit that you should request to enable this deployment: 1

Name: George Boboc

URL: Deployment failed with the message at the top of README.md

Stack: Node.js (Express), Azure App Service
Database: Azure SQL Database

Security:
- Disabled "Allow Azure Services"
- Database firewall allows only App Service outbound IPs
- No public access enabled

Testing:
- Open homepage
- Add items
- Refresh page to confirm persistence
