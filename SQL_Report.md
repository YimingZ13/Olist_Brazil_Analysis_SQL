<h1 align="center">Olist Brazil Data Analysis</h1><br><br>


## Introduction
This data analysis project focuses on Olist, Brazil's prominent online marketplace platform that bridges small business/independent sellers and customers across the country. By leveraging Olist's comprehensive dataset, which encompasses a variety of metrics including order details, customer information, seller information, payment information, and review scores, this study aims to extract actionable insights to enhance business operations, improve customer satisfaction, and drive strategic growth. The analysis will delve into patterns of consumer behavior, sales performance, and product popularity, aiming to identify key factors contributing to the platform's success and areas for potential improvement.<br><br>


## Dataset
The datasets, kindly provided by Olist, encompasses 99,441 order records from Brazil, covering the period from 2016 to 2018. It offers a comprehensive view of each order through multiple dimensions, including order status, pricing, payment methods, geolocations, and freight performance, as well as customer location, product attributes, and customer reviews. The complete datasets can be found here: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/HRhd2Y0.png" width="800" height="500"><br><br>

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
4. Which city, state generates the most revenue on Olist?
5. What are the most popular categories by city, state?
6. What is the AOV, CPO, and  average profit margin of Olist? How does this vary by categories and payment method?
7. Who are the frequent shoppers on Olist? How many of them are there? How does this number change over time?
8. Which customers have the highest CLTV?
9. What is the customer retention rate (CRR) by geolocaitons?
10. What is the review distribution on Olist, how does this impact sales performance?
11. What is the average review score for each category? How does it impact sales performance?
12.  What is the average delivery time? How does this vary for each city, state?
13.   Who are the most successful sellers? How are they distributed?

<p align="center">. . .</p>

*1. How many orders were placed on Olist, how has it changed over the years? Is there a seasonality?*

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/8.png" width="300" height="250">
<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/9.png" width="300" height="300">
<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/10.png" width="300" height="600">

In 2018, Olist recieved the most orders, the platform was only founded in 2015, and started off with just a small number of orders in 2016. This number boomed in 2017, and increased to its peak in 2018 at 52777 orders. 

There is a clear upward trend in the number of orders over time, indicating significant growth in Olist's business. Starting from just 1 order in September 2016, the monthly order count increases to thousands of orders per month by 2018. Aside from the initial sparse data in 2016, every subsequent month sees an increase in the number of orders compared to the same month in the previous year, suggesting effective marketing, customer retention, and acquisition strategies.

There appear to be seasonal patterns in order volume. The first quarter of the year, particularly January and March, shows high activity in both 2017 and 2018, potentially due to New Year promotions or resolutions driving purchases. Notably, there is a significant increase in orders around November and December 2017, however November clearly outperformed December, suggesting a strong influence of holiday shopping seasons. particularly Black Friday, and Brazilians tend to do their shoppings on Black Friday.<br><br>

*2. What's the total revenue generated on Olist, how does it change over time?*

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/11.png" width="400" height="150">

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/12.png" width="300" height="200">

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/13.png" width="300" height="500">

The annual, and monthly revenue generated by Olist is closely correlated with the total volume of orders processed.<br><br>

*3. What are the successful categories on Olist, by year, month, and quarter?*

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/15.png" width="400" height="500">

"Bed Bath & Table" emerges as the leading category on Olist, accounting for 10% of the total orders, making it the most favored among consumers. It is closely followed by "Health & Beauty," which constitutes 8.6% of orders, and "Sports & Leisure," capturing 7.6% of the market total.

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/16.png" width="400" height="400">

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/17.png" width="400" height="350">

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/18.png" width="400" height="450">

For this part, I queried the most popular product categories for each year, quarter, and month. To query the top 1 most sold category, I grouped the data by each date type, and added rankings in order by the number of orders old. 

 In 2016, "furniture decor" consists of 65 orders. "Bed bath & table" was the most sold category for 2017, and "health beauty" is the most sold category for 2018.

 I only included data of the year of 2017 for the next two queries. This choice is strategic, given that our dataset spans from September 2016 through August 2018, and the year 2016 presents significantly fewer orders, potentially distorting our insights.. In the first three months, the "Furniture Decor" category led in the number of orders. This suggests an initial consumer preference or perhaps seasonal demand for home decor items during this period.Starting from April, there is a noticeable shift in consumer preference towards the "Bed Bath & Table" category, which then consistently leads in the number of orders for the remainder of the year. There is variability in the number of orders month-to-month within each category, there might be a seasonal pattern associated with holiday shoppig, promotions or other seasonal factors.<br><br>

*4. Which city, state generates the most revenue on Olist?*

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/19.png" width="300" height="350">

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/20.png" width="250" height="300">

Examining the top 10 cities and states that generated the most revenue on Olist, São Paulo emerges as the frontrunner, amassing revenue that quadruples that of its nearest competitor, Ibitinga. Remarkably, the state of São Paulo as a whole significantly outperforms the second and third-ranking cities, generating approximately ten times their revenue.<br><br>

*5. What are the most popular categories by city, state?*

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/21.png" width="400" height="450">

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/22.png" width="400" height="450">

São Paulo is the top city, with the highest number of orders for "Bed Bath & Table," nearly doubling the orders of the next city, Rio de Janeiro, which has 829 orders in the same category. This underscores São Paulo's significant contribution to the overall demand for "Bed Bath & Table" products on Olist.While "Bed Bath & Table" dominates in several cities, other categories also emerge as top choices in different locations. For instance, "Health Beauty" is the most ordered category in Brasília and Salvador, indicating a diverse interest in product categories based on the city. 

Curitiba is unique in showcasing a variety of preferences, with "Sports Leisure" and "Furniture Decor" both leading with 151 orders each. This diversity indicates a broader range of popular product categories in Curitiba compared to other cities, where one category tends to dominate. There might be a geographical pattern for cutsomers shopping preferences.<br><br>

*6. What is the AOV, CPO, and  average profit margin of Olist? How does this vary by categories and payment method?*

**Average Profit Margin** is the difference of **AOV** and **CPO**. It gives businesses a quick snapshot of the direct profitability of their sales transactions. A positive value indicates that the business is making a gross profit on its orders, while a negative value would suggest that it costs more to sell a product than the revenue it generates, signaling a need for reevaluation of pricing, cost management, or both.

**AOV (Average Order Value)** is a metric measures the average amount spent each time a customer places an order. It is calculated by dividing the total revenue by the number of orders. The formula is:<br>
<p align="center"> $AOV = \frac{Total\ Revenue}{Number\ of\ Orders}$ </p>

**CPO (Cost Per Order)** on the other hand, represents the average cost of getting an order. This includes all the operational costs associated with selling products, such as marketing expenses, shipping, handling, production, and overhead costs divided by the total number of orders (in this dataset, we are only provided with shipping and the cost of the product). The formula is:<br>
<p align="center"> $CPO = \frac{Total\ Cost\ of\ Product\ +\ Total\ Shipping\ Cost}{Number\ of\ Orders}$ </p><br>

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/23.png" width="500" height="400">

AOV is slightly higher than CPO, resulting in an average profit margin of $0.42 for every order. This means that after covering the direct costs associated with each order, Olist makes an average profit of $0.42 per order. 

With such a narrow margin, the profitability of Olist likely depends on the volume of orders processed. High volumes could compensate for the low profit per order, making overall business operations sustainable and profitable. Given the tight profit margin, it's essential for Olist to closely monitor both APO and CPO. Small changes in either metric could significantly impact overall profitability, emphasizing the importance of efficient operations and strategic pricing.

<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/24.png" width="500" height="400">



<img src="https://github.com/YimingZ13/Olist_Brazil_Analysis_SQL/blob/main/sql_screenshots/25.png" width="500" height="350">

