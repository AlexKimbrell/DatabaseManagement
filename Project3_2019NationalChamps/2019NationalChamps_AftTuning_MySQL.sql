
-- Create database 2019NationalChamps
CREATE DATABASE 2019NationalChamps;

-- Use databases 2019NationalChamps
USE 2019NationalChamps;



-- Query 1 (Optimized)
CREATE INDEX getIDs ON Student_Table (id);

SELECT name, id
FROM Student_Table
WHERE id=53583;


-- Query 2 (Optimized)
SELECT id, name
FROM Student_Table
WHERE id<=4000 AND id>=100
ORDER by id;

DROP INDEX getIDs ON Student_Table;



-- Query 3 (Optimized)
CREATE INDEX student ON Student_Table(id);

SELECT s.name, t.crsCode
FROM Student_Table AS s, Transcript_Table AS t
WHERE crsCode = 'crsCode908077' AND s.id=t.studId; 

DROP INDEX student ON Student_Table;



-- Query 4 (Optimized)
CREATE INDEX fastStudent ON Student_Table(id);
CREATE INDEX fastTranscript ON Transcript_Table(studId);

SELECT S.name, P.name AS 'Professor'
FROM Student_Table S
JOIN Transcript_Table TT ON S.id=TT.studId
JOIN Teaching_Table T ON TT.crsCode=T.crsCode
JOIN Professor_Table P ON P.id=T.profId
WHERE P.name='name259368';

DROP INDEX fastStudent ON Student_Table;
DROP INDEX fastTranscript ON Transcript_Table;



-- Query 5 (Optimized)
CREATE INDEX C ON Course_Table(deptId(8));

select S.name from Student_Table s, Transcript_Table t, Course_Table c where s.id = t.studId and t.crsCode = c.crsCode 
and (c.deptId = 'deptId327484' and not 'deptId305533') ;

DROP INDEX C ON Course_Table;


-- Query 6 (Optimized)
CREATE INDEX C ON Course_Table(deptId(8));

select S.name, C.deptId from Student_Table s, Transcript_Table t, Course_Table c where s.id = t.studId and t.crsCode = c.crsCode 
and c.crsCode = all(select crsCode from Course_Table where deptId = 'deptId616019');

DROP INDEX C ON Course_Table;

