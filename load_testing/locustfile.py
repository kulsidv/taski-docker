from locust import HttpUser, task, between
import random


class TaskUser(HttpUser):
    wait_time = between(1, 3)

    @task
    def create_and_delete_task(self):
        payload = {
            "title": f"locust_test_{random.randint(1000, 9999)}",
            "description": "auto",
            "completed": False,
        }

        with self.client.post(
            "api/tasks/", json=payload, catch_response=True
        ) as create_resp:
            if create_resp.status_code in [200, 201]:
                try:
                    task_id = create_resp.json().get("id")
                    create_resp.success()
                except Exception as e:
                    create_resp.failure(f"Не удалось распарсить ID: {e}")
                    return
            else:
                create_resp.failure(
                    f"Create failed: {create_resp.status_code} | {create_resp.text}"
                )
                return

        with self.client.delete(
            f"api/tasks/{task_id}/", catch_response=True
        ) as delete_resp:
            if delete_resp.status_code in [200, 204]:
                delete_resp.success()
            else:
                delete_resp.failure(
                    f"Delete failed: {delete_resp.status_code} | {delete_resp.text}"
                )
