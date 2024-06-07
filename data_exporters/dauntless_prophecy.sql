-- Docs: https://docs.mage.ai/guides/sql-blocks
select top 100 * from {{ df_1 }} to insert all rows from dwh_test_1 into table