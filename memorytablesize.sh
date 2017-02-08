#!/bin/sh
database_name=$1
table_name=$2
max_memory_table_size=16384
tmp_file="records.sql"

echo "set @@max_heap_table_size=$max_memory_table_size;" > "$tmp_file"
echo "set @@tmp_table_size=$max_memory_table_size;" >> "$tmp_file"
echo "truncate $table_name;" >> "$tmp_file"
# create/truncate will force MEMORY table to use values set above

echo "show table status in $database_name like '$table_name';" >> "$tmp_file"
echo "select MAX_DATA_LENGTH/AVG_ROW_LENGTH as \`max_rows\` from information_schema.tables where table_name = 'test';" >> "$tmp_file"

cat $tmp_file | mysql -uroot -p $database_name

rm "$tmp_file"

