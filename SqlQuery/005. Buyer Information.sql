

Create table tblBuyerInfo(
BuyerID nvarchar(50) primary key,
Buyer nvarchar(200),
ContactNo nvarchar(50),
ContactPerson nvarchar(200),
MailingAddress nvarchar(500),
HOAddress nvarchar(500),
IsActive bit default 1,
EntryBy nvarchar(50),
EntryDate datetime default getdate()
);

GO

