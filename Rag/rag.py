import os
from dotenv import load_dotenv
import sqlite3
import pandas as pd
import google.generativeai as genai
import sys
import os
import csv
from Rag.calculate import convert_currency
from Rag.vector_store import embeddings, create_vector_store, initialize_vectorstore, get_vectorstore, load_vectorstore, KEYWORD_MAPPINGS, analyze_query, check_and_convert_currency
from Rag import prompt

load_dotenv()

# Thêm thư mục cha vào sys.path để có thể import các module
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

model = genai.GenerativeModel('gemini-2.0-flash')

# Hàm để tạo cơ sở dữ liệu SQLite từ file SQL
def create_database_from_sql(sql_file_path, db_path):
    # Đọc nội dung file SQL
    with open(sql_file_path, 'r', encoding='utf-8') as file:
        sql_script = file.read()
    # Loại bỏ hoặc thay thế COLLATE utf8mb4_unicode_ci (không hỗ trợ trong SQLite)
    sql_script = sql_script.replace('COLLATE utf8mb4_unicode_ci', '')
    # Xử lý các cú pháp không tương thích với SQLite
    sql_script = sql_script.replace('AUTO_INCREMENT', 'AUTOINCREMENT')
    # Xử lý các cú pháp ENGINE=InnoDB
    sql_script = sql_script.replace('ENGINE=InnoDB', '')
    # Xử lý các cú pháp DEFAULT CHARSET=utf8mb4
    sql_script = sql_script.replace('DEFAULT CHARSET=utf8mb4', '')
    
    # Tạo kết nối đến SQLite database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Chia các câu lệnh SQL và thực thi từng câu một
        statements = sql_script.split(';')
        for statement in statements:
            statement = statement.strip()
            if statement:  # Chỉ thực thi các câu lệnh không rỗng
                try:
                    cursor.execute(statement)
                except sqlite3.Error as e:
                    print(f"Lỗi khi thực thi câu lệnh: {statement}\nLỗi: {e}")
        # Đóng kết nối
        conn.commit()
        print(f"Database created at {db_path}")
    except Exception as e:
        print(f"Lỗi khi tạo database: {e}")
    finally:
        conn.close()

# Hàm để trích xuất dữ liệu từ database
def extract_data_from_db(db_path):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    # Kiểm tra sự tồn tại của bảng tours
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='tours'")
    tours_exists = cursor.fetchone() is not None
    if tours_exists:
        tours_df = pd.read_sql_query("SELECT tour_id, name, description, price, duration, location, image_url, available_seats FROM tours", conn)
    else:
        tours_df = pd.DataFrame(columns=["tour_id", "name", "description", "price", "duration", "location", "image_url", "available_seats"])
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='hotels'")
    hotels_exists = cursor.fetchone() is not None
    if hotels_exists:
        hotels_df = pd.read_sql_query("SELECT hotel_id, name, description, price, location, image_url, available_seats FROM hotels", conn)
    else:
        hotels_df = pd.DataFrame(columns=["hotel_id", "name", "description", "price", "location", "image_url", "available_seats"])
    conn.close()
    return tours_df, hotels_df

# Hàm để đọc tất cả các file CSV trong thư mục Data
def extract_all_csv_data(data_dir="Data"):
    all_data = pd.DataFrame()
    # Lấy danh sách tất cả các file CSV trong thư mục Data
    csv_files = []
    for root, dirs, files in os.walk(data_dir):
        for file in files:
            if file.endswith('.csv'):
                csv_files.append(os.path.join(root, file))
    
    print(f"Đã tìm thấy {len(csv_files)} file CSV trong thư mục {data_dir}")
    
    # Đọc từng file CSV và gộp dữ liệu
    for csv_file in csv_files:
        try:
            df = pd.read_csv(csv_file)
            df = df.rename(columns={
                'ID': 'id',
                'Name': 'name',
                'Description': 'description',
                'Price': 'price',
                'Duration': 'duration',
                'Location': 'location'
            })
            df['source'] = os.path.basename(csv_file)
            all_data = pd.concat([all_data, df], ignore_index=True)
            print(f"Đã đọc file {csv_file} với {len(df)} hàng") 
        except Exception as e:
            print(f"Lỗi khi đọc file {csv_file}: {str(e)}")
    
    return all_data

# Hàm để tạo documents cho vector store 
def create_documents(tours_df, hotels_df, csv_df=None):
    documents = []
    for _, row in tours_df.iterrows():
        content = f"Tour ID: {row['tour_id']}\nName: {row['name']}\nDescription: {row['description']}\nPrice: {row['price']}\nDuration: {row['duration']}\nLocation: {row['location']}\nImage URL: {row['image_url']}\nAvailable Seats: {row['available_seats']}"
        
        # Chuyển đổi available_seats thành số để hỗ trợ tìm kiếm metadata
        try:
            available_seats = float(row['available_seats']) if pd.notna(row['available_seats']) else 0
        except (ValueError, TypeError):
            available_seats = 0
            
        metadata = {
            'type': 'tour',
            'tour_id': row['tour_id'],
            'name': row['name'],
            'description': row['description'],
            'price': row['price'],
            'duration': row['duration'],
            'location': str(row['location']),  # Đảm bảo location là chuỗi
            'image_url': row['image_url'],
            'available_seats': available_seats,  # Lưu dưới dạng số
            'data_source': 'sql'
        }
        documents.append(Document(page_content=content, metadata=metadata))
    # Tạo documents cho hotels
    for _, row in hotels_df.iterrows():
        content = f"Hotel ID: {row['hotel_id']}\nName: {row['name']}\nDescription: {row['description']}\nPrice: {row['price']}\nLocation: {row['location']}\nImage URL: {row['image_url']}\nAvailable Seats: {row['available_seats']}"
        metadata = {
            'type': 'hotel',
            'hotel_id': row['hotel_id'],
            'name': row['name'],
            'description': row['description'],
            'price': row['price'],
            'location': row['location'],
            'image_url': row['image_url'],
            'available_seats': row['available_seats'],
            'data_source': 'sql'
        }
        documents.append(Document(page_content=content, metadata=metadata))
    # Tạo documents cho dữ liệu từ CSV nếu có
    if csv_df is not None and not csv_df.empty:
        for _, row in csv_df.iterrows():
            # Xác định loại dữ liệu dựa trên các cột có sẵn
            record_type = 'unknown'
            content_parts = []
            metadata = {'data_source': 'csv'}
            
            # Thêm các trường vào content và metadata
            for col, value in row.items():
                if pd.notna(value):  # Chỉ xử lý các giá trị không phải NaN
                    # Xác định loại dữ liệu dựa trên tên cột
                    if col.lower() in ['hotel_id', 'khach_san_id', 'id']:
                        record_type = 'hotel'
                    elif col.lower() in ['tour_id']:
                        record_type = 'tour'
                    
                    # Thêm vào content
                    content_parts.append(f"{col}: {value}")
                    
                    # Xử lý các trường đặc biệt
                    col_lower = col.lower()
                    
                    # Xử lý trường available_seats hoặc tương tự
                    if col_lower in ['available_seats', 'available', 'slot', 'slots', 'chỗ trống', 'phòng trống']:
                        metadata['available_seats'] = value
                    # Xử lý các trường thông thường
                    elif col_lower in ['name', 'tên']:
                        metadata['name'] = value
                    elif col_lower in ['description', 'mô tả']:
                        metadata['description'] = value
                    elif col_lower in ['price', 'giá']:
                        metadata['price'] = value
                    elif col_lower in ['duration', 'thời gian']:
                        metadata['duration'] = value
                    elif col_lower in ['location', 'địa điểm']:
                        metadata['location'] = value
                    elif col_lower in ['image_url', 'hình ảnh']:
                        metadata['image_url'] = value
                    else:
                        # Thêm vào metadata với tên cột gốc
                        metadata[col_lower] = value
            
            # Thêm source vào content nếu có
            if 'source' in row and pd.notna(row['source']):
                content_parts.append(f"Source: {row['source']}")
                metadata['file_source'] = row['source']
            
            # Xác định loại dữ liệu dựa trên các từ khóa trong nội dung
            if record_type == 'unknown':
                content_str = '\n'.join(content_parts).lower()
                if any(keyword in content_str for keyword in ['hotel', 'khách sạn', 'phòng', 'lưu trú']):
                    record_type = 'hotel'
                elif any(keyword in content_str for keyword in ['tour', 'du lịch', 'hành trình']):
                    record_type = 'tour'
                # Nếu có địa điểm Hà Nội, Huế, v.v. thì có thể là điểm du lịch
                elif any(location in content_str for location in ['hà nội', 'huế', 'đà nẵng', 'hồ chí minh', 'sapa']):
                    # Kiểm tra thêm các từ khóa để phân biệt hotel và tour
                    if any(keyword in content_str for keyword in ['phòng', 'nghỉ', 'lưu trú']):
                        record_type = 'hotel'
                    else:
                        record_type = 'tour'
            
            # Thêm loại vào metadata
            metadata['type'] = record_type
            
            # Tạo content hoàn chỉnh
            content = '\n'.join(content_parts)
            
            # Thêm document vào danh sách
            documents.append(Document(page_content=content, metadata=metadata))
    return documents

# Sử dụng hàm create_vector_store từ vector_store.py

# Sử dụng các hàm từ vector_store.py
query_cache = {}

# Hàm RAG để truy vấn thông tin
def rag_query(query, vectorstore):
    # Kiểm tra cache trước khi thực hiện tìm kiếm
    query_key = query.lower().strip()
    if query_key in query_cache:
        print("Sử dụng kết quả từ cache")
        return query_cache[query_key]
    
    # Phân tích câu hỏi
    analysis = analyze_query(query)
    query_type = analysis['query_type']
    filter_by_availability = analysis['filter_by_availability']
    filter_by_price = analysis['filter_by_price']
    price_preference = analysis['price_preference']
    filter_by_duration = analysis['filter_by_duration']
    duration_preference = analysis['duration_preference']
    filter_by_location = analysis['filter_by_location']
    currency_conversion = analysis['currency_conversion']
    
    # Xây dựng bộ lọc metadata
    metadata_filters = {}
    # Lọc theo loại (tour hoặc hotel)
    if query_type:
        metadata_filters["type"] = query_type
    # Nếu chỉ lọc theo loại, áp dụng filter
    if query_type and not filter_by_location and not filter_by_availability:
        docs = vectorstore.similarity_search(query, k=15, filter={"type": query_type})
    # Nếu lọc theo loại và địa điểm, chỉ lọc theo loại trước, sau đó lọc theo location trên kết quả trả về
    elif query_type and filter_by_location and not filter_by_availability:
        docs = vectorstore.similarity_search(query, k=15, filter={"type": query_type})
        docs = [doc for doc in docs if filter_by_location.lower() in str(doc.metadata.get('location', '')).lower()]
    # Nếu lọc theo loại và chỗ trống, chỉ lọc theo loại trước, sau đó lọc tiếp theo chỗ trống trên kết quả trả về
    elif query_type and filter_by_availability and not filter_by_location:
        docs = vectorstore.similarity_search(query, k=15, filter={"type": query_type})
        docs = [doc for doc in docs if doc.metadata.get('available_seats', 0) and float(doc.metadata.get('available_seats', 0)) > 0]
    # Nếu lọc cả loại, địa điểm và chỗ trống, chỉ lọc theo loại trước, sau đó lọc tiếp theo location và chỗ trống trên kết quả trả về
    elif query_type and filter_by_location and filter_by_availability:
        docs = vectorstore.similarity_search(query, k=15, filter={"type": query_type})
        docs = [doc for doc in docs if filter_by_location.lower() in str(doc.metadata.get('location', '')).lower()]
        docs = [doc for doc in docs if doc.metadata.get('available_seats', 0) and float(doc.metadata.get('available_seats', 0)) > 0]
    # --- BỔ SUNG: Nếu KHÔNG có type nhưng có filter_by_availability và filter_by_location, trả về mọi entity phù hợp ---
    elif not query_type and filter_by_location and filter_by_availability:
        docs = vectorstore.similarity_search(query, k=30)
        docs = [doc for doc in docs if filter_by_location.lower() in str(doc.metadata.get('location', '')).lower()]
        docs = [doc for doc in docs if doc.metadata.get('available_seats', 0) and float(doc.metadata.get('available_seats', 0)) > 0]
    else:
        docs = vectorstore.similarity_search(query, k=15)

    # Ưu tiên trả về mọi entity phù hợp (còn chỗ trống tại Địa điểm) nếu không có khách sạn phù hợp
    filtered_docs = docs
    if query_type:
        filtered_docs = [doc for doc in docs if doc.metadata.get('type') == query_type]
        if not filtered_docs and filter_by_location and filter_by_availability:
            # Nếu không có khách sạn phù hợp, trả về mọi entity còn chỗ trống tại địa điểm đó
            filtered_docs = [doc for doc in docs if doc.metadata.get('available_seats', 0) and float(doc.metadata.get('available_seats', 0)) > 0 and filter_by_location.lower() in str(doc.metadata.get('location', '')).lower()]
    # Lọc thêm theo các tiêu chí khác nếu cần
    if filter_by_availability:
        # Lọc các documents có thông tin về chỗ trống > 0
        availability_docs = []
        for doc in filtered_docs:
            # Kiểm tra các trường liên quan đến chỗ trống
            available_fields = {
                'available_seats': doc.metadata.get('available_seats'),
                'slot': doc.metadata.get('slot'),
                'slots': doc.metadata.get('slots'),
                'available': doc.metadata.get('available'),
                'chỗ trống': doc.metadata.get('chỗ trống'),
                'phòng trống': doc.metadata.get('phòng trống')
            }
            
            # Kiểm tra tất cả các trường có thể chứa thông tin về số phòng trống
            has_availability = False
            for field_name, value in available_fields.items():
                if value and str(value).replace('.', '', 1).isdigit() and float(value) > 0:
                    has_availability = True
                    break
            
            if has_availability:
                availability_docs.append(doc)
        
        if availability_docs:
            filtered_docs = availability_docs
    
    # Lọc theo giá cả nếu có yêu cầu
    if filter_by_price:
        if price_preference:
            price_docs = []            
            
            for doc in filtered_docs:
                price_field = doc.metadata.get('price', '')
                if not price_field:
                    continue
                
                price_str = str(price_field).lower()
                
                # Kiểm tra từ khóa trong giá
                if any(keyword in price_str for keyword in price_ranges[price_preference]['keywords']):
                    price_docs.append(doc)
                    continue
                
                # Thử chuyển đổi giá thành số để so sánh khoảng giá
                try:
                    # Xử lý chuỗi giá để lấy số
                    numeric_price = ''.join(c for c in price_str if c.isdigit() or c == '.')
                    if numeric_price:
                        price_value = float(numeric_price)
                        
                        # Kiểm tra xem giá có nằm trong khoảng giá phù hợp không
                        for min_val, max_val in price_ranges[price_preference]['ranges']:
                            if float(min_val) <= price_value <= float(max_val):
                                price_docs.append(doc)
                                break
                except (ValueError, TypeError):
                    # Nếu không thể chuyển đổi thành số, bỏ qua
                    pass
            
            # Chỉ áp dụng bộ lọc nếu tìm thấy ít nhất một kết quả
            if price_docs:
                filtered_docs = price_docs
    
    # Lọc theo thời gian nếu có yêu cầu
    if filter_by_duration:
        # Nếu có yêu cầu cụ thể về thời gian, lọc theo thời gian
        if duration_preference:
            duration_docs = []
            
            # Định nghĩa các từ khóa thời gian cho từng loại
            duration_terms = {
                'short': ['giờ', 'hour', 'tự do', '6:00', '7:00', '1 ngày', 'nửa ngày', 'buổi'],
                'long': ['ngày', 'day', 'tuần', 'week', 'tháng', 'month', '2 ngày', '3 ngày'],
                'specific': [] 
            }
            
            for doc in filtered_docs:
                duration_field = doc.metadata.get('duration', '')
                if not duration_field:
                    continue
                
                duration_str = str(duration_field).lower()
                
                # Xử lý theo loại thời gian
                if duration_preference == 'specific':
                    # Thêm tất cả documents có thông tin thời gian
                    duration_docs.append(doc)
                elif any(term in duration_str for term in duration_terms[duration_preference]):
                    duration_docs.append(doc)
            
            # Chỉ áp dụng bộ lọc nếu tìm thấy ít nhất một kết quả
            if duration_docs:
                filtered_docs = duration_docs
    
    # Lọc theo địa điểm nếu có
    if filter_by_location:
        location_docs = []
        for doc in filtered_docs:
            # Kiểm tra trong các trường có thể chứa thông tin địa điểm
            location_fields = ['location', 'địa điểm', 'nơi đến', 'destination']
            
            for field in location_fields:
                location_value = doc.metadata.get(field, '')
                if location_value and filter_by_location.lower() in str(location_value).lower():
                    location_docs.append(doc)
                    break
            
            # Kiểm tra trong nội dung nếu không tìm thấy trong metadata
            if doc not in location_docs and filter_by_location.lower() in doc.page_content.lower():
                location_docs.append(doc)
        
        # Chỉ áp dụng bộ lọc nếu tìm thấy ít nhất một kết quả
        if location_docs:
            filtered_docs = location_docs
    
    # Tạo context từ các documents
    context_parts = []
    for doc in filtered_docs:
        content = doc.page_content
        # Xử lý chuyển đổi tiền tệ cho tất cả dữ liệu
        if 'price' in doc.metadata:
            # Tìm và xử lý trường price
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if any(line.lower().startswith(prefix) for prefix in ['price:', 'giá:', 'chi phí:']):
                    price_str = str(doc.metadata['price'])
                    # Sử dụng thông tin chuyển đổi tiền tệ từ phân tích câu hỏi
                    if currency_conversion == 'to_vnd':
                        try:
                            price = float(price_str)
                            converted = convert_currency(price, 'USD', 'VND')
                            lines[i] = f"{line.split(':')[0]}: {int(converted):,} VND (tương đương {price_str} USD)"
                        except (ValueError, TypeError):
                            pass
                    elif currency_conversion == 'to_usd':
                        try:
                            price = float(price_str)
                            converted = convert_currency(price, 'VND', 'USD')
                            lines[i] = f"{line.split(':')[0]}: {converted:.2f} USD (tương đương {price_str} VND)"
                        except (ValueError, TypeError):
                            pass
            content = '\n'.join(lines)
        context_parts.append(content)
    
    # Sắp xếp lại kết quả để ưu tiên các kết quả phù hợp nhất lên đầu
    # Ưu tiên theo thứ tự: loại, địa điểm, chỗ trống, giá cả, thời gian
    if len(context_parts) > 5:  # Chỉ sắp xếp nếu có nhiều kết quả
        # Giữ nguyên 5 kết quả đầu tiên (đã được sắp xếp theo độ tương đồng)
        top_results = context_parts[:5]
        # Sắp xếp các kết quả còn lại theo độ phù hợp với bộ lọc
        remaining_results = context_parts[5:]
        context_parts = top_results + remaining_results
    
    max_results = 10
    if len(context_parts) > max_results:
        context_parts = context_parts[:max_results]
    
    context = "\n\n".join(context_parts)

    if not context.strip():
        if filter_by_location and filter_by_availability and query_type == 'hotel':
            no_result_message = f"Dạ anh/chị thân mến, cảm ơn anh/chị đã quan tâm đến các khách sạn còn phòng trống tại {filter_by_location.title()}. Hiện tại chúng tôi đang cập nhật thông tin về các khách sạn còn trống chỗ ở {filter_by_location.title()}. Mong anh/chị vui lòng thử lại sau hoặc tìm kiếm ở địa điểm khác."
        elif filter_by_location and query_type:
            no_result_message = f"Hiện không có thông tin về {query_type} tại {filter_by_location.title()} trong cơ sở dữ liệu của chúng tôi. Vui lòng thử tìm kiếm ở địa điểm khác hoặc loại dịch vụ khác."
        else:
            no_result_message = "Hiện không có các kết quả phù hợp trong kho dữ liệu của chúng tôi. Vui lòng thử lại với câu hỏi khác hoặc kiểm tra lại dữ liệu."
        
        # Lưu vào cache
        query_cache[query_key] = no_result_message
        return no_result_message

    # Tạo prompt dựa trên loại truy vấn
    if query_type == 'tour':
        system_prompt = prompt.TOUR_SYSTEM_PROMPT
    elif query_type == 'hotel':
        # Nếu đang hỏi về phòng trống, thêm hướng dẫn cụ thể vào prompt
        if filter_by_availability and filter_by_location:
            # Tạo custom prompt cho câu hỏi về phòng trống tại địa điểm cụ thể
            system_prompt = prompt.HOTEL_SYSTEM_PROMPT + "\n\nĐây là câu hỏi về phòng trống tại một địa điểm cụ thể. Hãy tập trung vào việc liệt kê các khách sạn có phòng trống tại địa điểm được yêu cầu. Đảm bảo hiển thị rõ tên khách sạn và số phòng còn trống. Không trả về thông tin chung về địa điểm du lịch."
        else:
            system_prompt = prompt.HOTEL_SYSTEM_PROMPT
    else:
        system_prompt = prompt.GENERAL_SYSTEM_PROMPT
    
    # Tạo prompt hoàn chỉnh
    full_prompt = f"{system_prompt}\n\nContext:\n{context}\n\nQuestion: {query}\n"
    
    # Gọi Gemini model
    try:
        response = model.generate_content(full_prompt)
        result = response.text        
        # Lưu kết quả vào cache
        query_cache[query_key] = result
        
        return result
    except Exception as e:
        error_message = f"Đã xảy ra lỗi khi gọi Gemini model: {str(e)}"
        print(error_message)
        return error_message

# Hàm chính để khởi tạo và chạy RAG
def initialize_rag():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    sql_file_path = os.path.join(base_dir, "Data/datadb.sql")
    db_path = os.path.join(base_dir, "Data/travel_database.db")
    persist_directory = os.path.join(base_dir, "Data/chroma_db")
    data_dir = os.path.join(base_dir, "Data")
    
    # Kiểm tra xem đã có vector store chưa
    if os.path.exists(persist_directory):
        # Nếu đã có, tải vector store
        return load_vectorstore(persist_directory)
    
    # Khởi tạo DataFrames rỗng cho tours và hotels
    tours_df = pd.DataFrame(columns=["tour_id", "name", "description", "price", "duration", "location", "image_url", "available_seats"])
    hotels_df = pd.DataFrame(columns=["hotel_id", "name", "description", "price", "location", "image_url", "available_seats"])
    
    # Tạo database từ file SQL nếu chưa tồn tại và file SQL tồn tại
    if os.path.exists(sql_file_path):
        try:
            if not os.path.exists(db_path):
                create_database_from_sql(sql_file_path, db_path)
            # Trích xuất dữ liệu từ database
            tours_df_db, hotels_df_db = extract_data_from_db(db_path)
            # Gộp dữ liệu nếu trích xuất thành công
            if not tours_df_db.empty:
                tours_df = tours_df_db
            if not hotels_df_db.empty:
                hotels_df = hotels_df_db
        except Exception as e:
            print(f"Lỗi khi xử lý database SQL: {e}")
            print("Tiếp tục với dữ liệu từ CSV...")
    
    # Đọc dữ liệu từ tất cả các file CSV trong thư mục Data
    csv_df = extract_all_csv_data(data_dir)
    # Tạo documents
    documents = create_documents(tours_df, hotels_df, csv_df)
    # Tạo vector store
    vectorstore = initialize_vectorstore(documents, persist_directory)
    return vectorstore
# Khởi tạo RAG
vectorstore = None

# Hàm để truy vấn RAG
def query(question):
    vs = get_vectorstore()
    return rag_query(question, vs)

if __name__ == "__main__":
    # Khởi tạo RAG
    vs = initialize_rag()
    
    # Ví dụ truy vấn
    question = "Cho tôi biết về các tour du lịch ở Hà Nội"
    result = rag_query(question, vs)
    print(result)