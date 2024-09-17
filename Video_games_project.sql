
SELECT *
FROM video_games_sales_as_at_22_dec_2016
ORDER BY `Name`;

# Cleaning the data
UPDATE video_games_sales_as_at_22_dec_2016
SET `Name` = TRIM(`Name`);
UPDATE video_games_sales_as_at_22_dec_2016
SET `Name` = REPLACE(`Name`, '.', '')
WHERE `Name` LIKE '.%';
UPDATE video_games_sales_as_at_22_dec_2016
SET `Name` = REPLACE(`Name`, "'", '')
WHERE `Name` LIKE "'%";
UPDATE video_games_sales_as_at_22_dec_2016
SET `Name` = REPLACE(`Name`, "[", '')
WHERE `Name` LIKE "[%";
UPDATE video_games_sales_as_at_22_dec_2016
SET `Name` = REPLACE(`Name`, "]", '')
WHERE `Name` LIKE "%]";
DELETE FROM video_games_sales_as_at_22_dec_2016
WHERE `Name` = "";


# Top 10 publisher has the most global sales
SELECT Publisher, SUM(Global_Sales) Global_Sales
FROM video_games_sales_as_at_22_dec_2016
GROUP BY Publisher
ORDER BY Global_Sales DESC
LIMIT 10;

# Which year had best Global sales for and thier genre
CREATE TEMPORARY TABLE sales_table (
    SELECT vd2.Year_of_Release, MAX(vd2.Global_Sales) AS global_sales
	FROM video_games_sales_as_at_22_dec_2016 as vd2
	GROUP BY  Year_of_Release
	ORDER BY Year_of_Release
);
CREATE TEMPORARY TABLE temp_sale(
SELECT vd2.Year_of_Release, MAX(vd2.Global_Sales) AS global_sales, Genre 
FROM video_games_sales_as_at_22_dec_2016 as vd2
GROUP BY  Year_of_Release, Genre
);
SELECT sd1.Year_of_Release,sd1.global_sales, vd1.Genre
FROM sales_table AS sd1
LEFT JOIN temp_sale AS vd1
ON sd1.global_sales = vd1.global_sales;

# Which year had best Global sales for all publishers
CREATE TEMPORARY TABLE publisher_table (
    SELECT vd2.Year_of_Release, MAX(vd2.Global_Sales) AS global_sales
	FROM video_games_sales_as_at_22_dec_2016 as vd2
	GROUP BY  Year_of_Release
	ORDER BY Year_of_Release
);
CREATE TEMPORARY TABLE temp_publisher(
SELECT vd2.Year_of_Release, MAX(vd2.Global_Sales) AS global_sales, Publisher 
FROM video_games_sales_as_at_22_dec_2016 as vd2
GROUP BY  Year_of_Release, Publisher 
);
SELECT sd1.Year_of_Release,sd1.global_sales, vd1.Publisher 
FROM publisher_table AS sd1
LEFT JOIN temp_publisher AS vd1
ON sd1.global_sales = vd1.global_sales;

# Platform and thier number of game releases
SELECT Platform, COUNT(Platform) AS 'No.of.games'
FROM video_games_sales_as_at_22_dec_2016
GROUP BY Platform
ORDER BY 2 DESC;

# Which region had the best number of sales in each year
SELECT Year_of_Release,
CASE
	WHEN NA_Sales > EU_Sales AND JP_Sales AND Other_Sales THEN CONCAT(ROUND(NA_Sales, 2), "  NA")
    WHEN EU_Sales > NA_Sales AND JP_Sales AND Other_Sales THEN CONCAT(EU_Sales, "  EU")
    WHEN JP_Sales > EU_Sales AND NA_Sales AND Other_Sales THEN CONCAT(JP_Sales, "  JP")
    WHEN Other_Sales > NA_Sales AND JP_Sales AND JP_Sales THEN Other_Sales 
END AS Top_Sales
FROM (SELECT Year_of_Release, SUm(NA_Sales) NA_Sales, SUm(EU_Sales) EU_Sales, SUm(JP_Sales) JP_Sales, SUM(Other_Sales) Other_Sales
	FROM video_games_sales_as_at_22_dec_2016
	GROUP BY Year_of_Release) as jd
ORDER BY 1