from fastapi import FastAPI, HTTPException
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import PlainTextResponse

app = FastAPI()

# quick metrics setup
hits = Counter('requests_total', 'Total requests', ['endpoint'])

# hardcoded for now - would normally be DB or config
lamps = [
    {"id": "L001", "name": "Aurora Pendant", "price": 129.99, "stock": 5},
    {"id": "L002", "name": "Nordic Floor", "price": 219.00, "stock": 12}, 
    {"id": "L003", "name": "Desk Halo", "price": 89.50, "stock": 0},
]

@app.get("/healthz")
def health():
    return {"ok": True}

@app.get("/lamps")
def get_lamps():
    hits.labels(endpoint="list").inc()
    return {"items": lamps, "count": len(lamps)}

@app.get("/lamps/{lamp_id}")
def get_lamp(lamp_id: str):
    hits.labels(endpoint="detail").inc()
    lamp = next((l for l in lamps if l["id"] == lamp_id), None)
    if not lamp:
        raise HTTPException(404, "not found")
    return lamp

@app.get("/metrics")
def metrics():
    return PlainTextResponse(generate_latest())

# TODO: add proper error handling, logging etc
