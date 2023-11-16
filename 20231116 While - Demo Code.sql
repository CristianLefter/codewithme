-- Print the first 'n' natural numbers.
declare @n int = 10
declare @i int = 1
while @i <= @n
begin
    print @i;
    set @i = @i + 1;
end
go

-- Print the first natural numbers less than or equal to 'n' that are divisible by 2.
declare @n int = 10
declare @i int = 1
while @i <= @n
begin
    if @i % 2 = 0
		print @i;
    set @i = @i + 1;
end
go

-- Print the first natural numbers less than or equal to 'n' that are divisible by 2. (Alternate option)
declare @n int = 10
declare @i int = 0
while @i <= @n
begin
	set @i = @i + 1;
    if @i % 2 = 1
		continue;
	print @i;    
end
go

-- print n! (n!=1*2*3*...*n)
declare @n int = 10
declare @i int = 1
declare @r int = 1;
while @i <= @n
begin    
    set @r = @r * @i;
	set @i += 1;
end
print cast(@n as varchar(2)) + '!=' + cast(@r as varchar(9));
go

-- Print the prime numbers less than or equal to 'n'
declare @n int = 100;
declare @i int = 1;
declare @prime int = 2;
declare @isprime bit = 1;
while @prime < @n 
begin
    set @isprime = 1
    set @prime = @prime + 1
    declare @divisor int = 2
    while @divisor < sqrt(@prime)+1
    begin
        if @prime % @divisor = 0
        begin
            set @isprime = 0
            break
        end
        set @divisor = @divisor + 1
    end
    if @isprime = 1
    begin
        print @prime;
        set @i = @i + 1;
    end
end
go

-- Print the prime numbers less than or equal to 'n' (using a set operations)
declare @n int = 100;
with numbers_cte(i) as
(
select 2 as i
union all
select i + 1 as i from numbers_cte where numbers_cte.i < @n
)
select i from numbers_cte c0
except
select c1.i
from numbers_cte c1
join numbers_cte c2
	on c1.i > c2.i and c1.i % c2.i = 0
option (maxrecursion 0);
go

-- remove all characters from a string in T-SQL that are not numbers
declare @inputstring varchar(max) = 'abc123def456';
declare @notnumberpattern varchar(50) = '%[^0-9]%';
while patindex(@notnumberpattern, @inputstring) > 0
begin
    set @inputstring = stuff(@inputstring, patindex(@notnumberpattern, @inputstring), 1, '')
end
print @inputstring;
go

-- remove all characters from a string in T-SQL that are not numbers (alternate option)
declare @inputstring varchar(max) = 'abc123def456';
declare @outputString varchar(max)='';
declare @c char(1);
declare @i int = 1;
while @i <= len(@inputstring)
begin
    set @c = substring(@inputstring,@i,1);
	if @c like '[0-9]'
		set @outputString = @outputString + @c;
	set @i = @i + 1;
end
print @outputString;
go

-- check if a string is a Palindrome
declare @inputstring varchar(max) = 'abc123def456'; 
-- declare @inputstring varchar(max) = 'abcdcba'
declare @i int=1;
declare @isPalindrome bit = 1;
while @i < len(@inputstring)
begin
	if substring(@inputstring,@i,1) <> substring(@inputstring, 1+len(@inputstring)-@i,1)    
		begin
		set @isPalindrome = 0;
		break;
		end;
	set @i = @i + 1;
end
if @isPalindrome = 1 
	print 'it is a Palindrome'
else 
	print 'is is not a Palindrome'
go

-- check if a string is a Palindrome (alternate option)
declare @inputstring varchar(max) = 'abc123def456'; 
-- declare @inputstring varchar(max) = 'abcdcba'
if @inputstring = reverse(@inputstring)
	print 'it is a Palindrome'
else 
	print 'is is not a Palindrome'
go

-- use a WHILE loop to populate a table variable with sample data
declare @SampleData table (
    id int,
    value nvarchar(50)
);
declare @counter int = 1;
declare @maxRows int = 10; 

while @counter <= @maxRows
begin
    insert into @SampleData (id, value)
    values (@counter, 'Sample Data ' + cast(@counter as nvarchar(10)));

    set @counter = @counter + 1;
end

select * from @SampleData;
go

-- not best practice
declare dbCursor cursor for
select name, crdate from sys.sysdatabases;

declare @dbName nvarchar(128);
declare @dbCreationDate datetime;

open dbCursor;
fetch next from dbCursor into @dbName, @dbCreationDate;
-- Iterate through the rows
while @@fetch_status = 0
begin
    -- Output database name and creation date
    print 'Database Name: ' + @dbName + ' | Creation Date: ' + convert(varchar, @dbCreationDate, 120);

    -- Fetch the next row
    fetch next from dbCursor into @dbName, @dbCreationDate;
end
-- Close and deallocate the cursor
close dbCursor;
deallocate dbCursor;
