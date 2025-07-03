use milestone2DB



-- Insert into Learner
INSERT INTO Learner (first_name, last_name, gender, birth_date, country, cultural_background)
VALUES 
('Alice', 'Smith', 'Female', '1995-05-15', 'USA', 'Western'),
('Bob', 'Johnson', 'Male', '1990-03-12', 'Canada', 'Western'),
('Charlie', 'Brown', 'Male', '1998-07-08', 'UK', 'Western');

-- Insert into Skills
INSERT INTO Skills (LearnerID, skill)
VALUES 
(1, 'Python'),
(1, 'Data Analysis'),
(2, 'Java'),
(3, 'Project Management');

-- Insert into LearningPreference
INSERT INTO LearningPreference (LearnerID, preference)
VALUES 
(1, 'Visual Learning'),
(2, 'Hands-On'),
(3, 'Audio Learning');

-- Insert into PersonalizationProfiles
INSERT INTO PersonalizationProfiles (LearnerID, Prefered_content_type, emotional_state, personality_type)
VALUES 
(1, 'Video', 'Focused', 'Introvert'),
(2, 'Text', 'Excited', 'Extrovert'),
(3, 'Interactive', 'Calm', 'Ambivert');

-- Insert into HealthCondition
INSERT INTO HealthCondition (LearnerID, ProfileID, condition)
VALUES 
(1, 1, 'Colorblind'),
(2, 2, 'Dyslexia');

-- Insert into Course
INSERT INTO Course (Title, learning_objective, credit_points, difficulty_level, description)
VALUES 
('Introduction to Programming', 'Learn basic programming concepts', 5, 'Beginner', 'A basic programming course for beginners.'),
('Advanced Python', 'Master Python programming for data analysis', 10, 'Intermediate', 'An intermediate course focused on Python.');

-- Insert into CoursePrerequisite
INSERT INTO CoursePrerequisite (CourseID, Prereq)
VALUES 
(2, 1);

-- Insert into Modules
INSERT INTO Modules (CourseID, Title, difficulty, contentURL)
VALUES 
(1, 'Getting Started with Programming', 'Easy', 'http://example.com/module1'),
(2, 'Data Analysis with Python', 'Moderate', 'http://example.com/module2');

-- Insert into Target_traits
INSERT INTO Target_traits (ModuleID, CourseID, Trait)
VALUES 
(1, 1, 'Problem-Solving'),
(2, 2, 'Data Analysis');

-- Insert into ModuleContent
INSERT INTO ModuleContent (ModuleID, CourseID, content_type)
VALUES 
(1, 1, 'Video'),
(2, 2, 'Text');

-- Insert into ContentLibrary
INSERT INTO ContentLibrary (ModuleID, CourseID, Title, description, metadata, type, content_URL)
VALUES 
(1, 1, 'Intro Video', 'Introduction to programming', 'Beginner-level content', 'Video', 'http://example.com/content1'),
(2, 2, 'Data Analysis Guide', 'Guide to data analysis with Python', 'Intermediate content', 'Text', 'http://example.com/content2');

-- Insert test data into Learning_path table
INSERT INTO Learning_path (LearnerID, ProfileID, completion_status, custom_content, adaptive_rules)
VALUES
(1, 1, 'In Progress', 'Learner is focusing on AI topics', 'Use quizzes for reinforcement'),
(2, 2, 'Completed', 'Learner completed Data Science track', 'Provide recommended next steps');

-- Insert into Assessments
INSERT INTO Assessments (ModuleID, CourseID, type, total_marks, passing_marks, criteria, weightage, description, title)
VALUES 
(1, 1, 'Quiz', 100, 50, 'Complete all questions', 0.2, 'Basic programming quiz', 'Programming Basics Quiz'),
(2, 2, 'Assignment', 100, 60, 'Submit on time', 0.4, 'Data analysis assignment', 'Data Analysis Assignment');

-- Insert into Takenassessment
INSERT INTO Takenassessment (AssessmentID, LearnerID, scoredPoint)
VALUES 
(1, 1, 80),
(2, 2, 70);

-- Insert into Learning_activities
INSERT INTO Learning_activities (ModuleID, CourseID, activity_type, instruction_details, Max_points)
VALUES 
(1, 1, 'Discussion', 'Participate in a forum discussion', 10),
(2, 2, 'Project', 'Complete a data analysis project', 50);

-- Insert into Interaction_log
INSERT INTO Interaction_log (activity_ID, LearnerID, Duration, Timestamp, action_type)
VALUES 
(1, 1, 30, '2024-11-28 10:00:00', 'Participated'),
(2, 2, 120, '2024-11-28 11:00:00', 'Submitted');

-- Insert into Emotional_feedback
INSERT INTO Emotional_feedback (LearnerID, activityID, timestamp, emotional_state)
VALUES 
(1, 1, '2024-11-28 10:30:00', 'Happy'),
(2, 2, '2024-11-28 11:30:00', 'Motivated');

-- Insert into Emotionalfeedback_review
INSERT INTO Emotionalfeedback_review (FeedbackID, InstructorID, review)
VALUES
(1, 1, 'The feedback suggests a positive learning experience.'),
(2, 2, 'The learner appears to be struggling with time management.');

-- Insert into Instructor
INSERT INTO Instructor (name, latest_qualification, expertise_area, email)
VALUES 
('Dr. Emily White', 'PhD in Computer Science', 'Programming', 'emily.white@example.com'),
('Mr. John Doe', 'MSc in Data Science', 'Data Analysis', 'john.doe@example.com');

-- Insert into Course_enrollment
INSERT INTO Course_enrollment (CourseID, LearnerID, completion_date, enrollment_date, status)
VALUES 
(1, 1, NULL, '2024-10-01', 'Ongoing'),
(2, 2, '2024-11-20', '2024-09-01', 'Completed');

-- Insert into Teaches
INSERT INTO Teaches (InstructorID, CourseID)
VALUES 
(1, 1),
(2, 2);

-- Insert into Leaderboard
INSERT INTO Leaderboard (season)
VALUES 
('Fall 2024');

-- Insert into Ranking
INSERT INTO Ranking (BoardID, LearnerID, CourseID, rank, total_points)
VALUES 
(1, 1, 1, 1, 90),
(1, 2, 2, 2, 85);

-- Insert into Learning_goal
INSERT INTO Learning_goal (status, deadline, description)
VALUES 
('In Progress', '2024-12-31', 'Complete Python programming basics'),
('Not Started', '2025-01-15', 'Learn data visualization techniques');

-- Insert into LearnersGoals
INSERT INTO LearnersGoals (GoalID, LearnerID)
VALUES 
(1, 1),
(2, 2);

-- Insert into Survey
INSERT INTO Survey (Title)
VALUES 
('Course Feedback Survey'),
('Skill Development Needs Survey');

-- Insert into SurveyQuestions
INSERT INTO SurveyQuestions (SurveyID, Question)
VALUES 
(1, 'How would you rate the course content?'),
(1, 'Was the course material easy to understand?'),
(2, 'Which skills do you want to improve?');

-- Insert into FilledSurvey
INSERT INTO FilledSurvey (SurveyID, Question, LearnerID, Answer)
VALUES 
(1, 'How would you rate the course content?', 1, 'Excellent'),
(1, 'Was the course material easy to understand?', 1, 'Yes, very clear'),
(2, 'Which skills do you want to improve?', 2, 'Data analysis and visualization');

-- Insert into Notification
INSERT INTO Notification (timestamp, message, urgency_level, ReadStatus)
VALUES 
('2024-11-28 12:00:00', 'Your assignment has been graded.', 'Medium', 'Unread'),
('2024-11-28 15:00:00', 'New course available: Advanced Machine Learning.', 'High', 'Unread');

-- Insert into ReceivedNotification
INSERT INTO ReceivedNotification (NotificationID, LearnerID)
VALUES 
(1, 1),
(2, 2);

-- Insert into Badge
INSERT INTO Badge (title, description, criteria, points)
VALUES 
('Python Basics Mastery', 'Awarded for mastering Python basics.', 'Score above 90% in Python assessment.', 100),
('Data Analysis Wizard', 'Awarded for completing data analysis tasks.', 'Complete all data analysis modules.', 150);

-- Insert into SkillProgression
INSERT INTO SkillProgression (proficiency_level, LearnerID, skill_name, timestamp)
VALUES 
(1, 1, 'Python', '2024-11-28 14:00:00'),
(2, 1, 'Data Analysis', '2024-11-28 15:00:00');

-- Insert into Achievement
INSERT INTO Achievement (LearnerID, BadgeID, description, date_earned, type)
VALUES 
(1, 1, 'Mastered Python Basics', '2024-11-20', 'Skill-Based'),
(2, 2, 'Completed Data Analysis Modules', '2024-11-25', 'Course-Based');

-- Insert into Reward
INSERT INTO Reward (value, description, type)
VALUES 
(500, 'Discount on next course enrollment', 'Discount'),
(1000, 'Gift voucher for completing all modules', 'Gift');

-- Insert into Quest
INSERT INTO Quest (difficulty_level, criteria, description, title)
VALUES 
('Intermediate', 'Complete all data visualization tasks.', 'A quest to improve data visualization skills.', 'Data Visualization Quest'),
('Advanced', 'Solve a complex programming challenge.', 'A challenging quest for experienced programmers.', 'Advanced Programming Quest');

-- Insert into Skill_Mastery
INSERT INTO Skill_Mastery (QuestID, skill)
VALUES 
(1, 'Data Visualization'),
(2, 'Python');

-- Insert into Collaborative
INSERT INTO Collaborative (QuestID, deadline, max_num_participants)
VALUES 
(1, '2024-12-15', 10),
(2, '2024-12-20', 5);

-- Insert into LearnersCollaboration
INSERT INTO LearnersCollaboration (LearnerID, QuestID, completion_status)
VALUES 
(1, 1, 'In Progress'),
(2, 2, 'Completed');

-- Insert into LearnerMastery
INSERT INTO LearnerMastery (QuestID, LearnerID, completionStatus)
VALUES 
(1, 1, 'Completed'),
(2, 2, 'In Progress');

-- Insert into Discussion_forum
INSERT INTO Discussion_forum (ModuleID, CourseID, title, last_active, timestamp, description)
VALUES 
(1, 1, 'Introduction to Programming Forum', '2024-11-28 16:00:00', '2024-11-28 10:00:00', 'Discussion forum for programming basics.'),
(2, 2, 'Data Analysis Forum', '2024-11-28 18:00:00', '2024-11-28 11:00:00', 'Forum for data analysis topics.');

-- Insert into LearnerDiscussion
INSERT INTO LearnerDiscussion (ForumID, LearnerID, Post, time)
VALUES 
(1, 1, 'What is the best way to learn Python?', '2024-11-28 10:30:00'),
(2, 2, 'How to start with data visualization?', '2024-11-28 11:30:00');

-- Insert into QuestReward
INSERT INTO QuestReward (RewardID, QuestID, LearnerID, Time_earned)
VALUES 
(1, 1, 1, '2024-11-28 14:30:00'),
(2, 2, 2, '2024-11-28 15:30:00');

-- Insert test data into the Teaches table
INSERT INTO Teaches (InstructorID, CourseID)
VALUES
(1, 2)
 
