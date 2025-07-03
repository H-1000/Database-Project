use milestone2DB

---------------------------------------------------------
---1 Admin---
GO
CREATE PROC ViewInfo 
@LearnerID INT
AS
BEGIN
    SELECT * FROM Learner
    WHERE LearnerID = @LearnerID;
END
exec ViewInfo @LearnerID = 1;
---------------------------------------------------------
---2 Admin---
CREATE PROC LearnerInfo
@LearnerID INT
AS
BEGIN
    SELECT * FROM PersonalizationProfiles 
    WHERE LearnerID = @LearnerID;
END
exec LearnerInfo @LearnerID = 1;
---------------------------------------------------------
---3 Admin---
CREATE PROC EmotionalState 
@LearnerID INT, 
@emotional_state VARCHAR(50) output
AS
BEGIN
    SELECT TOP 1 @emotional_state = emotional_state 
    FROM Emotional_feedback 
    WHERE LearnerID = @LearnerID 
    ORDER BY timestamp DESC;
END

DECLARE @emotional_state VARCHAR(50)
EXEC EmotionalState @LearnerID = 1, @emotional_state = @emotional_state OUTPUT
PRINT 'Emotional State: ' + @emotional_state;
---------------------------------------------------------
---4 Admin---
CREATE PROC LogDetails 
@LearnerID INT
AS
BEGIN
    SELECT * FROM Interaction_log i
    WHERE i.LearnerID = @LearnerID
    ORDER BY Timestamp DESC;
END

exec LogDetails @LearnerID = 1;
---------------------------------------------------------
---5 Admin---
CREATE PROC InstructorReview 
@InstructorID INT
AS
BEGIN
    SELECT ef.FeedbackID, ef.LearnerID, ef.activityID, ef.timestamp, ef.emotional_state
    FROM Emotional_feedback ef inner join Emotionalfeedback_review er
    on ef.FeedbackID = er.FeedbackID
	WHERE er.InstructorID = @InstructorID;
END

exec InstructorReview @InstructorID = 1;
---------------------------------------------------------
---6 Admin---
CREATE PROC CourseRemove 
@courseID INT
AS
BEGIN
    IF EXISTS ( SELECT 1 FROM Course_enrollment WHERE status = 'Completed' and Course_enrollment.CourseID = @courseID)
    Begin
    DELETE FROM Course_enrollment WHERE CourseID = @courseID;
    DELETE FROM Teaches WHERE CourseID = @courseID;
    DELETE FROM CoursePrerequisite WHERE CourseID = @courseID;
    DELETE FROM Modules WHERE CourseID = @courseID;
    DELETE FROM Assessments WHERE CourseID = @courseID;
    DELETE FROM Course WHERE CourseID = @courseID;
    END
END
---------------------------------------------------------
---7 Admin---
create proc Highestgrade
as
begin 
with temp as(
select ta.AssessmentID, ta.scoredPoint, a.CourseID 
from Takenassessment ta inner join Assessments a on ta.AssessmentID = a.ID
group by ta.AssessmentID, ta.scoredPoint, a.CourseID
)
select CourseID, max(scoredPoint) as HighestGrade
from temp
group by CourseID
end


exec Highestgrade;
---------------------------------------------------------
---8 Admin---
CREATE PROC InstructorCount
AS
BEGIN
    SELECT CourseID, COUNT(DISTINCT InstructorID) AS InstructorCount
    FROM Teaches
    GROUP BY CourseID
    HAVING COUNT(DISTINCT InstructorID) > 1;
END

exec InstructorCount;
---------------------------------------------------------
---9 Admin---
CREATE PROCEDURE ViewNot 
@LearnerID INT
AS
BEGIN
    SELECT n.ID, n.timestamp, n.message, n.urgency_level, n.ReadStatus
    FROM Notification n INNER JOIN ReceivedNotification rn ON n.ID = rn.NotificationID
    WHERE rn.LearnerID = @LearnerID;
END

exec ViewNot @LearnerID = 1;
---------------------------------------------------------
---10 Admin---
CREATE PROCEDURE CreateDiscussion 
@ModuleID INT, @courseID INT, @title VARCHAR(50), @description VARCHAR(50)
AS
BEGIN
    INSERT INTO Discussion_forum (ModuleID, CourseID, title, description, last_active, timestamp)
    VALUES (@ModuleID, @courseID, @title, @description, GETDATE(), GETDATE());
    print 'Discussion Forum Created';
END
exec CreateDiscussion @ModuleID = 1, @courseID = 1, @title = 'Programming Basics Forum', @description = 'Discuss programming concepts';
---------------------------------------------------------
---NUMBER 11 AS ADMIN -----WRITTEN BY ME

GO 
CREATE PROC RemoveBadge 
  @BadgeID INT 
AS
BEGIN 
  
IF EXISTS ( SELECT 1 FROM  Badge WHERE BadgeID = @BadgeID) 
BEGIN 
  DELETE 
  FROM Badge
  WHERE 
  @BadgeID = BadgeID 
  PRINT 'BADGE WAS REMOVED SUCCESSFULLY.'
   END
END 

EXEC RemoveBadge @BadgeID = 1;
---------------------------------------------------------


-------------NUMBER 12 AS ADMIN -----

GO 
CREATE PROC CriteriaDelete
  @criteria varchar(50)
  AS 
  BEGIN 

  DELETE 
  FROM Quest
  WHERE @criteria = criteria 

END

exec CriteriaDelete @criteria = 'Complete all data visualization tasks.'
---------------------------------------------------------


---------------NUMBER 13 AS ADMIN
GO 
CREATE PROC NotificationUpdate
    @LearnerID INT, 
    @NotificationID INT, 
    @ReadStatus BIT -- 0 fALSE ,1 TRUE  
as
begin
    if exists (select 1 from ReceivedNotification where LearnerID = @LearnerID and NotificationID = @NotificationID)
    begin
    		if @ReadStatus = 0
		begin
			update Notification
			set ReadStatus = 'READ'
			where ID = @NotificationID
		end
		else
		begin
			delete from Notification
			where ID = @NotificationID
		end
	end
    end

exec NotificationUpdate @LearnerID = 1, @NotificationID = 1, @ReadStatus = 1;
------------------------------------
---14 Admin---
CREATE PROCEDURE EmotionalTrendAnalysis (@CourseID INT, @ModuleID INT, @TimePeriod DATETIME)
AS
BEGIN
    SELECT 
        EF.LearnerID,
        EF.emotional_state,
        EF.timestamp,
        M.Title AS Module_Title,
        C.Title AS Course_Title
    FROM 
        Emotional_feedback EF
    JOIN 
        Learning_activities LA ON EF.activityID = LA.ActivityID
    JOIN 
        Modules M ON LA.ModuleID = M.ModuleID
    JOIN 
        Course C ON M.CourseID = C.CourseID
    WHERE 
        C.CourseID = @CourseID
        AND M.ModuleID = @ModuleID
        AND EF.timestamp >= @TimePeriod
    ORDER BY 
        EF.timestamp;
     
END;

exec EmotionalTrendAnalysis @CourseID = 1, @ModuleID = 1, @TimePeriod = '2024-11-20 00:00:00';
-------------AS A LEARNER-----------------



-------------NUMBER 1 AS A LEARNER ---------WRITTEN BY ME ----------

GO 
CREATE PROC ProfileUptade 
@LearnerID INT,
@ProfileID INT,
@PreferedContentType varchar(50),
@emotional_state varchar(50),
@PersonalityType varchar(50)

AS 
BEGIN 
UPDATE PersonalizationProfiles
SET 

 Prefered_content_type=@PreferedContentType,
 emotional_state=@emotional_state,
 personality_type=@PersonalityType
 WHERE LearnerID=@LearnerID AND ProfileID=@ProfileID

END 

exec ProfileUptade @LearnerID = 1, @ProfileID = 1, @PreferedContentType = 'Video Lectures', @emotional_state = 'Engaged', @PersonalityType = 'Extrovert'
--------------------------------------------------


---2 Learner---
CREATE PROC TotalPoints
@LearnerID INT,
@RewardType VARCHAR(50)
as 
begin
    select sum(b.points) as TotalPoints
    from Achievement a inner join Badge b
    on a.BadgeID = b.BadgeID
	where a.LearnerID = @LearnerID and a.type = @RewardType

end

exec TotalPoints @LearnerID = 2, @RewardType = 'Course-Based';
---------------------------------------------------------
-----------NUMEBR 3 AS LEARNER --------WRITTEN BY ME 

GO 
CREATE PROC EnrolledCourses
@LearnerID INT 

AS 
BEGIN 
SELECT c.CourseID , c.Title , c.description ,ce.status
FROM Course c INNER JOIN course_enrollment ce ON ce.CourseID= c.CourseID
WHERE ce.LearnerID =@LearnerID

END

exec EnrolledCourses @LearnerID = 1;
--------------------------------------------------
---4 Learner---
CREATE PROCEDURE Prerequisites
    @LearnerID INT,
    @CourseID INT
AS
BEGIN
    DECLARE @PrereqCount INT;
    DECLARE @CompletedCount INT;

   
    SELECT @PrereqCount = COUNT(*)
    FROM CoursePrerequisite
    WHERE CourseID = @CourseID;

   
    SELECT @CompletedCount = COUNT(*)
    FROM Course_enrollment CE
    INNER JOIN CoursePrerequisite CP ON CE.CourseID = CP.Prereq
    WHERE CE.LearnerID = @LearnerID AND CP.CourseID = @CourseID;


if @CompletedCount = @PrereqCount
print 'You have met the prerequisites for this course'
else
print 'You have not met the prerequisites for this course'
end


exec Prerequisites @LearnerID = 1, @CourseID = 2;
---------------------------------------------------------
-------------------NUMBER 5 AS LEARNER 

GO
CREATE PROC Moduletraits 
@TargetTrait VARCHAR(50),
@CourseID INT 

AS
BEGIN 
SELECT m.ModuleID , m.Title 
FROM Modules m
INNER JOIN Target_traits t ON m.ModuleID =t.ModuleID
WHERE 
t.CourseID=@CourseID AND t.Trait =@TargetTrait

END
exec Moduletraits @TargetTrait = 'Problem-Solving', @CourseID = 1;
-------------------------------------------------------------------------------------
-----------NUMBER 6 AS LEARNER -----WRITTEN BY ME 

GO 
CREATE PROC LeaderboardRank 
@LeaderboardID INT 

AS
BEGIN 

SELECT Learner.LearnerID , Learner.first_name , Learner.last_name , Ranking.rank , Ranking.total_points
FROM Ranking 
INNER JOIN Learner ON Ranking.LearnerID=Learner.LearnerID
WHERE Ranking.BoardID =@LeaderboardID ORDER BY Ranking.rank

END
exec LeaderboardRank @LeaderboardID = 1;
----------------------------------------------
-------NUMBER 7 AS LEARNER-------------WRITTEN BY ME 

GO 
CREATE PROC ViewMyDeviceCharge
@ActivityID INT,
@LearnerID INT,
@timestamp TIME ,
@emotionalstate VARCHAR(100)

AS
BEGIN 
INSERT INTO Emotional_feedback(LearnerID,activityID,timestamp,emotional_state)
VALUES
(@LearnerID,@ActivityID,@timestamp,@emotionalstate)

END
exec ViewMyDeviceCharge @ActivityID = 1, @LearnerID = 1, @timestamp = '10:00:00', @emotionalstate = 'Happy'
------------------------------------------------
---8 Learner---
create proc JoinQuest
@LearnerID INT,
@QuestID INT
as 
begin
      declare @max_participants int, @current_participants int
      select @max_participants = max_num_participants from Collaborative where QuestID = @QuestID
      select @current_participants = count(*) from LearnersCollaboration where QuestID = @QuestID
      if @current_participants < @max_participants
      begin 
       insert into LearnersCollaboration (LearnerID, QuestID, completion_status)
       values (@LearnerID, @QuestID, 'In Progress')
       print 'You have successfully joined the quest'
	   end
	   else
       print 'The quest is full, you cannot join'
end

exec JoinQuest @LearnerID = 3, @QuestID = 2;
---------------------------------------------------------
---------NUMBER 9 AS LEARNER --------WRITTEN BY ME 

GO 
CREATE PROC SkillsProfeciency
@LearnerID INT 

AS 
BEGIN 

SELECT Skills.skill , SkillProgression.proficiency_level
FROM SkillProgression 
INNER JOIN Skills ON SkillProgression.LearnerID =Skills.LearnerID AND SkillProgression.skill_name=Skills.skill
WHERE SkillProgression.LearnerID=@LearnerID

END 
exec SkillsProfeciency @LearnerID = 1;
-----------------------------------------------------------

----------NUMBER 10 AS LEARNER------------WRITTEN BY ME 

GO 
CREATE PROC Viewscore
@LearnerID INT ,
@AssessmentID INT ,
@score INT OUTPUT 

AS 
BEGIN 
 SELECT @score =Takenassessment.scoredPoint
 FROM Takenassessment
 WHERE Takenassessment.LearnerID=@LearnerID AND Takenassessment.AssessmentID=@AssessmentID

END

DECLARE @score INT
EXEC Viewscore @LearnerID = 1, @AssessmentID = 1, @score = @score OUTPUT
print 'Your score is: ' + CAST(@score AS VARCHAR(10));
-----------------------------------------------------

---11 Learner---
create proc AssessmentsList
@CourseID INT,
@ModuleID INT,
@LearnerID INT
as 
begin
select a.ID,a.title,t.scoredPoint
from Assessments a inner join Takenassessment t on a.ID=t.AssessmentID
where a.CourseID = @CourseID and a.ModuleID = @ModuleID and t.LearnerID = @LearnerID
end

exec AssessmentsList @CourseID = 1, @ModuleID = 1, @LearnerID = 1;
---------------------------------------------------------
---12 Learner---
CREATE PROCEDURE CourseRegister
    @LearnerID INT,
    @CourseID INT
AS
BEGIN
    DECLARE @PrereqCount INT;
    DECLARE @CompletedCount INT;

   
    SELECT @PrereqCount = COUNT(*)
    FROM CoursePrerequisite
    WHERE CourseID = @CourseID;

   
    SELECT @CompletedCount = COUNT(*)
    FROM Course_enrollment CE
    INNER JOIN CoursePrerequisite CP ON CE.CourseID = CP.Prereq
    WHERE CE.LearnerID = @LearnerID AND CP.CourseID = @CourseID;

    IF @PrereqCount = @CompletedCount
    BEGIN
        
        insert into Course_enrollment (CourseID, LearnerID, completion_date, enrollment_date, status)
        values (@CourseID, @LearnerID, NULL, GETDATE(), 'Enrolled')
        PRINT 'Registration approved for the course.';
    END
    ELSE
    BEGIN
        PRINT 'Prerequisites not completed, registration denied.';
    END
END

exec Courseregister @LearnerID = 1, @CourseID = 2;
---------------------------------------------------------
---------------NUMBER 13 AS LEARNER-------WRITTEN BY ME 

GO
CREATE PROCEDURE Post
    @LearnerID INT,
    @DiscussionID INT,
    @Post NVARCHAR(MAX)
AS
BEGIN
    
    IF EXISTS (SELECT 1 FROM Discussion_forum WHERE forumID = @DiscussionID)
    BEGIN
    INSERT INTO LearnerDiscussion (ForumID, LearnerID, Post, time)
        VALUES (@DiscussionID, @LearnerID, @Post, GETDATE());
    END
END

exec Post @LearnerID = 1, @DiscussionID = 1, @Post = 'I have a question about variables.';
---------------------------------------------------------


------------NUMBER 14 AS LEARNER--------WRITTEN BY ME 

GO
CREATE PROC AddGoal
@LearnerID INT,
@GoalID INT

AS
BEGIN
if not exists (select 1 from LearnersGoals where LearnerID = @LearnerID and GoalID = @GoalID)
begin
INSERT INTO LearnersGoals(LearnerID,GoalID)
VALUES (@LearnerID,@GoalID)
end
END

exec AddGoal @LearnerID = 1, @GoalID = 2;
----------------------------------------------------



-------------NUMEBR 15 AS LEARNER---------WRITTEN BY ME 

GO 
CREATE PROC CurrentPath
@LearnerID INT 

AS
BEGIN 
SELECT l.pathID , l.Completion_status 
FROM Learning_path l
WHERE l.LearnerID =@LearnerID

END 

exec CurrentPath @LearnerID = 1;
---------------------------------------------------
---16 Learner---
create proc QuestMembers
@LearnerID INT
as 
begin
declare @QuestID int
select @QuestID = QuestID from LearnersCollaboration where LearnerID = @LearnerID;
with temp as(
select lc.LearnerID , l.first_name , l.last_name, c.QuestID
from LearnersCollaboration lc inner join Learner l on lc.LearnerID = l.LearnerID
inner join Collaborative c on lc.QuestID = c.QuestID
where c.QuestID = @QuestID)
select * from temp
where LearnerID != @LearnerID
end

exec QuestMembers @LearnerID = 2;
----------------------------------------------------
---17 Learner---
create proc QuestProgress
@LearnerID INT
as 
begin
select q.QuestID, q.title, lc.completionStatus
from Quest q inner join LearnerMastery lc on q.QuestID = lc.QuestID
where lc.LearnerID = @LearnerID
end

exec QuestProgress @LearnerID = 2;
---------------------------------------------------------
---18 Learner---
create proc GoalReminder
@LearnerID INT
as 
begin
declare @current_date datetime = getdate();
if exists ( select 1 from Learning_goal lg inner join LearnersGoals lgs on lg.ID = lgs.GoalID where lgs.LearnerID = @LearnerID and lg.deadline <= @current_date)
print('Reminder: You are falling behind on your learning goal timelines!')
else
print('No overdue goals. Keep up the good work!')
end

exec GoalReminder @LearnerID = 1;
---------------------------------------------------------
---19 Learner---
create proc SkillProgressHistory
@LearnerID INT,
@Skill VARCHAR(50)
as 
begin
select sp.skill_name,sp.proficiency_level,sp.timestamp
from SkillProgression sp
where sp.LearnerID = @LearnerID and sp.skill_name = @Skill
group by sp.timestamp , sp.skill_name, sp.proficiency_level
end

exec SkillProgressHistory @LearnerID = 1, @Skill = 'Python';
---------------------------------------------------------
---20 Learner---
create proc AssessmentAnalysis
@LearnerID INT
as 
begin
select a.type, a.total_marks, ta.scoredPoint
from Assessments a inner join Takenassessment ta on a.ID = ta.AssessmentID
where ta.LearnerID = @LearnerID
end

exec AssessmentAnalysis @LearnerID = 1;
---------------------------------------------------------
---21 Learner---
create proc LeaderboardFilter
@LeaderboardID INT
as 
begin
select r.LearnerID, r.rank, r.total_points
from Ranking r
where r.BoardID = @LeaderboardID
order by r.rank desc
end


exec LeaderboardFilter @LeaderboardID = 1;
---------------------------------------------------------

----As Instructor----
-------------
---1 Instructor---
CREATE PROCEDURE SkillLearners (@Skillname VARCHAR(50))
AS
BEGIN
    SELECT s.skill AS SkillName, l.first_name, l.last_name , l.LearnerID
    FROM Skills s
    JOIN Learner l ON s.LearnerID = l.LearnerID
    WHERE s.skill = @Skillname;
END;

exec SkillLearners @Skillname = 'Java';
---------------------------------------------------------
---2 Instructor---
CREATE PROCEDURE NewActivity (@CourseID INT, @ModuleID INT, @activitytype VARCHAR(50), 
                               @instructiondetails VARCHAR(MAX), @maxpoints INT)
AS
BEGIN
    INSERT INTO Learning_activities (CourseID, ModuleID, activity_type, instruction_details, Max_points)
    VALUES (@CourseID, @ModuleID, @activitytype, @instructiondetails, @maxpoints);
END;

exec NewActivity @CourseID = 1, @ModuleID = 1, @activitytype = 'Discussion', @instructiondetails = 'Participate in a forum discussion', @maxpoints = 10;
---------------------------------------------------------
---3 Instructor---
CREATE PROCEDURE NewAchievement (@LearnerID INT, @BadgeID INT, @description VARCHAR(MAX), 
                                 @date_earned DATE, @type VARCHAR(50))
AS
BEGIN
    INSERT INTO Achievement (LearnerID, BadgeID, description, date_earned, type)
    VALUES (@LearnerID, @BadgeID, @description, @date_earned, @type);
END;

exec NewAchievement @LearnerID = 1, @BadgeID = 2, @description = 'Completed course', @date_earned = '2024-11-20', @type = 'Course-Based';
---------------------------------------------------------
---4 Instructor---
CREATE PROCEDURE LearnerBadge (@BadgeID INT)
AS
BEGIN
    SELECT l.LearnerID, l.first_name, l.last_name, a.date_earned
    FROM Achievement a
    JOIN Learner l ON a.LearnerID = l.LearnerID
    WHERE a.BadgeID = @BadgeID;
END;

exec LearnerBadge @BadgeID = 2;
---------------------------------------------------------
---5 Instructor---
CREATE PROCEDURE NewPath (@LearnerID INT, @ProfileID INT, @completion_status VARCHAR(50), 
                          @custom_content VARCHAR(MAX), @adaptiverules VARCHAR(MAX))
AS
BEGIN
    INSERT INTO Learning_path (LearnerID, ProfileID, completion_status, custom_content, adaptive_rules)
    VALUES (@LearnerID, @ProfileID, @completion_status, @custom_content, @adaptiverules);
END;

exec NewPath @LearnerID = 1, @ProfileID = 1, @completion_status = 'In Progress', @custom_content = 'Learner is focusing on AI topics', @adaptiverules = 'Use quizzes for reinforcement';
---------------------------------------------------------
---6 Instructor---
CREATE PROCEDURE TakenCourses (@LearnerID INT)
AS
BEGIN
    SELECT c.CourseID, c.Title, c.learning_objective, c.credit_points, c.difficulty_level
    FROM Course c
    JOIN Course_enrollment ce ON c.CourseID = ce.CourseID
    WHERE ce.LearnerID = @LearnerID;
END;

exec TakenCourses @LearnerID = 1;
----------------------------------------------------------
---7 Instructor---
CREATE PROCEDURE CollaborativeQuest (@difficulty_level VARCHAR(50), @criteria VARCHAR(50), 
                                    @description VARCHAR(50), @title VARCHAR(50), 
                                    @Maxnumparticipants INT, @deadline DATETIME)
AS
BEGIN
    INSERT INTO Quest (difficulty_level, criteria, description, title)
    VALUES (@difficulty_level, @criteria, @description, @title);
    
    DECLARE @QuestID INT = SCOPE_IDENTITY();

    INSERT INTO Collaborative (QuestID, deadline, max_num_participants)
    VALUES (@QuestID, @deadline, @Maxnumparticipants);
END;

exec CollaborativeQuest @difficulty_level = 'Advanced', @criteria = 'Complete all tasks', @description = 'A challenging quest', @title = 'Programming Quest', @Maxnumparticipants = 10, @deadline = '2024-12-01 00:00:00';
---------------------------------------------------------
------------NUMBER 8 AS INSTRUCTOR---WRITTEN BY ME 

GO 
CREATE PROC DeadlineUpdate
@QuestID INT,
@deadline datetime 

AS
BEGIN 
UPDATE Collaborative
SET deadline =@deadline
WHERE QuestID =@QuestID

END
exec DeadlineUpdate @QuestID = 2, @deadline = '2024-12-01 00:00:00'
--------------------------------------------------------

--------NUMBER 9 AS INSTUCTOR-------------------WRITTEN BY ME

GO 
CREATE PROC GradeUpdate
@LearnerID INT,
@AssessmentID INT,
@points INT

AS
BEGIN
IF EXISTS(
SELECT 1 FROM  Takenassessment 
WHERE LearnerID=@LearnerID AND AssessmentID =@AssessmentID
)
BEGIN
UPDATE Takenassessment 
SET scoredpoint = @points
WHERE LearnerID=@LearnerID AND AssessmentID =@AssessmentID
PRINT 'GRADE UPDATED';
END
ELSE 
BEGIN 
PRINT 'ASSESSMENT ID OR LEARNER ID IS WRONG!!';
END

END
exec GradeUpdate @LearnerID = 1, @AssessmentID = 1, @points = 90
-----------------------------------------------------------
----------NUMBER 10 AS INSTRUCTOR-----WRITTEN BY ME 

GO 
CREATE PROC AssessmentNot
@NotificationID INT,
@timestamp datetime,
@message VARCHAR(max), 
@urgencylevel VARCHAR(50), 
@LearnerID INT

AS
BEGIN 
 SET IDENTITY_INSERT Notification ON
INSERT INTO Notification(ID,timestamp,message,urgency_level)
VALUES (@NotificationID,@timestamp,@message,@urgencylevel)
SET IDENTITY_INSERT Notification OFF
INSERT INTO ReceivedNotification(NotificationID,LearnerID)
VALUES (@NotificationID,@LearnerID)

print 'Notification Sent'

END
exec AssessmentNot @NotificationID = 1, @timestamp = '2024-11-24 09:00:00', @message = 'Complete your assessment!', @urgencylevel = 'High', @LearnerID = 1
---------NUMBER 11 AS INSTRUCTOR-----------WRITTEN BY ME
GO 
CREATE PROC NewGoal
@GoalID INT,
@status VARCHAR(MAX),
@deadline datetime,
@description VARCHAR(MAX)

AS 
BEGIN 
 SET IDENTITY_INSERT Learning_goal ON
INSERT INTO Learning_goal(ID,status,deadline,description)
VALUES (@GoalID,@status,@deadline,@description)
    SET IDENTITY_INSERT Learning_goal OFF

END 
exec NewGoal @GoalID = 4, @status = 'In Progress', @deadline = '2024-12-31', @description = 'Complete advanced programming tasks'
-------------------------------------------------------

---------------NUMBER 12 AS INSTRUCTOR----WRITTEN BY ME 

GO
CREATE PROC LearnersCoutrses
@CourseID INT,
@InstructorID INT

AS 
BEGIN 

 SELECT
 L.LearnerID,
 L.first_name,
 L.last_name
 FROM Learner L
 INNER JOIN 
 course_enrollment ce ON L.LearnerID = ce.LearnerID
 INNER JOIN 
 Teaches T ON ce.CourseID=T.CourseID
 WHERE T.InstructorID=@InstructorID AND ce.CourseID =@CourseID

END
exec LearnersCoutrses @CourseID = 1, @InstructorID = 1
 -------------------------------------------------------------
 --------------NUMBER 13 AS INSTRUCTOR-----WRITTEN BY ME 

 GO 
 CREATE PROC LastActive
 @ForumID INT,
 @lastactive datetime OUTPUT 

 AS
 BEGIN 
 SELECT @lastactive =last_active 
 FROM  Discussion_forum
 WHERE ForumID=@ForumID;

 END

 declare @lastactive datetime
 exec LastActive @ForumID = 1, @lastactive = @lastactive OUTPUT
 PRINT 'Last Active: ' + CAST(@lastactive AS VARCHAR(50));
 ------------------------------------------------------------
 

 -----------NUMBER 14 AS INSTRUCTOR----------WRITTEN BY ME ----edited by wahsh
 GO 
 CREATE PROC CommonEmotionalState
 @state VARCHAR(50) OUTPUT
as
begin
with temp as (
select count(*) as cnt, emotional_state s
from Emotional_feedback
group by emotional_state
)
select @state = s
from temp
where cnt = (select max(cnt) from temp)
end

declare @state VARCHAR(50)
exec CommonEmotionalState @state = @state OUTPUT
PRINT 'Most Common Emotional State: ' + @state;

---------------------------------------------------------
---15 Instructor---
create proc ModuleDifficulty
@CourseID INT
as 
begin 
select m.ModuleID, m.Title, m.difficulty
from Modules m 
where m.CourseID = @CourseID
order by m.difficulty
end

exec ModuleDifficulty @CourseID = 1;
---------------------------------------------------------
---16 Instructor---
create proc ProficiencyLevel
@LearnerID INT,
@Skill VARCHAR(50) output
as 
begin
declare @max_proficiency int
select @max_proficiency = max(proficiency_level) from SkillProgression where LearnerID = @LearnerID
select @Skill = skill_name from SkillProgression where proficiency_level = @max_proficiency and LearnerID = @LearnerID
end

declare @Skill VARCHAR(50)
exec ProficiencyLevel @LearnerID = 1, @Skill = @Skill output
print 'The skill with the highest proficiency level is: ' + @Skill;

---------------------------------------------------------
---17 Instructor---
create proc ProficinecyUpdate
@Skill VARCHAR(50),
@LearnerID INT,
@ProficiencyLevel INT
as
begin
update SkillProgression 
set proficiency_level = @ProficiencyLevel
where SkillProgression.LearnerID = @LearnerID and SkillProgression.skill_name = @Skill
end

exec ProficinecyUpdate @Skill = 'Python', @LearnerID = 1, @ProficiencyLevel = 3;
---------------------------------------------------------
---18 Instructor---
create proc LeastBadge
@LearnerID INT output
as 
begin
select top 1 @LearnerID = LearnerID
from Achievement
group by LearnerID
order by count(*) asc
end

declare @LearnerID INT
exec LeastBadge @LearnerID = @LearnerID output
print 'The learner with the least number of badges is: ' + CAST(@LearnerID AS VARCHAR(10));
---------------------------------------------------------
---19 Instructor---
create proc PreferredType
@Type VARCHAR(50) output
as 
begin
with temp as (
select count(*) as cnt, Prefered_content_type t
from PersonalizationProfiles
group by Prefered_content_type
)
select @Type = t
from temp
where temp.cnt = (select max(cnt) from temp)
end

declare @Type VARCHAR(50)
exec PreferredType @Type = @Type output
print 'The most preferred content type is: ' + @Type;
---------------------------------------------------------
---20 Instructor---
create proc AssessmentAnalytics
@CourseID INT,
@ModuleID INT
as
begin
select count(ta.LearnerID) as Number_Of_Learners , avg(ta.scoredPoint) as Average , a.title
from Assessments a inner join Takenassessment ta on ta.AssessmentID=a.ID
where a.CourseID = @CourseID and a.ModuleID = @ModuleID
group by a.title
end

exec AssessmentAnalytics @CourseID = 1, @ModuleID = 1;
---------------------------------------------------------
---21 Instructor---
create proc EmotionalTrendAnalysis
@CourseID INT,
@ModuleID INT,
@TimePeriod datetime
as 
begin
select  ef.timestamp ,count(ef.emotional_state) as Number_Of_EmotionalStates, ef.emotional_state
from Emotional_feedback ef inner join Learning_activities la on ef.activityID = la.ActivityID
where la.CourseID = @CourseID and la.ModuleID = @ModuleID and ef.timestamp >= @TimePeriod
group by ef.emotional_state,ef.timestamp
order by ef.timestamp
end

exec EmotionalTrendAnalysis @CourseID = 1, @ModuleID = 1, @TimePeriod = '2024-11-20 00:00:00';
---------------------------------------------------------
