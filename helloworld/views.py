from flask import Flask
from prometheus_client import make_wsgi_app, Counter
from werkzeug.middleware.dispatcher import DispatcherMiddleware

app = Flask(__name__)

# Add a simple metric
REQUESTS = Counter('flask_app_requests_total', 'Total number of requests')

@app.route('/')
def hello():
    REQUESTS.inc()
    return "Hello World!"

# Add the prometheus wsgi middleware to route /metrics requests
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
