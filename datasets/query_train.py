import pandas as pd
from datetime import datetime

# đọc file
df = pd.read_csv("train.csv")

# -------------------xử lí dữ liệu----------------------------------------
# chuyển data từ string thành datetime
df['Order Date'] = pd.to_datetime(df['Order Date'], errors = 'coerce')
# errors = 'coerce' là: khi có giá trị lỗi như 'abc' nó sẽ tự điển NaT

# loại bỏ giá trị NaT
df = df.dropna(subset = 'Order Date').reset_index(drop=True)
# dropna: bỏ các giá trị na

# xóa các giá trị xuất hiện từ tương lai
df = df[df['Order Date'] <= datetime.now()]
# datetime.now(): thời gian hiện tại

#-------------------------------------------------------------------------------------------
##Bài toán: Bạn có một bảng phụ dim_product (chứa giá vốn - Cost). 
# Hãy merge để tính Lợi nhuận (Profit) = Sales - (Cost * Quantity).
##Điều kiện: Không được làm mất bất kỳ đơn hàng nào trong bảng Sales chính.

# vì đề không có cost nên mình sẽ tự tạo(60% giá trị trung bình của sale)
dim_product = df.groupby('Product ID')['Sales'].mean().reset_index()
dim_product['Cost'] = 0.6 * dim_product['Sales']
dim_product = dim_product[['Product ID', 'Cost']]

# gộp 2 bảng để có final
df_final = df.merge(dim_product, on = 'Product ID', how='left')
assert len(df_final) == len(df)
# assert kiểm tra đk nếu lỗi thì sẽ báo

# Set lại Quantity vì không có
df_final['Quantity'] = 1
df_final['Cost'] = df_final.groupby('Category')['Cost'].transform(lambda x: x.fillna(x.median()))
# transform thay đổi giá trị khi group tuy nhiên khác apply nó vẫn sẽ để lại cột bằng với lúc ban đầu

df_final['Profit'] = df_final['Sales'] - (df_final['Cost'] * df_final['Quantity'])

#------------------------------------------------------------------------------------------
#Bài toán: Chia khách hàng thành 3 nhóm dựa trên tổng chi tiêu: 
#          VIP (> 5000), Loyal (2000 - 5000), Normal (< 2000). 
#           Sau đó đếm xem mỗi vùng (Region) có bao nhiêu khách VIP.

#tạo danh sách khách hàng và số tiền đã chi tiêu
customer_spend = df_final.groupby('Customer ID')['Sales'].sum().reset_index()

# phân loại khách hàng
bins = [0, 2000, 5000, float('inf')] # tạo khoản cho việc phân loại
labels = ['Normal', 'Loyal', 'VIP'] # tạo nhãn khi phân loại

customer_spend['Segment'] = pd.cut(customer_spend['Sales'], bins= bins, labels= labels, include_lowest=True)
# include_lowest nếu có giá trị không nằm trong khoảng thì nó sẽ ép 0 vào khoảng đầu vì pd.cut không xét số đầu

# merge vào df chính
if 'Segment' in df_final.columns:
    df_final = df_final.drop(columns=['Segment'])
# Nếu có segment thì nó sẽ thay thế cái cũ

df_final = pd.merge(df_final, customer_spend[['Customer ID', 'Segment']], on = 'Customer ID', how = 'left')
df_final['Segment'] = df_final['Segment'].astype('category')
# astype category để tính nhanh hơn thay vì là object
# Nếu muốn sort theo cái label
#df['Segment'] = pd.Categorical(
#    df['Segment'],
#    categories=['Normal', 'Loyal', 'VIP'],
#    ordered=True
#)

vip_region = df_final[df_final['Segment'] == 'VIP'].groupby('Region')['Customer ID'].nunique()
# nunique: tính các giá trị độc nhất

#print("Số khách hàng vip của mỗi vùng là: ")
#print(vip_region)
#------------------------------------------------------------------------------------------
# Bài toán: Tính tổng doanh thu theo tháng + % tăng trưởng MoM
# tạo cột Month
df_final['Month'] = df_final['Order Date'].dt.to_period('M')
# to_preiod là khi có các tháng trùng nhau vẫn phân loại được
# Nếu có cùng một năm có thể dùng .month và tương ứng

monthly_sale = df_final.groupby('Month')['Sales'].sum().reset_index()
monthly_sale = monthly_sale.sort_values('Month')

# lấy doanh thu tháng trước
monthly_sale['Prev Sales'] = monthly_sale['Sales'].shift(1)
# shift(1) nghĩa là lấy giá trị trước nó, tùy theo cái trong ngoặc

monthly_sale['MoM'] = (monthly_sale['Sales'] - monthly_sale['Prev Sales']) / monthly_sale['Prev Sales'] * 100
# có thể dùng hàm .pct_change()

#------------------------------------------------------------------------------------------
# Bài toán: Top 3 sản phẩm lợi nhuận cao nhất theo từng Region

product_profit = df_final.groupby(['Region', 'Product ID'])['Profit'].sum().reset_index()
product_profit = product_profit.sort_values(['Region', 'Profit'], ascending = [True, False])

top3_products = product_profit.groupby('Region').head(3)
# head lấy các phần tử tùy ý

print(top3_products)