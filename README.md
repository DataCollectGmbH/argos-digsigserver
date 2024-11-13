# Instructions

check the workflow under .github/workflows/build-push.yml which builds the the containers automatically after push.

This Final docker Image is designed to use s3 bucket automatically. So in order to pass aws login credentials we use .env while starting the container as logging happens in runtime after building the container. If you need to start the resulting Image on a building self hosted runner such as: github-actions. 

```
AWS_ACCESS_KEY_ID=<aws-access-key-id>
AWS_SECRET_ACCESS_KEY=<aws-secret-access-key>
AWS_DEFAULT_REGION=<aws-default-region>
DIGSIGSERVER_KEYFILE_URI=s3://tegrasign
```

save the .env file on self-hosted runner and then run the following command on the self-hosted runner.
`docker run -d --rm -p 9999:9999 --env-file <path-to-.env file> ghcr.io/datacollectgmbh/docker-final-image-digsigserver:l4t-r35.6.0`

# NOTICE
In order to enable the -container which runs on Github-actions to have access to localhost network we have to enable the host network to that yocto building container, but this applies to container option not services.

```
container:
      options: --add-host=host.docker.internal:host-gateway
```

