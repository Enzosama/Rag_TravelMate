import os
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_core.documents import Document
from dotenv import load_dotenv
from Rag.calculate import convert_currency
load_dotenv()

# Đảm bảo GOOGLE_API_KEY được lấy từ biến môi trường
GOOGLE_API_KEY = os.environ.get("GOOGLE_API_KEY")
if not GOOGLE_API_KEY or GOOGLE_API_KEY == "YOUR_API_KEY_HERE":
    raise ValueError("GOOGLE_API_KEY chưa được thiết lập đúng. Vui lòng đặt biến môi trường GOOGLE_API_KEY với API key hợp lệ.")

# Khởi tạo embeddings
embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001", google_api_key=GOOGLE_API_KEY)

# Biến toàn cục để lưu vector store
vectorstore = None

# Hàm để tạo vector store
def create_vector_store(documents, persist_directory, metadatas=None):
    # Chia nhỏ documents
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    splits = text_splitter.split_documents(documents)
    
    # Tạo vector store với metadata
    vectorstore = Chroma.from_documents(
        documents=splits,
        embedding=embeddings,
        persist_directory=persist_directory,
        # Chroma tự động sử dụng metadata từ documents nếu không có metadatas được cung cấp
    )
    
    # Lưu vector store
    vectorstore.persist()
    
    return vectorstore

# Hàm để khởi tạo vector store từ documents
def initialize_vectorstore(documents, persist_directory="Data/chroma_db", metadatas=None):
    try:
        # Tạo vector store với metadata
        return create_vector_store(documents, persist_directory, metadatas)
    except Exception as e:
        print(f"Lỗi khi khởi tạo vector store: {str(e)}")
        print("\nLưu ý: Nếu lỗi liên quan đến API key, vui lòng đặt GOOGLE_API_KEY trong biến môi trường:")
        print("export GOOGLE_API_KEY=your_api_key_here")
        return None

# Hàm để lấy vector store
def get_vectorstore(documents=None, persist_directory="Data/chroma_db", filter_metadata=None):
    global vectorstore
    if vectorstore is None:
        if documents:
            vectorstore = initialize_vectorstore(documents, persist_directory)
        else:
            vectorstore = load_vectorstore(persist_directory)
    
    # Nếu có filter_metadata, trả về retriever với filter
    if filter_metadata:
        search_kwargs = {"filter": filter_metadata}
        return vectorstore.as_retriever(search_kwargs=search_kwargs)
    
    return vectorstore

# Hàm để lấy retriever với filter metadata
def get_retriever(filter_metadata=None, persist_directory="Data/chroma_db"):
    vs = get_vectorstore(persist_directory=persist_directory)
    if vs is None:
        return None
    
    # Tạo retriever với filter metadata
    search_kwargs = {}
    if filter_metadata:
        search_kwargs["filter"] = filter_metadata
    
    return vs.as_retriever(search_kwargs=search_kwargs)

# Từ điểm lưu trữ các từ khóa và ánh xạ cho việc phân tích câu hỏi
KEYWORD_MAPPINGS = {
    'tour_keywords': ['tour', 'tours', 'du lịch', 'hành trình', 'tham quan', 'dạo chơi', 'khám phá', 'tham quan', 'du ngoạn'],
    'hotel_keywords': ['hotel', 'hotels', 'khách sạn', 'phòng', 'lưu trú', 'nghỉ ngơi', 'chỗ ở', 'nhà nghỉ', 'resort', 'homestay'],
    'availability_keywords': ['còn chỗ', 'còn phòng', 'chỗ trống', 'phòng trống', 'còn slot', 'slot', 'available', 'còn trống', 'phòng', 'đặt phòng', 'đặt chỗ', 'booking'],
    'price_keywords': {
        'general': ['giá', 'price', 'chi phí', 'bao nhiêu tiền', 'rẻ', 'đắt', 'giá cả', 'phí', 'tiền', 'thanh toán'],
        'cheap': ['rẻ', 'giá rẻ', 'phải chăng', 'tiết kiệm', 'bình dân', 'hợp lý', 'kinh tế', 'không đắt'],
        'expensive': ['đắt', 'cao cấp', 'sang trọng', 'vip', 'luxury', 'premium', 'đẳng cấp', 'chất lượng cao'],
        'medium': ['trung bình', 'vừa phải', 'tầm trung', 'không rẻ không đắt']
    },
    'duration_keywords': {
        'general': ['thời gian', 'duration', 'kéo dài', 'bao lâu', 'mấy ngày', 'mấy giờ', 'lịch trình'],
        'short': ['ngắn', 'nhanh', 'ít thời gian', 'vài giờ', 'một ngày', 'ngày'],
        'long': ['dài', 'nhiều ngày', 'kéo dài', 'tour dài ngày', 'tuần', 'tháng'],
        'specific': ['cụ thể', 'chính xác', 'bao lâu', 'mấy giờ', 'mấy ngày', 'thời gian chính xác']
    },
    'locations': ['hà nội', 'đà nẵng', 'hồ chí minh', 'huế', 'hội an', 'sapa', 'nha trang', 'đà lạt', 'phú quốc', 'hạ long', 
                 'vịnh hạ long', 'cát bà', 'ninh bình', 'hải phòng', 'quy nhơn', 'phan thiết', 'mũi né', 'vũng tàu', 'cần thơ', 'côn đảo'],
    'currency_conversion': {
        'to_vnd': ['đổi sang vnd', 'chuyển sang đồng', 'đổi sang việt nam đồng', 'usd sang vnd', 'đô la sang đồng', 'đổi tiền sang vnd'],
        'to_usd': ['đổi sang usd', 'chuyển sang đô la', 'vnd sang usd', 'đồng sang đô', 'đổi tiền sang usd', 'đổi sang đô la']
    }
}

# Định nghĩa các từ khóa thời gian cho từng loại
DURATION_TERMS = {
    'short': ['giờ', 'hour', 'tự do', '6:00', '7:00', '1 ngày', 'nửa ngày', 'buổi'],
    'long': ['ngày', 'day', 'tuần', 'week', 'tháng', 'month', '2 ngày', '3 ngày'],
    'specific': [] 
}

# Định nghĩa các khoảng giá
price_ranges = {
    'cheap': {
        'keywords': ['miễn phí', 'free', '0', 'không mất phí'],
        'ranges': [('0', '100000'), ('0', '5')]
    },
    'medium': {
        'keywords': ['vừa phải', 'trung bình'],
        'ranges': [('100000', '300000'), ('5', '15')]
    },
    'expensive': {
        'keywords': ['cao cấp', 'sang trọng', 'vip', 'luxury'],
        'ranges': [('300000', '10000000'), ('15', '1000')]
    }
}

# Biến lưu cache truy vấn
query_cache = {}

# Hàm để kiểm tra và chuyển đổi tiền tệ nếu cần
def check_and_convert_currency(price_str, currency_conversion=None):
    if not currency_conversion:
        return price_str
    try:
        # Xử lý chuỗi giá để lấy số
        numeric_price = ''.join(c for c in str(price_str) if c.isdigit() or c == '.')
        if not numeric_price:
            return price_str
        price = float(numeric_price)
        # Kiểm tra loại chuyển đổi
        if currency_conversion == 'to_vnd':
            # Chuyển đổi từ USD sang VND
            converted = convert_currency(price, 'USD', 'VND')
            return f"{int(converted):,} VND (tương đương {price_str} USD)"
        elif currency_conversion == 'to_usd':
            # Chuyển đổi từ VND sang USD
            converted = convert_currency(price, 'VND', 'USD')
            return f"{converted:.2f} USD (tương đương {price_str} VND)"
    except (ValueError, TypeError) as e:
        print(f"Lỗi khi chuyển đổi tiền tệ: {e}")
    
    return price_str

# Hàm phân tích câu hỏi để xác định ý định và các tham số lọc
def analyze_query(query):
    """Phân tích câu hỏi để xác định loại truy vấn và các tham số lọc
    
    Args:
        query: Câu hỏi của người dùng
        
    Returns:
        Dict chứa các thông tin phân tích từ câu hỏi
    """
    query_lower = query.lower()
    analysis = {
        'query_type': None,  # 'tour' hoặc 'hotel'
        'filter_by_availability': False,
        'filter_by_price': False,
        'price_preference': None,  # 'cheap', 'expensive', 'medium'
        'filter_by_duration': False,
        'duration_preference': None,  # 'short', 'long', 'specific'
        'filter_by_location': None,
        'currency_conversion': None  # 'to_vnd', 'to_usd'
    }
    
    # Xác định loại truy vấn (tour hoặc hotel)
    if any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['tour_keywords']):
        analysis['query_type'] = 'tour'
    
    if any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['hotel_keywords']):
        analysis['query_type'] = 'hotel'
    
    # Kiểm tra từ khóa về chỗ trống/slot/phòng trống
    if any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['availability_keywords']):
        analysis['filter_by_availability'] = True
        # Nếu đang hỏi về chỗ trống/phòng trống và chưa xác định loại, mặc định là hotel
        if not analysis['query_type']:
            analysis['query_type'] = 'hotel'
    
    # Kiểm tra từ khóa địa điểm trước khi kiểm tra các từ khóa khác
    for location in KEYWORD_MAPPINGS['locations']:
        if location in query_lower:
            analysis['filter_by_location'] = location
            break
    
    # Xử lý trường hợp đặc biệt: "Những khách sạn còn phòng trống ở [Địa điểm]?"
    # Nếu có từ khóa về phòng trống/chỗ trống và địa điểm, đây là truy vấn về khách sạn
    if analysis['filter_by_availability'] and analysis['filter_by_location']:
        analysis['query_type'] = 'hotel'
    
    # Kiểm tra từ khóa về giá cả
    if any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['price_keywords']['general']):
        analysis['filter_by_price'] = True
        
        # Xác định mức giá ưu tiên
        for pref, keywords in {
            'cheap': KEYWORD_MAPPINGS['price_keywords']['cheap'],
            'expensive': KEYWORD_MAPPINGS['price_keywords']['expensive'],
            'medium': KEYWORD_MAPPINGS['price_keywords']['medium']
        }.items():
            if any(keyword in query_lower for keyword in keywords):
                analysis['price_preference'] = pref
                break
    
    # Kiểm tra từ khóa về thời gian
    if any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['duration_keywords']['general']):
        analysis['filter_by_duration'] = True
        
        # Xác định loại thời gian ưu tiên
        for pref, keywords in {
            'short': KEYWORD_MAPPINGS['duration_keywords']['short'],
            'long': KEYWORD_MAPPINGS['duration_keywords']['long'],
            'specific': KEYWORD_MAPPINGS['duration_keywords']['specific']
        }.items():
            if any(keyword in query_lower for keyword in keywords):
                analysis['duration_preference'] = pref
                break
    
    # Phân tích bổ sung các trường metadata khác từ câu hỏi
    # Lọc theo available_seats/chỗ trống/phòng trống
    for avail_key in ['available_seats', 'slot', 'slots', 'available', 'chỗ trống', 'phòng trống']:
        if avail_key in query_lower:
            analysis['filter_by_availability'] = True
            # Nếu đang hỏi về chỗ trống và chưa xác định loại, mặc định là hotel
            if not analysis['query_type']:
                analysis['query_type'] = 'hotel'
    
    # Lọc theo các trường metadata khác nếu có trong câu hỏi
    for meta_field in ['price', 'duration', 'location', 'name', 'description', 'image_url']:
        if meta_field in query_lower and meta_field not in analysis:
            analysis[meta_field] = True
    
    # Nếu có từ khóa về địa điểm và chưa xác định loại, kiểm tra thêm từ khóa liên quan đến khách sạn
    if analysis['filter_by_location'] and not analysis['query_type']:
        if any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['availability_keywords'] + KEYWORD_MAPPINGS['hotel_keywords']):
            analysis['query_type'] = 'hotel'
        else:
            # Mặc định là tour nếu chỉ hỏi về địa điểm
            analysis['query_type'] = 'tour'
    
    # Kiểm tra yêu cầu chuyển đổi tiền tệ
    if any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['currency_conversion']['to_vnd']):
        analysis['currency_conversion'] = 'to_vnd'
    elif any(keyword in query_lower for keyword in KEYWORD_MAPPINGS['currency_conversion']['to_usd']):
        analysis['currency_conversion'] = 'to_usd'
    
    return analysis

# Hàm để tải vector store từ đường dẫn đã lưu
def load_vectorstore(persist_directory="Data/chroma_db"):
    try:
        # Tải vector store từ đường dẫn đã lưu
        return Chroma(persist_directory=persist_directory, embedding_function=embeddings)
    except Exception as e:
        print(f"Lỗi khi tải vector store: {str(e)}")
        return None