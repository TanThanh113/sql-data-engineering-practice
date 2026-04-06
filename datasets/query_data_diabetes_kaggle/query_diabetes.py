import pandas as pd
import numpy as np

df = pd.read_csv('archive/diabetes.csv')

# lệnh xem cột của data (df.info())

#--------------------------------------------------------------------------------------------------------------------
# 1. Xử lý dữ liệu "vô lý": Trong y tế, BMI hay BloodPressure bằng $0$ là vô lý (lỗi nhập liệu). 
# Hãy thay thế các giá trị $0$ này bằng NaN và sau đó điền bằng trung vị (median) của nhóm tuổi đó.

# Đổi các giá trị từ 0 thành NaN
col_replace = ['Glucose', 'BloodPressure', 'BMI']
df[col_replace] = df[col_replace].replace(0, np.nan)

# Đổi giá trị thành median của nhóm tuổi đó
df['Age_Group'] = (df['Age'] // 10 ) * 10
for col in col_replace:
    df[col] = df.groupby('Age_Group')[col].transform(lambda x: x.fillna(x.median()))

#--------------------------------------------------------------------------------------------------------------------
# 2. Tạo nhóm nguy cơ (Risk Group): Chia BMI thành 4 nhóm: 
# Underweight (<18.5), Normal (18.5-25), Overweight (25-30), Obese (>30).

# Tạo khoảng để chia
bins = [0, 18.5, 25, 30, float('inf')]
# Tạo nhãn cho nó
labels = ['Underweight', 'Normal', 'Overweight', 'Obese']

# Chia nhóm theo những gì mình tạo
df['BMI_Group'] = pd.cut(df['BMI'], bins = bins, labels = labels, right = True)

#-------------------------------------------------------------------------------------------------------------------
# 3. Phân tích mối tương quan (Correlation): Tính xem chỉ số Glucose trung bình 
# của nhóm Obese cao hơn nhóm Normal bao nhiêu %.

# Tính trung bình của từng nhóm đối tượng
glucose_mean = df.groupby('BMI_Group')['Glucose'].mean()

# Tính xem để coi lệch bao nhiêu %
diff_mean = ((glucose_mean['Obese'] - glucose_mean['Normal']) / glucose_mean['Normal'] * 100).round(2)
print(f"Chỉ số trung bình của Obese cao hơn Normal là: {diff_mean}%")

#-------------------------------------------------------------------------------------------------------------------
# 4. Lọc dữ liệu "Báo động đỏ": Lấy danh sách những người trên 50 tuổi, có BMI Obese 
# và đang bị tiểu đường (Outcome = 1).

# Tạo dataframe chứa các bệnh nhân có báo động đỏ
red_alert = df[(df['Age'] > 50) & (df['Outcome'] == 1) & (df['BMI_Group'] == 'Obese')]
print(f"Số người dính mức báo động đỏ là: {len(red_alert)}")

#-------------------------------------------------------------------------------------------------------------------
# 5. Báo cáo tổng hợp: Tính tỷ lệ (%) bị tiểu đường trên mỗi nhóm Age (chia theo thập kỷ: 20s, 30s, 40s...).

## Cách khác để tạo ra nhóm tuổi
# Tạo theo nhóm tuổi và xếp theo đó
# bins2 = np.linspace(0, 100, 11)
# labels2 = [f'U{i}' for i in range(0, 100, 10)]
# df['Age_Group'] = pd.cut(df['Age'], bins = bins2, labels = labels2, right = False)

# Tính tỉ lệ trung bình của từng nhóm tuối bị tiểu đường
age_diabetes = round((df.groupby('Age_Group')['Outcome'].mean() * 100), 2)
 
# Sắp xếp lại theo độ tuổi
age_diabetes = age_diabetes.reset_index(name='diabetes_rate_pct')
#Sắp xếp theo thấp đến cao
#age_diabetes = age_diabetes.sort_values(ascending= False)
print("\nTỷ lệ % tiểu đường theo độ tuổi:")
print(age_diabetes)
#print(df)