export PROJECT_NAME=apu_data_pipeline
export DATABASE_URL=Server=172.31.0.112;Database=mage_db;User=mage_user;Password=Asuult12345;
export PYTHONPATH=${PYTHONPATH}:/home/src:/home/src/apu_data_pipeline
export OPENAI_API_KEY=your_actual_api_key_here
export 
export # Default database configuration
export MSSQL_HOST_DEFAULT=172.31.0.112
export MSSQL_USER_DEFAULT=mage_user
export MSSQL_PASSWORD_DEFAULT='Asuult12345'
export 
export # Data warehouse landing database configuration
export MSSQL_HOST_DWH=172.31.0.112
export MSSQL_USER_DWH=sa-dwh
export MSSQL_PASSWORD_DWH='40v4A&WuP6$5'
export 
export # OAuth configuration
export REQUIRE_USER_AUTHENTICATION=1
export OAUTH_CLIENT_ID=your_client_id
export OAUTH_CLIENT_SECRET=your_client_secret
export OAUTH_REDIRECT_URI=http://dwh.apu.mn:6789/auth/callback
export OAUTH_AUTHORITY=https://login.microsoftonline.com/your_tenant_id
export OAUTH_SCOPES='khangai.d@apu.mn'
export ACTIVE_DIRECTORY_ROLES_MAPPING='{"Mage.Edit": "Editor", "Mage.Admin": "Admin"}'
