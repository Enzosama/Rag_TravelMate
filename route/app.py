from dotenv import load_dotenv
load_dotenv()
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
import sys
import os
import uvicorn
from pydantic import BaseModel

# Thêm thư mục gốc vào sys.path để import các module
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Import module RAG
import main

app = FastAPI()

# Định nghĩa model cho request
class QueryRequest(BaseModel):
    query: str

@app.post('/api/rag')
async def rag_query(request: QueryRequest):
    try:
        # Gọi hàm query từ module main
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

if __name__ == '__main__':
    # Khởi tạo vector store trước khi chạy server
    main.get_vectorstore()
    # Chạy Uvicorn server
    uvicorn.run(app, host='0.0.0.0', port=5000)