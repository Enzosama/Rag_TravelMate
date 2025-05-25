from dotenv import load_dotenv
load_dotenv()
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
import sys
import os
import uvicorn
from pydantic import BaseModel

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import main

app = FastAPI()
class QueryRequest(BaseModel):
    query: str

@app.post('/api/rag')
async def rag_query(request: QueryRequest):
    try:
        result = main.query(request.query)
        
        return {
            'status': 'success',
            'result': result
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get('/api/health')
async def health_check():
    return {
        'status': 'success',
        'message': 'API đang hoạt động bình thường'
    }
