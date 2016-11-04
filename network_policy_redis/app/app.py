from flask import Flask
from redis import Redis
import os
import socket

app = Flask(__name__)
host = socket.gethostname()

@app.route('/')
def hello():
    try:
        # Another user tried to give us some $$
        redis = Redis(host='redis.demos.svc.cluster.local', port=6379, socket_connect_timeout=1)
        redis.incr('moneyEarned')
    except:
        return "%s: failed to connect to redis" % host

    # $$ received - display total company funds.
    return '%s: company funds: $%s' % (host, redis.get('moneyEarned'))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
