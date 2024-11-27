from django.http import JsonResponse
from .tasks import add
from .celery import debug_task

def trigger_task(request):
    result = add.delay(4, 6)  # Trigger the Celery task
    return JsonResponse({'task_id': result.id, 'status': 'Task triggered'})

def collect_task_result(request, task_id):
    result = add.AsyncResult(task_id)
    return JsonResponse({'task_id': task_id, 'status': result.status, 'result': result.result})

def debug_task_req(request):
    result = debug_task()
    return JsonResponse({'task': str(result)})
