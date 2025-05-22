# Hệ thống RAG (Retrieval-Augmented Generation) với Gemini-2.5-flash

Hệ thống này triển khai mô hình RAG sử dụng AI của Google Gemini-2.5-flash để truy vấn dữ liệu từ cơ sở dữ liệu SQL chứa thông tin về tours và hotels.

## Giải thích kỹ thuật

### Tổng quan về RAG

RAG (Retrieval-Augmented Generation) là một kỹ thuật kết hợp giữa hệ thống truy xuất thông tin (Retrieval) và mô hình sinh văn bản (Generation) để tạo ra câu trả lời chính xác dựa trên dữ liệu cụ thể. Kỹ thuật này giúp khắc phục những hạn chế của các mô hình ngôn ngữ lớn (LLM) như:

- **Thiếu kiến thức cụ thể**: LLM chỉ có kiến thức từ dữ liệu huấn luyện, không có thông tin về dữ liệu riêng của tổ chức.
- **Thông tin lỗi thời**: LLM không cập nhật được thông tin mới sau thời điểm huấn luyện.
- **Hallucination**: LLM có thể tạo ra thông tin không chính xác khi không có dữ liệu tham chiếu.

### Kiến trúc hệ thống

Hệ thống RAG trong dự án này được xây dựng với các thành phần chính:

1. **Cơ sở dữ liệu SQLite**: Lưu trữ thông tin về tours và hotels.
2. **Vector Store (Chroma)**: Lưu trữ các embedding vector của dữ liệu để tìm kiếm ngữ nghĩa.
3. **LLM (Gemini-2.5-flash)**: Mô hình ngôn ngữ lớn của Google để sinh câu trả lời.
4. **API (Flask)**: Cung cấp giao diện RESTful để tương tác với hệ thống.

### Quy trình xử lý dữ liệu

#### 1. Chuẩn bị dữ liệu

- Dữ liệu từ file SQL được import vào SQLite database.
- Dữ liệu được trích xuất và tiền xử lý để chuẩn bị cho việc tạo embedding.

#### 2. Tạo Vector Store

- Dữ liệu được chuyển đổi thành các vector embedding sử dụng mô hình embedding của Google.
- Các vector này được lưu trữ trong Chroma DB để hỗ trợ tìm kiếm ngữ nghĩa.
- Vector store cho phép tìm kiếm tương tự (similarity search) dựa trên khoảng cách cosine giữa các vector.

#### 3. Quy trình RAG

Khi nhận được câu hỏi từ người dùng, hệ thống thực hiện các bước sau:

1. **Retrieval (Truy xuất)**:
   - Chuyển đổi câu hỏi thành vector embedding.
   - Tìm kiếm các đoạn văn bản tương tự nhất trong vector store.
   - Trích xuất thông tin liên quan từ cơ sở dữ liệu.

2. **Augmentation (Tăng cường)**:
   - Kết hợp thông tin truy xuất được với câu hỏi ban đầu.
   - Tạo prompt có cấu trúc để hướng dẫn mô hình LLM.

3. **Generation (Sinh nội dung)**:
   - Sử dụng Gemini-2.5-flash để sinh câu trả lời dựa trên prompt đã tăng cường.
   - Định dạng kết quả theo yêu cầu (JSON cho tours hoặc hotels).

### Tích hợp Gemini-2.5-flash

Gemini-2.5-flash là mô hình LLM mới nhất của Google, được tích hợp vào hệ thống thông qua:

- **LangChain Framework**: Cung cấp các thành phần để xây dựng ứng dụng AI.
- **Google Generative AI API**: Kết nối với dịch vụ Gemini của Google.

Ưu điểm của Gemini-2.5-flash trong hệ thống RAG:

- **Hiệu suất cao**: Xử lý nhanh với độ trễ thấp.
- **Khả năng hiểu ngữ cảnh**: Hiểu được các câu hỏi phức tạp và ngữ cảnh.
- **Định dạng đầu ra linh hoạt**: Có thể tạo ra JSON có cấu trúc theo yêu cầu.

### Tối ưu hóa hệ thống

- **Chunking**: Chia nhỏ dữ liệu thành các đoạn có kích thước phù hợp.
- **Prompt Engineering**: Thiết kế prompt hiệu quả để hướng dẫn mô hình.
- **Caching**: Lưu trữ kết quả truy vấn phổ biến để giảm độ trễ.

## Cấu trúc dự án

```
├── Data/
│   ├── datadb.sql                # File SQL chứa dữ liệu gốc
│   ├── travel_database.db        # Database SQLite được tạo từ file SQL
│   └── chroma_db/                # Thư mục lưu trữ vector store
├── route/
│   └── app.py                    # Flask API cho RAG
├── main.py                       # Module chính triển khai RAG
├── prompt.py                     # Định nghĩa các system prompt
├── test.py                       # Script kiểm tra API
└── README.md                     # Tài liệu hướng dẫn
```

## Cài đặt

1. Cài đặt các thư viện cần thiết:

```bash
pip install flask pandas google-generativeai langchain langchain-google-genai langchain-community chromadb
```

2. Cấu hình API key:

Thay thế `YOUR_GOOGLE_API_KEY` trong file `main.py` bằng API key của bạn.

## Sử dụng

### Khởi động API

```bash
python route/app.py
```

API sẽ chạy tại địa chỉ http://localhost:5000

### Kiểm tra API

```bash
python test.py
```

## API Endpoints

### 1. RAG Query

- **URL**: `/api/rag`
- **Method**: `POST`
- **Body**:
  ```json
  {
    "query": "Câu hỏi của bạn"
  }
  ```
- **Response**:
  ```json
  {
    "status": "success",
    "result": "Kết quả từ mô hình RAG"
  }
  ```
