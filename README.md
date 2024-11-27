This example project showcases how to package a Django application with redis, sqlite db and celery worker 
in a single docker container.

1. Build an image from the Dockerfile
```bash
docker build --platform linux/amd64 -t django-celery-redis:v1 .
```
2. Run the container
```bash
docker run -p 8000:8000 django-celery-redis:v1
```

The application has two endpoints to test out the celery worker:
1. `/trigger-task/` -- This endpoint triggers a celery task and returns the task id
2. `/collect-task-result/<task_id>/` -- This endpoint collects the result of the task with the given task id

The application relies on a supervisor to manage the Django application and the celery worker. 
The supervisor configuration could be found in the `supervisord.conf` file.