import re
import os
import csv
import sys

# Đường dẫn đến file SQL
sql_file_path = 'datadb.sql'
# Thư mục để lưu các file CSV
output_dir = 'csv_output'

# Tạo thư mục output nếu chưa tồn tại
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Đọc nội dung file SQL
print("Đang đọc file SQL...")
with open(sql_file_path, 'r', encoding='utf-8') as file:
    sql_content = file.read()

# Hàm để trích xuất tên bảng từ câu lệnh CREATE TABLE
def extract_table_name(create_statement):
    match = re.search(r'CREATE TABLE `([^`]+)`', create_statement)
    if match:
        return match.group(1)
    return None

# Hàm để trích xuất tên cột từ câu lệnh CREATE TABLE
def extract_columns(create_statement):
    # Lấy phần nội dung giữa dấu ngoặc đơn sau CREATE TABLE
    match = re.search(r'CREATE TABLE .+?\((.+?)\)[^)]*ENGINE', create_statement, re.DOTALL)
    if not match:
        return []
    
    columns_text = match.group(1)
    
    # Tìm tất cả các định nghĩa cột (bắt đầu bằng dấu ` và theo sau là kiểu dữ liệu)
    column_matches = re.findall(r'`([^`]+)`\s+[^,\n]+', columns_text)
    
    return column_matches

# Hàm để trích xuất dữ liệu từ câu lệnh INSERT
def extract_data(insert_statement):
    # Tìm phần VALUES trong câu lệnh INSERT
    match = re.search(r'INSERT INTO .+?\s+VALUES\s+(.+?);', insert_statement, re.DOTALL)
    if not match:
        return []
    
    values_text = match.group(1)
    
    # Tách các bộ giá trị bằng cách phân tích cú pháp thủ công
    rows = []
    current_row = []
    in_string = False
    in_parentheses = 0
    current_value = ''
    
    for char in values_text:
        if char == '\'' and (len(current_value) == 0 or current_value[-1] != '\\'):
            in_string = not in_string
            current_value += char
        elif char == '(' and not in_string:
            in_parentheses += 1
            if in_parentheses == 1:  # Bắt đầu một hàng mới
                current_value = ''
            else:
                current_value += char
        elif char == ')' and not in_string:
            in_parentheses -= 1
            if in_parentheses == 0:  # Kết thúc một hàng
                if current_value:  # Thêm giá trị cuối cùng vào hàng
                    current_row.append(current_value.strip())
                rows.append(current_row.copy())  # Sử dụng copy() để tránh tham chiếu
                current_row = []
                current_value = ''
            else:
                current_value += char
        elif char == ',' and not in_string and in_parentheses == 1:
            current_row.append(current_value.strip())
            current_value = ''
        else:
            current_value += char
    
    # Xử lý các giá trị để loại bỏ dấu nháy không cần thiết
    processed_rows = []
    for row in rows:
        processed_row = []
        for value in row:
            # Loại bỏ dấu nháy đơn ở đầu và cuối nếu có
            if value.startswith('\'') and value.endswith('\''):
                value = value[1:-1]
            # Xử lý giá trị NULL
            elif value.upper() == 'NULL':
                value = ''
            processed_row.append(value)
        processed_rows.append(processed_row)
    
    return processed_rows

print("Đang phân tích cấu trúc SQL...")
# Tìm tất cả các câu lệnh CREATE TABLE
create_table_pattern = r'CREATE TABLE[\s\S]+?ENGINE=\w+[\s\S]+?;'
create_statements = re.findall(create_table_pattern, sql_content)

# Loại bỏ các câu lệnh CREATE TABLE trùng lặp
unique_create_statements = []
seen_tables = set()
for stmt in create_statements:
    table_name = extract_table_name(stmt)
    if table_name and table_name not in seen_tables:
        seen_tables.add(table_name)
        unique_create_statements.append(stmt)

print(f"Tìm thấy {len(unique_create_statements)} bảng dữ liệu.")

# Tìm tất cả các câu lệnh INSERT INTO
insert_statements = re.findall(r'INSERT INTO[\s\S]+?;', sql_content)
print(f"Tìm thấy {len(insert_statements)} câu lệnh INSERT.")

# Xóa tất cả các file CSV hiện có trong thư mục output
for file in os.listdir(output_dir):
    if file.endswith('.csv'):
        os.remove(os.path.join(output_dir, file))

# Xử lý từng bảng
for create_stmt in unique_create_statements:
    table_name = extract_table_name(create_stmt)
    if not table_name:
        continue
    
    print(f"Đang xử lý bảng: {table_name}")
    
    # Trích xuất tên cột
    columns = extract_columns(create_stmt)
    if not columns:
        print(f"  Không thể trích xuất cột cho bảng {table_name}")
        continue
    
    # Tìm các câu lệnh INSERT cho bảng này
    table_inserts = [stmt for stmt in insert_statements if f"INSERT INTO `{table_name}`" in stmt]
    
    # Trích xuất dữ liệu
    all_data = []
    for insert_stmt in table_inserts:
        rows = extract_data(insert_stmt)
        all_data.extend(rows)
    
    # Kiểm tra số lượng cột và dữ liệu
    for i, row in enumerate(all_data):
        if len(row) != len(columns):
            print(f"  Cảnh báo: Dòng {i+1} có {len(row)} giá trị nhưng có {len(columns)} cột")
            # Điều chỉnh số lượng cột nếu cần
            if len(row) < len(columns):
                row.extend([''] * (len(columns) - len(row)))
            else:
                row = row[:len(columns)]
            all_data[i] = row
    
    # Ghi dữ liệu vào file CSV
    csv_file_path = os.path.join(output_dir, f"{table_name}.csv")
    with open(csv_file_path, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(columns)  # Ghi header
        writer.writerows(all_data)  # Ghi dữ liệu
    
    print(f"  Đã tạo file CSV: {csv_file_path} với {len(all_data)} dòng dữ liệu")

print("\nHoàn thành chuyển đổi dữ liệu từ SQL sang CSV!")
print(f"Các file CSV đã được lưu trong thư mục: {os.path.abspath(output_dir)}")

# Hiển thị danh sách các file CSV đã tạo
csv_files = [f for f in os.listdir(output_dir) if f.endswith('.csv')]
print(f"\nDanh sách các file CSV đã tạo ({len(csv_files)} file):")
for csv_file in sorted(csv_files):
    file_path = os.path.join(output_dir, csv_file)
    file_size = os.path.getsize(file_path)
    with open(file_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        row_count = sum(1 for _ in reader) - 1  # Trừ đi dòng header
    print(f"  - {csv_file}: {row_count} dòng dữ liệu, {file_size} bytes")