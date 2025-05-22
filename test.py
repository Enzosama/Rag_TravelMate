import requests
import json
import os

# URL của API
API_URL = "http://localhost:5000/api/rag"

# Hàm để gửi câu hỏi đến API
def test_rag_api(query):
    # Tạo payload
    payload = {
        "query": query
    }
    
    # Gửi request POST đến API
    try:
        response = requests.post(API_URL, json=payload)
        
        # Kiểm tra status code
        if response.status_code == 200:
            # Parse JSON response
            result = response.json()
            print(f"Status: {result['status']}")
            print(f"Result: {result['result']}")
            return result
        else:
            print(f"Error: {response.status_code}")
            print(response.text)
            return None
    except Exception as e:
        print(f"Exception: {str(e)}")
        return None

# Hàm để kiểm tra health check endpoint
def test_health_check():
    try:
        response = requests.get("http://localhost:5000/api/health")
        print(f"Health Check Status: {response.status_code}")
        print(response.json())
        return response.json()
    except Exception as e:
        print(f"Health Check Exception: {str(e)}")
        return None

# Hàm main để chạy các test
def main():
    print("=== Kiểm tra Health Check API ===")
    test_health_check()
    
    print("\n=== Kiểm tra RAG API với câu hỏi về tour ===")
    test_rag_api("Cho tôi biết về các tour du lịch ở Hà Nội")
    
    print("\n=== Kiểm tra RAG API với câu hỏi về khách sạn ===")
    test_rag_api("Có những khách sạn nào ở Đà Lạt?")
    
    print("\n=== Kiểm tra RAG API với câu hỏi chung ===")
    #test_rag_api("Tôi muốn đi du lịch ở Đà Nẵng, có gợi ý gì không?")
    test_rag_api("Cho tôi biết về các khách sản còn trống chỗ ở Đà Nẵng")

if __name__ == "__main__":
    # Kiểm tra xem API đã được khởi động chưa
    print("Đảm bảo rằng API đã được khởi động với lệnh: python route/app.py")
    input("Nhấn Enter để tiếp tục sau khi API đã được khởi động...")
    
    # Chạy các test
    main()