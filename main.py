import os
import pandas as pd
import glob
from langchain_core.documents import Document
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma

from Rag.rag import rag_query, embeddings

# Biến toàn cục để lưu vector store
vectorstore = None

# Hàm để đọc tất cả các file CSV trong thư mục Data
def read_all_csv_files(directory="Data"):
    # Tìm tất cả các file CSV trong thư mục Data và các thư mục con
    csv_files = glob.glob(os.path.join(directory, "**/*.csv"), recursive=True)
    
    print(f"Đã tìm thấy {len(csv_files)} file CSV trong thư mục {directory}")
    
    # Đọc và xử lý từng file CSV
    documents = []
    for csv_file in csv_files:
        try:
            # Đọc file CSV
            df = pd.read_csv(csv_file, encoding='utf-8')
            
            # Lấy tên file không có đường dẫn và phần mở rộng
            file_name = os.path.basename(csv_file).replace('.csv', '')
            
            # Chuyển đổi mỗi hàng thành một document
            for _, row in df.iterrows():
                # Tạo nội dung từ tất cả các cột
                content = f"Table: {file_name}\n"
                for col, value in row.items():
                    content += f"{col}: {value}\n"
                
                # Tạo metadata
                metadata = {
                    'source': csv_file,
                    'table': file_name
                }
                
                # Thêm các trường quan trọng vào metadata nếu có
                for key in ['name', 'description', 'price', 'location', 'image_url']:
                    if key in row:
                        metadata[key] = row[key]
                # Thêm các trường liên quan đến chỗ trống/chỗ/phòng
                for avail_key in ['available_seats', 'slot', 'slots', 'available', 'chỗ trống', 'phòng trống']:
                    if avail_key in row:
                        metadata['available_seats'] = row[avail_key]
                
                # Thêm document vào danh sách
                documents.append(Document(page_content=content, metadata=metadata))
            
            print(f"Đã đọc file {csv_file} với {len(df)} hàng")
        except Exception as e:
            print(f"Lỗi khi đọc file {csv_file}: {str(e)}")
    
    return documents

# Hàm để tạo vector store từ documents
def create_vector_store(documents, persist_directory="Data/chroma_db"):
    # Chia nhỏ documents
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    splits = text_splitter.split_documents(documents)
    
    print(f"Đã tạo {len(splits)} chunks từ {len(documents)} documents")
    
    # Tạo vector store
    vectorstore = Chroma.from_documents(
        documents=splits,
        embedding=embeddings,
        persist_directory=persist_directory
    )
    
    # Lưu vector store
    vectorstore.persist()
    
    return vectorstore

# Hàm để khởi tạo vector store
def initialize_vectorstore():
    try:
        # Đọc tất cả các file CSV
        documents = read_all_csv_files()
        
        # Tạo vector store
        return create_vector_store(documents)
    except Exception as e:
        print(f"Lỗi khi khởi tạo vector store: {str(e)}")
        print("\nLưu ý: Nếu lỗi liên quan đến API key, vui lòng đặt GOOGLE_API_KEY trong biến môi trường:")
        print("export GOOGLE_API_KEY=your_api_key_here")
        return None

# Hàm để lấy vector store
def get_vectorstore():
    global vectorstore
    if vectorstore is None:
        vectorstore = initialize_vectorstore()
    return vectorstore

# Hàm để truy vấn RAG
def query(question):
    vs = get_vectorstore()
    if vs is None:
        return "Không thể khởi tạo vector store. Vui lòng kiểm tra API key và thử lại."
    return rag_query(question, vs)

if __name__ == "__main__":
    # Khởi tạo vector store
    vs = get_vectorstore()
    
    # Ví dụ truy vấn
    question = "Những khách sạn đang có phòng trống"
    result = query(question)
    print(result)