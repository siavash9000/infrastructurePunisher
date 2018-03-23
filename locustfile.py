from locust import HttpLocust, TaskSet

def index(l):
    l.client.get("/")

def story(l):
    l.client.get("/netlimy/2018/02/25/welcome-to-netlimy")

def wrong_url(l):
    l.client.get("/netlimy/i/dont/exist")


class UserBehavior(TaskSet):
    tasks = {index: 100, story: 100, wrong_url: 1}

    def on_start(self):
        pass


class SimpleUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 0
    max_wait = 1