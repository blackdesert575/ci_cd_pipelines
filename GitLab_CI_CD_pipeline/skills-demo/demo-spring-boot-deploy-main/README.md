# demo-spring-boot-deploy



## Getting started

* Get JOB_ID from in your demo-spring-boot repo
![alt text](image-2.png)

* Click new pipeline to deploy spring-boot app with this "JOB_ID"

![alt text](image-5.png)

* then replace "JOB_ID from CI JOBS" with this value "13495559370",
  (For Example, we want to download the CI JOB artifact to deploy the latest version of spring-boot jar file to our Linux server)
![alt text](image-1.png)

![alt text](image-3.png)

* Wait deploy

![alt text](image-4.png)

## Docs/Tips

* [docs.gitlab.com/api/job_artifacts](https://docs.gitlab.com/api/job_artifacts/)