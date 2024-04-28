create database BlogDB

use BlogDb

CREATE TABLE Categories(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(40) NOT NULL UNIQUE
)

CREATE TABLE Tags (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(40) NOT NULL UNIQUE
)

CREATE TABLE Users (
Id INT PRIMARY KEY IDENTITY,
UserName NVARCHAR(40) NOT NULL UNIQUE,
FullName  NVARCHAR(40) NOT NULL,
Age INT CHECK(Age<150 AND Age>0)
)

CREATE TABLE Blogs  (
Id INT PRIMARY KEY IDENTITY,
Title NVARCHAR(50) NOT NULL,
[Description] NVARCHAR(200) NOT NULL,
UserId INT FOREIGN KEY REFERENCES Users(Id),
CategoryId INT FOREIGN KEY REFERENCES Categories(Id)
)

CREATE TABLE Comments (
Id INT PRIMARY KEY IDENTITY,
Content  NVARCHAR(250) NOT NULL,
UserId INT FOREIGN KEY REFERENCES Users(Id),
BlogId INT FOREIGN KEY REFERENCES Blogs(Id)
)
CREATE TABLE Blogt_Tag(
BlogId INT FOREIGN KEY REFERENCES Blogs(Id),
TagId INT FOREIGN KEY REFERENCES Tags(Id)
)


INSERT INTO Categories ([Name])
VALUES ('Technology'),
       ('Travel'),
       ('Food');

INSERT INTO Tags ([Name])
VALUES ('Programming'),
       ('Adventure'),
       ('Cooking');

INSERT INTO Users (UserName, FullName, Age)
VALUES ('user1', 'John Doe', 30),
       ('user2', 'Jane Smith', 25),
       ('user3', 'Alice Johnson', 35);

INSERT INTO Blogs (Title, [Description], UserId, CategoryId)
VALUES ('Introduction to SQL', 'A beginner''s guide to SQL programming.', 1, 1),
       ('Traveling in Europe', 'Exploring the beautiful cities of Europe.', 2, 2),
       ('Delicious Recipes', 'Learn how to cook delicious meals at home.', 3, 3);

INSERT INTO Comments (Content, UserId, BlogId)
VALUES ('Great tutorial, thanks for sharing!', 2, 1),
       ('I love traveling! Europe sounds amazing.', 3, 2),
       ('These recipes are fantastic, I can''t wait to try them.', 1, 3);

INSERT INTO Blogt_Tag (BlogId, TagId)
VALUES (1, 1),  
       (2, 2),  
       (3, 3);  

	   INSERT INTO Categories ([Name])
VALUES ('Fashion'),
       ('Health'),
       ('Sports');

INSERT INTO Tags ([Name])
VALUES ('Fashionista'),
       ('HealthyLiving'),
       ('Fitness');

INSERT INTO Users (UserName, FullName, Age)
VALUES ('user4', 'Emily Brown', 28),
       ('user5', 'Michael Johnson', 40),
       ('user6', 'Sophia Wilson', 22);

INSERT INTO Blogs (Title, [Description], UserId, CategoryId)
VALUES ('Elinin gunluyu', 'Men usaqlarla top oynamagi xoslayiram', 2, 3);

INSERT INTO Comments (Content, UserId, BlogId)
VALUES ('I love keeping up with the latest fashion trends!', 4, 4),
       ('These healthy eating tips are really helpful, thanks!', 5, 5),
       ('As a beginner, these fitness tips are exactly what I needed.', 6, 6);

INSERT INTO Blogt_Tag (BlogId, TagId)
VALUES (4, 4),  
       (5, 5),  
       (6, 6);  


ALTER VIEW VW_GetBlogTitleAndUsersInfo 
AS
SELECT b.Title as 'Blog Title',u.UserName as 'User UserName', u.FullName as 'User Fullname' FROM Blogs b
JOIN Users u
ON b.UserId = u.Id
WHERE b.IsDeleted = 0

SELECT * FROM VW_GetBlogTitleAndUsersInfo

ALTER VIEW VW_GetBlogTitleAndCategory
AS
SELECT b.Title as 'Blog Title',c.Name as 'Category Name' FROM Blogs b
JOIN Categories c
ON b.CategoryId = c.Id
WHERE b.IsDeleted = 0


SELECT * FROM VW_GetBlogTitleAndCategory


ALTER PROC SP_GetComments @userId INT
AS
SELECT * FROM Comments c
WHERE @userId = c.UserId

EXEC SP_GetComments 2


ALTER PROC SP_GetBlogs @userId INT
AS
SELECT * FROM Blogs b
WHERE @userId = b.UserId AND b.IsDeleted = 0

EXEC SP_GetBlogs 2



ALTER FUNCTION	FN_GetBlogsCount (@categoryId INT)
RETURNS INT
BEGIN
	DECLARE @Total INT
	SELECT  @Total = COUNT(b.Id) FROM Blogs b
	WHERE @categoryId = b.CategoryId AND b.IsDeleted = 0
	RETURN @Total
END;

	
SELECT dbo.FN_GetBlogsCount (2)


ALTER FUNCTION dbo.FN_GetBlogsByUserId (@userId INT)
RETURNS TABLE
AS
RETURN
(
   SELECT  * FROM Blogs b
	WHERE @userId = b.UserId AND b.IsDeleted = 0
);

SELECT * FROM FN_GetBlogsByUserId (2)


ALTER TABLE Blogs
DROP COLUMN IsDeleted 


ALTER TABLE Blogs
ADD IsDeleted BIT NOT NULL DEFAULT 0;


ALTER TRIGGER TRGR_BlogIsDeleted
ON Blogs
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id INT;
	SELECT @id=Id FROM DELETED;
	UPDATE Blogs SET IsDeleted=1
	WHERE Id = @id
END


DELETE FROM Blogs
Where Blogs.Id =2
