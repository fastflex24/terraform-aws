#!/bin/bash
# Update the package repository
yum update -y

# Install the Apache HTTP server
yum install -y httpd

# Start the Apache HTTP server
service httpd start

# Enable Apache to start on boot
chkconfig httpd on

# Create a sample index.html file
echo "<html>
<head>
    <title>Welcome to My EC2 Instance</title>
</head>
<body>
    <h1>Hello from EC2!</h1>
    <p>This is a sample page served by Apache HTTP Server.</p>
</body>
</html>" > /var/www/html/index.html