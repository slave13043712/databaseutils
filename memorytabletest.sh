#!/bin/sh
database_name=$1
record_count=$2
max_memory_table_size=$3
tmp_file="records.sql"

echo "set @@max_heap_table_size=$max_memory_table_size;" > "$tmp_file"
echo "set @@tmp_table_size=$max_memory_table_size;" >> "$tmp_file"
echo "drop table if exists \`test\`;" >> "$tmp_file"
# create/truncate will force MEMORY table to use values set above
cat << 'EOF' >> "$tmp_file"
CREATE TABLE `test` (
  `column1` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `column2` char(20) DEFAULT NULL,
  `column3` char(8) DEFAULT NULL,
  PRIMARY KEY (`column1`),
  KEY `column2` (`column2`) USING BTREE,
  KEY `column3` (`column3`)
) ENGINE=MEMORY;
EOF

echo "select @@max_heap_table_size;" >> "$tmp_file"
echo "select @@tmp_table_size;" >> "$tmp_file"

for index in `seq 1 $record_count`
do
  echo "INSERT INTO \`test\` (column2, column3) VALUES ('$index', '$index');" >> "$tmp_file"
done

echo "show table status in test;" >> "$tmp_file"

cat $tmp_file | mysql -uroot -p $database_name

