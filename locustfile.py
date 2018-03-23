from locust import HttpLocust, TaskSet

def index(l):
    l.client.get("/")

class UserBehavior(TaskSet):
    tasks = {index: 1}

    def on_start(self):
        pass


class SimpleUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 0
    max_wait = 1