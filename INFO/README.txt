Had a few issues.

Had an issue with the Django container running on digitalocean and fixed this with sudo apt install qemu-user-static.
This is because M1 chips have issues running containers and images on DigitalOcean. (the architecture is not fully compatible.

Web app works locally and stores information about the users including the form info, date the user was created and the last location.

Tested and it has responsive design on phone screens (used fn key and f12 in the browser to test for responsive design.

nginx, certbot, digitalocean and dockerhub all up and running.

ssh keys working fine .

Could not deploy due to an error, screenshot attached showing the issue.

I also used the domain name propelhealth.online because since i was paying for the domain name, I was going to use it for my FYP :)