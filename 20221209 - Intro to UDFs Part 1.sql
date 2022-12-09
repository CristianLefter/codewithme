-- Intro to User-Defined Functions Part I
use AdventureWorks2012;
go 
-- Inline table-valued functions
create or alter function Sales.ListProducts(@cost money)  
returns table  
as  
return  
    select ProductID, [Name], ListPrice  
    from Production.Product
    where listPrice > @cost;
go 
select Productid, [Name], ListPrice 
from sales.listproducts(500);
go 
-- multi-statement table-valued functions
create or alter function Sales.mstvf_CustomerOrders(@CustomerID int)
returns 
    @results table (SalesOrderID int, OrderDate datetime )
as
begin
     insert into @Results
     select SalesOrderID, OrderDate
     from Sales.SalesOrderHeader
     where @CustomerID=0 OR CustomerID = @CustomerID;         
 return;
end;
go
select * from Sales.mstvf_CustomerOrders(11000);
go 
create or alter function dbo.ufnGetInventoryStock(@ProductID int)
returns int
as
-- Returns the stock level for the product.
-- Location 6 is Miscellaneous Storage
begin
    declare @ret int;
    select @ret = sum(p.Quantity)
    from Production.ProductInventory p
    where p.ProductID = @ProductID
        and p.LocationID = 6;     
    return isnull(@ret,0);
end;
go
select ProductModelID, [Name], dbo.ufnGetInventoryStock(ProductID) AS CurrentSupply
from Production.Product
where ProductModelID between 75 and 80;
go 

