- In `base` execute `docker build --tag yanfd-docker-base .`
- In the project folder, run `docker-compose up -d` to start the two docker containers node1 and node2.
  - node1 has IP 192.168.10.225 and node2 has 192.168.10.230
- Use `docker-compose exec node2 bash` and `docker-compse exec node1 bash` to bash into the Docker
- Use `docker-compose down -v --rmi all --remove-orphans` to shutdown the docker.

