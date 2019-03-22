use SBTReportingDataMart;
go

WITH SQUAD_JIRA_RELAT AS 
(
SELECT DISTINCT SquadId, JiraProjectValue, JiraProjectDomainId FROM Sbergile.SquadJiraProjectRelation
WHERE IsArchived = 0
AND EndDate IS NULL
),

DOMS as 
(
SELECT DISTINCT * FROM Sbergile.JiraProjectDomain
)

SELECT DISTINCT 
Z.Code as ISU_SBGL_TEAM_CODE_STR,/* Z.Id, Z.Name,*/ 
COALESCE(A.JiraProjectValue,'') as ISU_SBGL_JIRA_PROJECT_KEY,
COALESCE(Z.BoardText,'') as ISU_SBGL_BOARD_ID, 

case
	when LOWER(COALESCE(B.Name,'')) LIKE '%alpha%' AND Z.BoardText IS NOT NULL AND B.Name IS NOT NULL THEN 'A-'+COALESCE(Z.BoardText,'')
	when LOWER(COALESCE(B.Name,'')) LIKE '%sigma%' AND Z.BoardText IS NOT NULL AND B.Name IS NOT NULL THEN 'S-'+COALESCE(Z.BoardText,'')
	when LOWER(COALESCE(B.Name,'')) LIKE '%внешн%' AND Z.BoardText IS NOT NULL AND B.Name IS NOT NULL THEN 'E-'+COALESCE(Z.BoardText,'')
	else ''
end as ISU_SBGL_RAPIDVIEW_ID,

--COALESCE(B.Name,'') as DOMAIN_NAME,
COALESCE(Z.BoardHref, '') as JK_BOARD_HREF 
FROM Sbergile.Squad Z
LEFT JOIN SQUAD_JIRA_RELAT A ON A.SquadId = Z.Id
LEFT JOIN DOMS             B ON B.Id = A.JiraProjectDomainId;

