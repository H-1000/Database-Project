create database milestone2DB
use milestone2DB

CREATE TABLE Learner (
    LearnerID INT identity,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    gender VARCHAR(10),
    birth_date DATE,
    country VARCHAR(100),
    cultural_background VARCHAR(100)
    Primary Key (LearnerID)
);

CREATE TABLE Skills (
    LearnerID INT,
    skill VARCHAR(100),
    PRIMARY KEY(LearnerID, skill),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE LearningPreference (
    LearnerID INT,
    preference VARCHAR(100),
    PRIMARY KEY(LearnerID, preference), 
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE PersonalizationProfiles (
    LearnerID INT,
    ProfileID INT identity,
    Prefered_content_type VARCHAR(100),
    emotional_state VARCHAR(100),
    personality_type VARCHAR(100),
    PRIMARY KEY(ProfileID, LearnerID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE HealthCondition (
    LearnerID INT,
    ProfileID INT,
    condition VARCHAR(100),
    PRIMARY KEY(LearnerID, ProfileID, condition),
    FOREIGN KEY (ProfileID,LearnerID) REFERENCES PersonalizationProfiles(ProfileID,LearnerID) on update cascade on delete cascade
);

CREATE TABLE Course (
    CourseID INT identity,
    Title VARCHAR(255),
    learning_objective TEXT,
    credit_points INT,
    difficulty_level VARCHAR(50),
    description TEXT
    primary key (CourseID)
);

CREATE TABLE CoursePrerequisite (
    CourseID INT,
    Prereq INT,
    PRIMARY KEY(CourseID, Prereq),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) on update cascade on delete no action,
    FOREIGN KEY (Prereq) REFERENCES Course(CourseID) on update no action on delete no action
);

CREATE TABLE Modules (
    ModuleID INT identity ,
    CourseID INT,
    Title VARCHAR(255),
    difficulty VARCHAR(50),
    contentURL VARCHAR(255),
    PRIMARY KEY(ModuleID, CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) on update cascade on delete cascade
);

CREATE TABLE Target_traits (
    ModuleID INT,
    CourseID INT,
    Trait VARCHAR(100),
    PRIMARY KEY(ModuleID, CourseID, Trait),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules(ModuleID,CourseID) on update cascade on delete cascade
);

CREATE TABLE ModuleContent (
    ModuleID INT,
    CourseID INT,
    content_type VARCHAR(100),
    PRIMARY KEY(ModuleID, CourseID, content_type),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules(ModuleID,CourseID) on update cascade on delete cascade
);

CREATE TABLE ContentLibrary (
    ID INT identity,
    ModuleID INT,
    CourseID INT,
    Title VARCHAR(255),
    description TEXT,
    metadata TEXT,
    type VARCHAR(50),
    content_URL VARCHAR(255),
    PRIMARY KEY(ID),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules(ModuleID,CourseID) on update cascade on delete cascade
);

CREATE TABLE Assessments (
    ID INT identity,
    ModuleID INT,
    CourseID INT,
    type VARCHAR(100),
    total_marks INT,
    passing_marks INT,
    criteria VARCHAR(50),
    weightage FLOAT,
    description TEXT,
    title VARCHAR(255),
    primary key (ID),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules(ModuleID,CourseID) on update cascade on delete cascade
);

CREATE TABLE Takenassessment (
    AssessmentID INT,
    LearnerID INT,
    scoredPoint FLOAT,
    PRIMARY KEY(AssessmentID, LearnerID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade,
    FOREIGN KEY (AssessmentID) REFERENCES Assessments(ID) on update cascade on delete cascade
);

CREATE TABLE Learning_activities (
    ActivityID INT identity,
    ModuleID INT,
    CourseID INT,
    activity_type VARCHAR(100),
    instruction_details TEXT,
    Max_points INT,
    PRIMARY KEY(ActivityID),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules(ModuleID,CourseID) on update cascade on delete cascade
);

CREATE TABLE Interaction_log (
    LogID INT identity,
    activity_ID INT,
    LearnerID INT,
    Duration INT,
    Timestamp DATETIME,
    action_type VARCHAR(100),
    primary key (LogID),
    FOREIGN KEY (activity_ID) REFERENCES Learning_activities(ActivityID) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE Emotional_feedback (
    FeedbackID INT identity,
    LearnerID INT,
    activityID INT,
    timestamp DATETIME,
    emotional_state VARCHAR(100),
    primary key (FeedbackID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade,
    FOREIGN KEY (activityID) REFERENCES Learning_activities(ActivityID) on update cascade on delete cascade
);

CREATE TABLE Learning_path (
    pathID INT identity,
    LearnerID INT,
    ProfileID INT,
    completion_status VARCHAR(50),
    custom_content TEXT,
    adaptive_rules TEXT,
    primary key (pathID),
    FOREIGN KEY (ProfileID,LearnerID) REFERENCES PersonalizationProfiles(ProfileID,LearnerID) on update cascade on delete cascade
);

CREATE TABLE Instructor (
    InstructorID INT identity,
    name VARCHAR(255),
    latest_qualification VARCHAR(255),
    expertise_area VARCHAR(255),
    email VARCHAR(100)
    primary key (InstructorID)
);

CREATE TABLE Pathreview (
    InstructorID INT,
    PathID INT,
    review TEXT,
    PRIMARY KEY(InstructorID, PathID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) on update cascade on delete cascade,
    FOREIGN KEY (PathID) REFERENCES Learning_path(pathID) on update cascade on delete cascade
);

CREATE TABLE Emotionalfeedback_review (
    FeedbackID INT,
    InstructorID INT,
    review TEXT,
    PRIMARY KEY(FeedbackID, InstructorID),
    FOREIGN KEY (FeedbackID) REFERENCES Emotional_feedback(FeedbackID) on update cascade on delete cascade,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) on update cascade on delete cascade
);

CREATE TABLE Course_enrollment (
    EnrollmentID INT identity,
    CourseID INT,
    LearnerID INT,
    completion_date DATE,
    enrollment_date DATE,
    status VARCHAR(50),
    primary key (EnrollmentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE Teaches (
    InstructorID INT,
    CourseID INT,
    PRIMARY KEY(InstructorID, CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) on update cascade on delete cascade,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) on update cascade on delete cascade
);

CREATE TABLE Leaderboard (
    BoardID INT identity,
    season VARCHAR(50)
    primary key (BoardID)
);

CREATE TABLE Ranking (
    BoardID INT,
    LearnerID INT,
    CourseID INT,
    rank INT,
    total_points INT,
    PRIMARY KEY(BoardID, LearnerID),
    FOREIGN KEY (BoardID) REFERENCES Leaderboard(BoardID) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) on update cascade on delete cascade
);

CREATE TABLE Learning_goal (
    ID INT identity,
    status VARCHAR(50),
    deadline DATE,
    description TEXT
    primary key (ID)
);

CREATE TABLE LearnersGoals (
    GoalID INT,
    LearnerID INT,
    PRIMARY KEY(GoalID, LearnerID),
    FOREIGN KEY (GoalID) REFERENCES Learning_goal(ID) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE Survey (
    ID INT identity,
    Title VARCHAR(255)
    primary key (ID)
);

CREATE TABLE SurveyQuestions (
    SurveyID INT,
    Question VARCHAR(255),
    PRIMARY KEY(SurveyID,Question),
    FOREIGN KEY (SurveyID) REFERENCES Survey(ID) on update cascade on delete cascade
);


CREATE TABLE FilledSurvey (
    SurveyID INT,
    Question VARCHAR(255),
    LearnerID INT,
    Answer TEXT,
    PRIMARY KEY(SurveyID, Question, LearnerID),
    FOREIGN KEY (SurveyID,Question) REFERENCES SurveyQuestions(SurveyID,Question) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE Notification (
    ID INT identity,
    timestamp DATETIME,
    message TEXT,
    urgency_level VARCHAR(50),
    ReadStatus VARCHAR(10)
    primary key (ID)
);

CREATE TABLE ReceivedNotification (
    NotificationID INT,
    LearnerID INT,
    PRIMARY KEY(NotificationID, LearnerID),
    FOREIGN KEY (NotificationID) REFERENCES Notification(ID) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);

CREATE TABLE Badge (
    BadgeID INT identity,
    title VARCHAR(255),
    description TEXT,
    criteria VARCHAR(50),
    points INT
    primary key (BadgeID)
);

CREATE TABLE SkillProgression (
    ID INT identity,
    proficiency_level INT,
    LearnerID INT,
    skill_name VARCHAR(100),
    timestamp DATETIME,
    primary key (ID),
    FOREIGN KEY (LearnerID,skill_name) REFERENCES Skills(LearnerID,skill) on update cascade on delete cascade
);

CREATE TABLE Achievement (
    AchievementID INT identity,
    LearnerID INT,
    BadgeID INT,
    description TEXT,
    date_earned DATE,
    type VARCHAR(50),
    primary key (AchievementID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade,
    FOREIGN KEY (BadgeID) REFERENCES Badge(BadgeID) on update cascade on delete cascade
);

CREATE TABLE Reward (
    RewardID INT identity,
    value INT,
    description TEXT,
    type VARCHAR(50)
    primary key (RewardID)
);

CREATE TABLE Quest (
    QuestID INT identity,
    difficulty_level VARCHAR(50),
    criteria VARCHAR(50),
    description TEXT,
    title VARCHAR(255)
    primary key (QuestID)
);


CREATE TABLE Skill_Mastery (
    QuestID INT,
    skill VARCHAR(100),
    PRIMARY KEY(QuestID, skill),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) on update cascade on delete cascade
);

CREATE TABLE Collaborative (
    QuestID INT,
    deadline DATE,
    max_num_participants INT,
    PRIMARY KEY(QuestID),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) on update cascade on delete cascade
);

CREATE TABLE LearnersCollaboration (
    LearnerID INT,
    QuestID INT,
    completion_status VARCHAR(50),
    PRIMARY KEY(LearnerID, QuestID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade,
    FOREIGN KEY (QuestID) REFERENCES Collaborative(QuestID) on update cascade on delete cascade
);

CREATE TABLE LearnerMastery(
    QuestID INT,
    LearnerID INT,
    completionStatus VARCHAR(50),
    PRIMARY KEY (QuestID, LearnerID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade,
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) on update cascade on delete cascade
);

CREATE TABLE Discussion_forum (
    forumID INT identity,
    ModuleID INT,
    CourseID INT,
    title VARCHAR(255),
    last_active DATETIME,
    timestamp DATETIME,
    description TEXT,
    primary key (forumID),
    FOREIGN KEY (ModuleID,CourseID) REFERENCES Modules(ModuleID,CourseID) on update cascade on delete cascade
);

CREATE TABLE LearnerDiscussion (
    ForumID INT,
    LearnerID INT,
    Post VARCHAR(100),
    time DATETIME,
    PRIMARY KEY (ForumID , LearnerID, Post),
    FOREIGN KEY (ForumID) REFERENCES Discussion_forum(forumID) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);
CREATE TABLE QuestReward (
    RewardID INT,
    QuestID INT,
    LearnerID INT,
    Time_earned DATETIME,
    PRIMARY KEY(RewardID, QuestID, LearnerID),
    FOREIGN KEY (RewardID) REFERENCES Reward(RewardID) on update cascade on delete cascade,
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) on update cascade on delete cascade,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) on update cascade on delete cascade
);
