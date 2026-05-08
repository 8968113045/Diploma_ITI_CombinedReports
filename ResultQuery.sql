
Select
AA.ranktypeId , AA.rollNo AS roll, AA.Rank AS ASrank, AA.isWithdrawn , AA.reportingStatus, AA.optionNo AS Alloted_Choice, Course_Master.description as program, 
cat.description AS Alloted_Cat, Institute_Master.description InstituteName,  cat_1.Description AS Candidate_Category, ST.description AllotedQuota , 
state_master.description AS Candidate_State,  AA.reportingStatus AS seatstatus, 
sg.name as SeatGender
,SubCategory_Master.description [subcat] ,pr.description [Priority],
	  mg.description as CandidateGender
into #tempFirstCounselling 
FROM App_Allotment AA 
 INNER JOIN MD_Quota  ST ON AA.allottedQuota = ST.id 
 INNER JOIN  MD_SeatCategory cat ON AA.allottedCat =cat.id 
 INNER JOIN MD_Institute  Institute_Master ON AA.instituteId = Institute_Master.id 
 INNER JOIN  MD_Program Course_Master ON AA.programId = Course_Master.id 
 INNER JOIN           App_CandidateProfile  candidate ON AA.rollNo = candidate.rollno 
 INNER JOIN  MD_Category AS cat_1 ON candidate.categoryId =cat_1.id 
 LEFT OUTER JOIN  MD_SubCategory SubCategory_Master ON  candidate.subcat = SubCategory_Master.id
 LEFT OUTER JOIN  MD_State  state_master ON candidate.domicileId = state_master.id    
 LEFT OUTER JOIN MD_SubCategoryPriority pr on  candidate.subCategoryPriorityList =pr.id
  left join MD_Gender mg on mg.id=candidate.genderId
   left join MD_SeatGender sg on sg.id=aa.seatGenderId
  WHERE   rank<>0 and aa.roundNo=1 AND reportingStatus='RC'
--WHERE  (AA.ranktypeId = @ranktypeId) and rank<>0 and aa.roundNo='1' AND reportingStatus='RC'
ORDER BY aa.rank 

Select  
REPLACE(Stuff( (SELECT   ',' +  CONVERT(varchar(5), CC.optNo) + '-' +( SELECT      description  Inst_Name    FROM   MD_Institute AS IM    
WHERE        (IM.id = CC.instituteId)) + '-' +  (SELECT    M.description Course_Name   FROM  MD_Program AS M   WHERE  (M.id = CC.programId))  
FROM  App_Choice AS CC  WHERE    (cc.rollNo = aa.rollNo) AND (cc.optNo <= 5)  For XML Path('')),1,1,''),'&amp;','and')   AS choices,

AA.ranktypeId , AA.rollNo AS roll, AA.Rank AS ASrank, AA.isWithdrawn , AA.reportingStatus, AA.optionNo AS Alloted_Choice, Course_Master.description as programId, 
cat.description AS Alloted_Cat, Institute_Master.description InstituteName,  cat_1.Description AS Candidate_Category, ST.description AllotedQuota , 
state_master.description AS Candidate_State,  AA.reportingStatus AS seatstatus, 
sg.name as SeatGender
,SubCategory_Master.description [subcat] ,pr.description [Priority],
	  mg.description as CandidateGender
,(case when aa.roundNo=1 then 'Second Counselling' else '' end) as description
,(case when AA.reportingStatus='RU' then FC.Alloted_Cat else '' end) as FCAlloted_Cat,
(case when AA.reportingStatus='RU' then fc.Alloted_Choice else '' end) as FCAlloted_Choice,
(case when AA.reportingStatus='RU' then fc.AllotedQuota else '' end)  as FCAllotedQuota,
(case when AA.reportingStatus='RU' then fc.seatstatus else '' end)  as FCseatstatus,
(case when AA.reportingStatus='RU' then FC.InstituteName else '' end) as FCInstitute,
(case when AA.reportingStatus='RU' then FC.program else '' end) as FCprogram,
(case when AA.reportingStatus='RU' then FC.SeatGender else '' end) as FCSeatGender
--,FC.Alloted_Cat as FCAlloted_Cat,
--fc.Alloted_Choice  as FCAlloted_Choice,
--fc.AllotedQuota  as FCAllotedQuota,
--fc.seatstatus  as FCseatstatus,
--FC.InstituteName  as FCInstitute,
--FC.program  as FCprogram,
--FC.SeatGender as FCSeatGender
FROM App_Allotment AA 
 INNER JOIN MD_Quota  ST ON AA.allottedQuota = ST.id 
 INNER JOIN  MD_SeatCategory cat ON AA.allottedCat =cat.id 
 INNER JOIN MD_Institute  Institute_Master ON AA.instituteId = Institute_Master.id 
 INNER JOIN  MD_Program Course_Master ON AA.programId = Course_Master.id 
 INNER JOIN           App_CandidateProfile  candidate ON AA.rollNo = candidate.rollno 
 INNER JOIN  MD_Category AS cat_1 ON candidate.categoryId =cat_1.id 
 LEFT OUTER JOIN  MD_SubCategory SubCategory_Master ON  candidate.subcat = SubCategory_Master.id
 LEFT OUTER JOIN  MD_State  state_master ON candidate.domicileId = state_master.id    
 LEFT OUTER JOIN MD_SubCategoryPriority pr on  candidate.subCategoryPriorityList =pr.id
  left join MD_Gender mg on mg.id=candidate.genderId
   left join MD_SeatGender sg on sg.id=aa.seatGenderId
    left JOIN #tempFirstCounselling AS FC on FC.roll=aa.rollno 
 -- WHERE  (AA.ranktypeId = 17) and rank<>0 and aa.roundNo=2
WHERE  (AA.ranktypeId = @ranktypeId) and rank<>0 and aa.roundNo=@csno
ORDER BY aa.rank 
drop table #tempFirstCounselling