
-- Create database 2019NationalChamps
CREATE DATABASE 2019NationalChamps;

-- Use databases 2019NationalChamps
USE 2019NationalChamps;

SELECT * FROM Transcript_Table LIMIT 2;

-- Query 1 (Uoptimized)
SELECT name, id
FROM Student_Table AS ST
WHERE ST.id=53583;


-- Query 2 (Unoptimized)
SELECT ST1.id, ST1.name
FROM
	(SELECT S.id, S.name
	FROM Student_Table S
	WHERE S.id>=100) AS ST1,
	(SELECT T.id, T.name 
	FROM Student_Table T
	WHERE T.id<=4000) AS ST2
WHERE ST1.id=ST2.id
ORDER BY ST1.id;



-- Query 3 (Unoptimized)
SELECT name, crsCode 
FROM Student_Table
JOIN Transcript_Table ON id=studId
WHERE crsCode = 'crsCode908077';



-- Query 4 (Unoptimized)
SELECT S.name, P.name AS 'Professor'
FROM Student_Table S
JOIN Transcript_Table TT ON S.id=TT.studId
JOIN Teaching_Table T ON TT.crsCode=T.crsCode
JOIN Professor_Table P ON P.id=T.profId
WHERE P.name='name259368';


SELECT * FROM Course_Table LIMIT 10;
-- Query 5 (Unoptimized)
select * from Student_Table s, Transcript_Table t, Course_Table c where s.id = t.studId and t.crsCode = c.crsCode 
and (c.deptId = 'deptId327484' and not 'deptId305533') ;


-- Query 6 (Unoptimized)
select * from Student_Table s, Transcript_Table t, Course_Table c where s.id = t.studId and t.crsCode = c.crsCode 
and c.crsCode = all(select crsCode from Course_Table where deptId = 'deptId616019');




