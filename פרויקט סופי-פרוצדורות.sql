
--1.
go
alter VIEW viewlink
AS
select conanim.idConan , name 
from replay_Of_Conan 
join conanim
on conanim.idConan=replay_Of_Conan.idConan
go
--2.
create function max_call()
returns int as
begin
declare @idconan int
select @idconan=idConan  from(
select idConan ,COUNT(*) as c,row_number() over(order by count(*) desc ) As rowNumber
from viewlink 
group by idConan)q
where rowNumber=1
return @idconan
end
print dbo.max_call
-- 3.
create PROCEDURE no_act
AS BEGIN
DECLARE crs_tokef CURSOR FOR SELECT tokef FROM conanim
OPEN crs_tokef
DECLARE @date DATE
FETCH NEXT FROM crs_tokef
INTO @date
WHILE @@fetch_status=0
BEGIN
IF(@date<=GETDATE())
BEGIN
EXEC move_to_noAct @date
END
FETCH NEXT FROM crs_tokef INTO @date 
END
CLOSE crs_tokef
DEALLOCATE crs_tokef 
END
--מחיקת כונן לא פעיל
go
create PROCEDURE move_to_noAct
(@tokef DATE)
AS 
BEGIN
INSERT INTO no_active
SELECT *
FROM conanim
WHERE @tokef=tokef 
insert into old_replay
select *from replay_Of_Conan where idConan in(select idConan from conanim where tokef=@tokef)
delete from replay_Of_Conan where idConan in(select idConan from conanim where tokef=@tokef)
DELETE FROM conanim WHERE idConan=(select idConan from conanim where tokef=@tokef)
END
execute no_act
--4.
go
create TRIGGER update_tokef ON no_active 
AFTER UPDATE AS 
BEGIN 
DECLARE @tokef DATE
SELECT @tokef=tokef FROM INSERTED 
IF UPDATE(tokef)
IF (@tokef>GETDATE())
EXECUTE move_to_Act @tokef     
END 
go

create PROCEDURE move_to_Act (@tokef DATE)
AS
BEGIN 
INSERT INTO conanim 
SELECT *
FROM no_active
WHERE @tokef=tokef
INSERT INTO replay_Of_Conan select idCall,idConan,time_arrive,ps
from old_replay
where idConan in(select idConan from conanim where tokef=@tokef)
DELETE FROM old_replay where idConan in(select idConan from conanim where tokef=@tokef)
DELETE FROM no_active
WHERE @tokef=tokef
END

update no_active set tokef=dateadd(y,2,GETDATE()) where idConan=402864897

select *from no_active
select *from conanim
GO
--5.
alter FUNCTION big_avg_arrive() RETURNS TABLE AS 
RETURN
SELECT  idD,COUNT(idConan)AS count_conan,max(branch) AS max_branch 
FROM conanim JOIN 
(SELECT idA AS branch,AVG(DATEDIFF(minute,time_arrive,time_call)) AS avg_time_repley,
row_number() over(order by AVG(DATEDIFF(minute,time_arrive,time_call)) desc ) As rowNumber
FROM calls JOIN replay_Of_Conan
ON calls.idCall=replay_Of_Conan.idCall
GROUP BY idA)branch_avg_time_repley
ON branch_avg_time_repley.branch=idA
where rowNumber=1
GROUP BY idD
go
select * from dbo.big_avg_arrive()
go
--6.
create FUNCTION tokef () returns table as
RETURN
SELECT name,phone FROM conanim
where tokef<dateadd(day,30,getdate())

select * from  dbo.tokef()
go
--7.
create function not_in_call()RETURNS TABLE AS 
RETURN
Select idCall , idA
from calls
where idcall not in 
(Select idCall from replay_Of_Conan)
go
select * from dbo.not_in_call()
--8
go
create function num_hard_calls()
returns smallint as
begin
declare @count smallint
select @count=count(*) from(
(select idcall  from calls)
except
(select idcall from calls join eventss on calls.idEvent=eventss.idEvent where idDmin<4))w
return @count
end
go
print dbo.num_hard_calls()








--1.טבלה מדומה-view
create VIEW report_max_replay
AS
select w.idConan,time_call,nameE from replay_Of_Conan join
(SELECT idConan, COUNT(*) AS countC ,row_number() over(partition by idConan order by count(*) desc)
As rowNumber
FROM replay_Of_Conan
GROUP BY idConan)w
on replay_Of_Conan.idConan=w.idConan
join calls 
on calls.idCall=replay_Of_Conan.idCall
join eventSS
on calls.idEvent=eventSS.idEvent
where rowNumber=1
go