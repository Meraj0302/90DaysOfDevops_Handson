import os
import time

import psycopg2
import redis
from flask import Flask, jsonify

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST", "db")
DB_NAME = os.environ.get("DB_NAME", "appdb")
DB_USER = os.environ.get("DB_USER", "appuser")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "apppassword")

REDIS_HOST = os.environ.get("REDIS_HOST", "cache")
REDIS_PORT = int(os.environ.get("REDIS_PORT", 6379))

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


def get_db_connection(retries=5, delay=2):
    """Connect to Postgres, retrying a few times in case it's still starting up."""
    last_error = None
    for attempt in range(retries):
        try:
            conn = psycopg2.connect(
                host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD
            )
            return conn
        except psycopg2.OperationalError as e:
            last_error = e
            time.sleep(delay)
    raise last_error


def init_db():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS visits (
            id SERIAL PRIMARY KEY,
            created_at TIMESTAMP DEFAULT NOW()
        );
        """
    )
    conn.commit()
    cur.close()
    conn.close()


@app.route("/")
def hello():
    # Redis: simple hit counter (fast, in-memory)
    hits = r.incr("hit_counter")

    # Postgres: log a visit row (durable, persisted)
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO visits DEFAULT VALUES;")
    conn.commit()
    cur.execute("SELECT COUNT(*) FROM visits;")
    total_visits = cur.fetchone()[0]
    cur.close()
    conn.close()

    return jsonify(
        {
            "message": "Hello from Flask + Postgres + Redis!",
            "redis_hit_counter": hits,
            "postgres_total_visits": total_visits,
            "served_by": os.environ.get("HOSTNAME", "unknown"),
        }
    )


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)
