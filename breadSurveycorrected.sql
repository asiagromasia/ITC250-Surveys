/* Bread survey 7/21/2018 
based on:

  first version of SurveySez tables
  01/29/2015
  
  Here are a few notes on things below that may not be self evident:
  
  INDEXES: You'll see indexes below for example:
  
  INDEX SurveyID_index(SurveyID)
  
  Any field that has highly unique data that is either searched on or used as a join should be indexed, which speeds up a  
  search on a tall table, but potentially slows down an add or delete
  
  TIMESTAMP: MySQL currently only supports one date field per table to be automatically updated with the current time.  We'll use a 
  field in a few of the tables named LastUpdated:
  
  LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP
  
  The other date oriented field we are interested in, DateAdded we'll do by hand on insert with the MySQL function NOW().
  
  CASCADES: In order to avoid orphaned records in deletion of a Survey, we'll want to get rid of the associated Q & A, etc. 
  We therefore want a 'cascading delete' in which the deletion of a Survey activates a 'cascade' of deletions in an 
  associated table.  Here's what the syntax looks like:  
  
  FOREIGN KEY (SurveyID) REFERENCES sm18_surveys(SurveyID) ON DELETE CASCADE
  
  The above is from the Questions table, which stores a foreign key, SurveyID in it.  This line of code tags the foreign key to 
  identify which associated records to delete.
  
  Be sure to check your cascades by deleting a survey and watch all the related table data disappear!
  
  
*/


SET foreign_key_checks = 0; #turn off constraints temporarily

#since constraints cause problems, drop tables first, working backward
DROP TABLE IF EXISTS sm18_responses_answers; 
DROP TABLE IF EXISTS sm18_responses;
DROP TABLE IF EXISTS sm18_answers;
DROP TABLE IF EXISTS sm18_questions;
DROP TABLE IF EXISTS sm18_surveys;
  
#all tables must be of type InnoDB to do transactions, foreign key constraints
CREATE TABLE sm18_surveys(
SurveyID INT UNSIGNED NOT NULL AUTO_INCREMENT,
AdminID INT UNSIGNED DEFAULT 0,
Title VARCHAR(255) DEFAULT '',
Description TEXT DEFAULT '',
DateAdded DATETIME,
LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
TimesViewed INT DEFAULT 0,
Status INT DEFAULT 0,
PRIMARY KEY (SurveyID)
)ENGINE=INNODB; 

#assigning 1nd survey to AdminID == 1
INSERT INTO sm18_surveys VALUES (NULL,2,'Our first survey','Description of Survey',NOW(),NOW(),0,0); 

#foreign key field must match size and type, hence SurveyID is INT UNSIGNED
CREATE TABLE sm18_questions(
QuestionID INT UNSIGNED NOT NULL AUTO_INCREMENT,
SurveyID INT UNSIGNED DEFAULT 0,
Question TEXT DEFAULT '',
Description TEXT DEFAULT '',
DateAdded DATETIME,
LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (QuestionID),
INDEX SurveyID_index(SurveyID),
FOREIGN KEY (SurveyID) REFERENCES sm18_surveys(SurveyID) ON DELETE CASCADE
)ENGINE=INNODB;

INSERT INTO sm18_questions VALUES (NULL,1,'Do you like our website?','We really want to know!',NOW(),NOW());
INSERT INTO sm18_questions VALUES (NULL,1,'Do You like cookies?','We like cookies!',NOW(),NOW());
INSERT INTO sm18_questions VALUES (NULL,1,'what is your favorite add on?','We like sprinkles!',NOW(),NOW());


CREATE TABLE sm18_answers(
AnswerID INT UNSIGNED NOT NULL AUTO_INCREMENT,
QuestionID INT UNSIGNED DEFAULT 0,
Answer TEXT DEFAULT '',
Description TEXT DEFAULT '',
DateAdded DATETIME,
LastUpdated TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
Status INT DEFAULT 0,
PRIMARY KEY (AnswerID),
INDEX QuestionID_index(QuestionID),
FOREIGN KEY (QuestionID) REFERENCES sm18_questions(QuestionID) ON DELETE CASCADE
)ENGINE=INNODB;

INSERT INTO sm18_answers VALUES (NULL,1,'Yes','',NOW(),NOW(),0);
INSERT INTO sm18_answers VALUES (NULL,1,'No','',NOW(),NOW(),0);
INSERT INTO sm18_answers VALUES (NULL,2,'Yes','',NOW(),NOW(),0);
INSERT INTO sm18_answers VALUES (NULL,2,'No','',NOW(),NOW(),0);
INSERT INTO sm18_answers VALUES (NULL,2,'Maybe','',NOW(),NOW(),0);
INSERT INTO sm18_answers VALUES (NULL,3,'Sprinkles','',NOW(),NOW(),0);
INSERT INTO sm18_answers VALUES (NULL,3,'Whipped cream','',NOW(),NOW(),0);
INSERT INTO sm18_answers VALUES (NULL,3,'Cherry','',NOW(),NOW(),0);


CREATE TABLE sm18_responses(
ResponseID INT UNSIGNED NOT NULL AUTO_INCREMENT,
SurveyID INT UNSIGNED NOT NULL DEFAULT 0,
DateAdded DATETIME,
PRIMARY KEY (ResponseID),
INDEX SurveyID_index(SurveyID),
FOREIGN KEY (SurveyID) REFERENCES sm18_surveys(SurveyID) ON DELETE CASCADE
)ENGINE=INNODB;

INSERT INTO sm18_responses VALUES (NULL,1,NOW());


CREATE TABLE sm18_responses_answers(
RQID INT UNSIGNED NOT NULL AUTO_INCREMENT,
ResponseID INT UNSIGNED DEFAULT 0,
QuestionID INT DEFAULT 0,
AnswerID INT DEFAULT 0,
PRIMARY KEY (RQID),
INDEX ResponseID_index(ResponseID),
FOREIGN KEY (ResponseID) REFERENCES sm18_responses(ResponseID) ON DELETE CASCADE
)ENGINE=INNODB;

INSERT INTO sm18_responses_answers VALUES (NULL,1,1,1);
INSERT INTO sm18_responses_answers VALUES (NULL,1,2,5);
INSERT INTO sm18_responses_answers VALUES (NULL,1,3,6);
INSERT INTO sm18_responses_answers VALUES (NULL,1,3,7);
INSERT INTO sm18_responses_answers VALUES (NULL,1,3,8);
SET foreign_key_checks = 1; #turn foreign key check back on
