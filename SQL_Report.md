<h1 align="center">Olist Brazil Data Analysis</h1><br><br>


## Introduction
This data analysis project focuses on Olist, Brazil's prominent online marketplace platform that bridges small business/independent sellers and customers across the country. By leveraging Olist's comprehensive dataset, which encompasses a variety of metrics including order details, customer information, seller information, payment information, and review scores, this study aims to extract actionable insights to enhance business operations, improve customer satisfaction, and drive strategic growth. The analysis will delve into patterns of consumer behavior, sales performance, and product popularity, aiming to identify key factors contributing to the platform's success and areas for potential improvement.<br><br>


## Dataset
The datasets, kindly provided by Olist, encompasses 99,441 order records from Brazil, covering the period from 2016 to 2018. It offers a comprehensive view of each order through multiple dimensions, including order status, pricing, payment methods, geolocations, and freight performance, as well as customer location, product attributes, and customer reviews. The complete datasets can be found here: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).<br><br>


## Data Preprocessing
After importing the datasets into MySQL, I noticed some columns are missing values and of wrong datatypes, we need to fix them before our analysis.

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/1.png" width="500" height="600">
<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/2.png" width="400" height="800"><br><br>

Also the `product_category_name_translation` dataset is only for the translation of category names, I directly updated the category names in the `products` dataset since it can be redundant and can decrease the complexity of joining tables in the further queries (however when dealing with real-life database, it is not suggested to alter the original database directly, keep that in mind). 

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/5.png" width="500" height="200">

While doing this, I noticed there are three category names ('portateis_cozinha_e_preparadores_de_alimentos', 'la_cuisin', and 'pc_gamer') are missing from the translation table, so I manually searched and updated them.

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/4.png" width="500" height="200">

In this dataset, a notable number of orders fall under the 'canceled' status and are missing delivery date details. For our analysis, these records are considered invalid and will be omitted to ensure the integrity and relevance of the data. Consequently, only orders marked with a 'delivered' status are retained for further examination. I have also created a view of the resulting dataset to facilitate easier querying and analysis.

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/6.png" width="200" height="200">

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/7.png" width="550" height="500"><br><br>

## Data Analysis
I will answer the following 13 questions in this section:
1. How many orders were placed on Olist, how has it changed over the years? Is there a seasonality?
2. What's the total revenue generated on Olist, how does it change over time?
3. What are the successful categories on Olist, by year, month, and quarter?
4. Which city, state generates the most revenue for Olist? How actively the population in different areas is placing orders?
5. What are the most popular categories by city, state?
6. What is the AOV and CPO of Olist? How does this vary by categories and payment method?
7. Who are the frequent shoppers on Olist? How many of them are there? How does this number change over time?
8. Which customers have the highest CLTV?
9. What is the customer retention rate (CRR) by geolocaitons?
10. What is the review distribution on Olist, how does this impact sales performance?
11. What is the average review score for each category? How does it impact sales performance?
12.  What is the average delivery time? How does this vary for each city, state?
13.   Who are the most successful sellers? How are they distributed?

<p align="center">. . .</p>

*1. How many orders were placed on Olist, how has it changed over the years? Is there a seasonality?*
