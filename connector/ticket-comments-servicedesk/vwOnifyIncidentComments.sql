ALTER VIEW [dbo].[vwOnifyIncidentComments] AS 
SELECT
 DISTINCT
 'comment-' + c.ReportProcessCommentID AS 'id',
 'comment,ticket' AS '@tag',
 LOWER(i.IncidentId) AS '@item',
 'servicedesk' AS 'source',
 'info' AS 'level',
 'comment' AS 'category',
 c.DatePosted AS 'timestamp',
 CASE 
	WHEN u.PrimaryEmail IS NOT NULL THEN CONVERT(nvarchar(16), c.DatePosted, 120) + ' // ' + u.DisplayName
	ELSE CONVERT(nvarchar(16), c.DatePosted, 120)
 END AS 'meta.footer',
 CASE 
	WHEN u.OrganizationUnit LIKE '%it%' THEN 'left'
	WHEN u.PrimaryEmail IS NOT NULL AND u.PrimaryEmail = i.PrimaryEmail THEN 'right'
	ELSE 'center'
 END AS 'meta.align',
 '<b>' + c.CommentBrief + '</b><br>' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(c.comment, '\', '\\'), '"', '\"'), '@', '\\@'), char(9), ' '), char(13), '\n'), CHAR(9), ' ') AS 'description',
 DATEDIFF(MINUTE, c.DatePosted, GETDATE()) AS '_minutes'
FROM ReportProcessComment AS c WITH (NOLOCK)
JOIN [vwObjectIncident] AS i ON i.SessionID = c.SessionID
LEFT JOIN [User] AS u ON u.PrimaryEmail = c.UserName OR u.PrimaryEmail = REPLACE(c.CommentBrief, 'Comment from ', '')
WHERE
 (((ModelName IS NULL OR ModelName = 'CommentProcess') AND (c.ProcessViewMessage = 1)) OR (ModelName = 'Initial Diagnosis'))
 AND c.ViewLevel = 0