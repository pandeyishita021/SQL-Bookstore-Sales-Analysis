
use practice;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
show tables;
select count(*) from books;
select*from books;
select count(*) from customers;
select*from customers;
select count(*) from orders;
select*from orders;

-- Retrieve all books of "fiction" genre
select*from books where Genre='Fiction';
-- Find books published after the year 1950
select*from books where Published_Year>1950;
-- List all the customers from Canada
select*from customers where Country='Canada';
-- Show orders placed in November 2023
select*from orders where Order_Date between '2023-11-01' and '2023-11-30';
-- Retrieve the total stock of books available
select sum(Stock) as total_stock from books;
-- Find the details of the most expensive book
select*from books order by Price desc limit 1;
-- Show all customers who ordered more than 1 quantity of book
select*from orders where Quantity>1;
-- Retrieve all the orders where the tot amt exceeds $20
select*from orders where Total_Amount>20;
-- List all the available genres in the books table
select distinct Genre from books;
-- Find the book with lowest stock
select*from books order by Stock asc limit 1;
-- Calculate the tot revenue generated from all the orders
select sum(Total_Amount) as tot_rev from orders;

-- Retrieve the tot no of books sold for each genre
select b.Genre, sum(o.Quantity) as tot_books_sold
from orders o
join books b on o.book_id=b.book_id
group by b.Genre;
-- Find the avg price of books in the fantasy genre
select avg(Price) as avg_price from books where Genre='Fantasy';
-- List customers who have placed at least 2 orders
select Customer_ID, count(Order_ID) as order_count
 from Orders 
 group by Customer_ID
 having count(Order_ID)>=2;
 -- Find the most frequently ordered books
 select Book_ID, count(Order_ID) as order_count
 from orders
 group by Book_ID
 order by order_count desc limit 1;
 -- Name the most frequently ordered books
 select o.Book_ID, b.Title, count(o.Order_ID) as order_count
 from orders o
 join books b on o.Book_ID=b.Book_ID
 group by o.Book_ID,b.Title
 order by order_count desc limit 1;
 -- Show the top 3 most expensive books of fantasy genre
 select*from books where Genre='Fantasy' order by Price desc limit 3;
 -- Retrieve the tot qty of books sold by each author
 select b.author, sum(o.quantity) as tot_books
 from orders o
 join books b on o.Book_ID=b.Book_ID
 group by b.author;
 -- List the cities where customers who spent over $30 are located
 select  distinct c.city, o.total_amount 
 from orders o
 join customers c on o.customer_id=c.customer_id
 where o.total_amount>30;
 -- Find the customer who spent the most on orders
 select c.customer_id, c.name, sum(o.total_amount) as total_spent
 from orders o
 join customers c on o.customer_id=c.customer_id
 group by c.customer_id, c.name
 order by total_spent desc limit 1;
 -- Calculate the stock remaining after fulfilling all orders
 select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,b.stock-coalesce(sum(o.quantity),0) as rem_qty
 from books b
 left join orders o on b.Book_ID=o.Book_ID
 group by b.Book_ID order by b.Book_ID;
 
 