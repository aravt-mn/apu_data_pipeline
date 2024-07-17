import pandas as pd
from sqlalchemy import create_engine

# Path to the Excel file
excel_file_path = r'\\fileserver\salesdata\SalesPlan\Archive\2024_04_Monthly_plan_20240709_092601.xlsx'

# MSSQL connection details
mssql_config = {
    'MSSQL_DATABASE': 'Test',
    'MSSQL_SCHEMA': 'Manual',
    'MSSQL_DRIVER': 'ODBC Driver 18 for SQL Server',
    'MSSQL_HOST': '172.31.0.112',
    'MSSQL_PORT': '1433',
    'MSSQL_USER': 'sa-dwh',
    'MSSQL_PASSWORD': '40v4A&WuP6$5'
}

# Read the Excel file into a DataFrame
df = pd.read_excel(excel_file_path, engine='openpyxl')

# Create a connection to the MSSQL database
connection_string = f"mssql+pyodbc://{mssql_config['MSSQL_USER']}:{mssql_config['MSSQL_PASSWORD']}@{mssql_config['MSSQL_HOST']}:{mssql_config['MSSQL_PORT']}/{mssql_config['MSSQL_DATABASE']}?driver={mssql_config['MSSQL_DRIVER']}"
engine = create_engine(connection_string)

# Write the DataFrame to a SQL table
table_name = f"{mssql_config['MSSQL_SCHEMA']}.BusinessPlan"
df.to_sql(table_name, engine, if_exists='replace', index=False)

print(f"Data from {excel_file_path} has been successfully written to {table_name} table in the {mssql_config['MSSQL_DATABASE']} database.")
