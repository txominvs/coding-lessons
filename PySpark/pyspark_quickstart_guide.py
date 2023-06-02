# pip install pyspark
# pip install pyspark[sql]
# pip install pyspark[pandas_on_spark] plotly  # to plot your data, you can install plotly together.
# pip install pyspark[connect]

from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

df = spark.createDataFrame([
    (1, 2., 'string1', date(2000, 1, 1), datetime(2000, 1, 1, 12, 0)),
    (2, 3., 'string2', date(2000, 2, 1), datetime(2000, 1, 2, 12, 0)),
    (3, 4., 'string3', date(2000, 3, 1), datetime(2000, 1, 3, 12, 0)),
], schema='a long, b double, c string, d date, e timestamp')

df.printSchema()
df.show(10)
to_python_memory = df.collect() # caution! Out Of Memory errors

df.select(df.the_name_of_the_column, "another_name").show()
df.groupby('color').avg().show()

df.write.csv('foo.csv', header=True)
df = spark.read.csv('foo.csv', header=True)

df.createOrReplaceTempView("table_name"); result = spark.sql("SELECT count(*) FROM table_name").collect()
df.selectExpr('ABS(age*2 - 13)').show()

# Server Run $HOME/sbin/start-connect-server.sh --packages org.apache.spark:spark-connect_2.12:$SPARK_VERSION
SparkSession.builder.master("local[*]").getOrCreate().stop() # stop the existing regular Spark session because it cannot coexist with the remote Spark Connect session
spark = SparkSession.builder.remote("sc://localhost:15002").getOrCreate()
df = spark.createDataFrame(...)

import pandas as pd # pandas
import pyspark.pandas as ps # pandas-on-spark

df = spark.createDataFrame(...) # Spark
psdf = sdf.pandas_api() # pandas-on-Spark
pdf = df.toPandas() # Pandas

psdf = ps.range(10) # pandas-on-Spark
sdf = psdf.to_spark().filter("id > 5") # Spark
pdf = psdf.to_pandas() # Pandas

pdf = pd.DataFrame(...) # pandas
psdf = ps.from_pandas(pdf) # pandas-on-Spark
sdf = spark.createDataFrame(pdf) # Spark